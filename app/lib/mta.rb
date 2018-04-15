require 'singleton'
require 'resolv'
require 'net/smtp'
require "socket"
require 'dkim'

require_relative '../../config/dkim'
require_relative '../../config/configuration'



# MTA
# Works as a local Smarthost on port 2525
# Supports STARTTLS and DKIM
# Certificates are not verified by default


Dkim::domain = DOMAIN
Dkim::selector = 'mail'
Dkim::private_key = DKIM_PRIVATE_KEY

class Mta
  include Singleton
  
  class Sender
    
    def self.resolve_mx(domain)
      mx = Resolv::DNS.open do |dns|
        dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
      end
      mx.shuffle[0].exchange.to_s
    end
    
    
    def self.send(msg)
      
      data = msg[:data].sub(".\r\n","\r\n").strip.gsub(/\r/, "")
      eml = Eml.new(data, true)
      eml.cleanHeaders
      domain = eml.AddressTo.split('@').last.strip
      server = resolve_mx(domain)
      smtp = Net::SMTP.new(server, 25)
      sslctx = OpenSSL::SSL::SSLContext.new
      sslctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      smtp.enable_starttls_auto(sslctx)
      result = "250 OK\r\n"
      smtp.set_debug_output($stderr) if DEBUG
      
      if DKIM_ON
        helo = Dkim::domain
        message = Dkim.sign(eml.raw)
      else
        helo = DOMAIN
        message = eml.raw
      end
      
      begin
        smtp.start(helo) do |s|
            s.send_message message, eml.AddressFrom, eml.AddressTo
        end
      rescue Exception => e
        result = "500 Error: "+ e.message + "\r\n"
      end
      return result
    end
    
  end
  
  class Server
    
    # thanks @aarongough https://github.com/aarongough
    def initialize(port = 2525)
      @server = TCPServer.new port
      serve()
    end
    
    class Handler
      
      def initialize(ctx)
        puts "MTA: New connection accepted"
        @connection_active = false
        @data_mode = false
        reset_message()
        handle(ctx)
      end
      
      private
      
      def handle(ctx)
          reset_message()
          @connection_active = true
          ctx.puts "220 hello\r\n"
          begin
            while line = ctx.gets
              code = process_line(line, ctx)
              ctx.puts code if code.strip != ''
              puts code if code.strip != '' && DEBUG
              unless @connection_active
                ctx.close
                break
              end
            end
            ctx.puts "221 bye\r\n"
            ctx.close
          rescue
          end
      end
      
      def process_line(line, session)
        case line
        when (/^(HELO|EHLO)/i)
          return "250 localhost go on...\r\n"
        when (/^QUIT/)
          @connection_active = false
          return "221 Closing connection..\r\n"
        when (/^MAIL FROM\:/)
          @message[:from] = line.gsub(/^MAIL FROM\:/, '').strip
          return "250 OK\r\n"
        when (/^RCPT TO\:/)
          @message[:to] << line.gsub(/^RCPT TO\:/, '').strip
          return "250 OK\r\n"
        when (/^DATA/)
          @data_mode = true
          return "354 Enter message, ending with \".\" on a line by itself\r\n"
        end
        
        if(@data_mode && (line.chomp =~ /^\.$/))
          @message[:data] += line
          @data_mode = false
          return send_message(@message)
        end
        
        if(@data_mode)
          @message[:data] += line
          return ""
        else
          return "500 ERROR\r\n"
        end
  
      end
      
      def send_message(message_hash)
        Sender.send(message_hash)
      end
    
      def reset_message
        @message = {:data => "", :to => []}
      end
    end
    
    def serve
      puts "Starting MTA on port 2525"
      loop do
          #Handler.new(@server.accept); 
          Thread.start(@server.accept){|ctx|
            Handler.new(ctx); 
          }
      end
    end
  
    
  end
  
  
  
  class ServerThread < J::Thread
    def run
      Server.new
    end
  end
  
  def stop()
    @thread.stop
  end
  
  def initialize
    @thread = ServerThread.new.start
  end
end
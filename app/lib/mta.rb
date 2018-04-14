require 'singleton'
require 'resolv'
require 'net/smtp'
require "socket"
require 'dkim'

require_relative '../../config/dkim'
require_relative '../../config/configuration'



# MTA


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
      puts msg
      puts "Sending"
      puts 1, mgs
      eml = Eml.new(msg[:data], true)
      puts eml
      eml.cleanHeaders
      puts 2
      domain = eml.AddressTo.split('@').last.strip
      puts domain
      server = resolve_mx(domain)
      puts server
      Net::SMTP.enable_starttls_auto(OpenSSL::SSL::VERIFY_NONE)
      Net::SMTP.start(server, 25, Dkim::domain) do |smtp|
        smtp.send_message Dkim.sign(eml.raw), eml.AddressFrom, eml.AddressTo
      end
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
        puts "New connection accepted"
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
              puts code if code.strip != ''
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
          new_message_event(@message)
          return "250 OK\r\n"
        end
        
        if(@data_mode)
          @message[:data] += line
          return ""
        else
          return "500 ERROR\r\n"
        end
  
      end
      
      def new_message_event(message_hash)
        Sender.send(message_hash)
      end
    
      def reset_message
        @message = {:data => "", :to => []}
      end
    end
    
    def serve
      puts "Starting MTA on port 2525"
      loop do
          Handler.new(@server.accept); 
          #Thread.start(@server.accept){|ctx|
          #  Handler.new(ctx); 
          #}
      end
    end
  
    
  end
  
  
  
  class ServerThread < J::Thread
    def run
      Server.new
    end
  end
  
  def initialize
    server = Server.new
  end
  
end
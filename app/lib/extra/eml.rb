=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end


=begin about

Basic email parser
RFC1341, RFC2387, RFC2046

Usage:

  email = Eml.new(path)
  
  email.From
  email.To
  email.Subject
  email.Date
  email.ContentType
  
  email.Files[]
    File.filename
    File.ContentType
    File.Content
    
  email.Body
    email.Body.Content
    
    email.Body.related?
      email.Body.Html
      email.Body.Images[]
        Image.Content
  
  email.setTo('addr')
  email.setSubject('addr')
  email.copy([box1, box2])
  
=end

require 'net/smtp'
require 'securerandom'
class Eml
  
  attr_accessor(
    :raw,
    :header,
    :From,
    :AddressFrom,
    :To,
    :AddressTo,
    :Subject,
    :SubjectID,
    :Date,
    :XMailer,
    :ContentType,
    :Files,
    :Body
  )
  
  def initialize(data, raw=false)
    unless raw
      @path = data
      @raw = IO.read(@path)
    else
      @raw = data
    end
    parse()
  end
  
  def copy
    Eml.new(@raw, true)
  end
  
  def cleanHeaders
    header = "From: " + @header.split("From: ")[1]
    header = header.sub(/^Message-ID: (.+$)/, "Message-ID: <#{SecureRandom.hex(12)}@nika-relay>")
    @raw = @raw.sub(@header, header)
    parse()
  end
  
  def setTo(addr)
    @raw = @raw.sub(@To, addr)
    parse()
  end
  
  def setFrom(addr)
    @raw = @raw.sub(@From, addr)
    parse()
  end
  
  def setSubject(subj)
    @raw = @raw.sub(@Subject, subj)
    parse()
  end
  
  def copy(*boxes)
    addr = boxes.map { |box|
      box.to_s + '@localhost'
    }
    Net::SMTP.start('localhost', 587) do |smtp|
      body = @raw.sub!(/.*?(?=From:)/im, "")
      smtp.send_message body, 'drop-agent@localhost', *addr
    end
  end
  
  def clean
    File.delete(@path) if File.exist? @path
  end
  
  private
  
  class Part
    attr_accessor(
        :filename,
        :header,
        :ContentType,
        :ContentTransferEncoding,
        :Content,
        :ContentDisposition,
        :ContentID
    )
    def initialize body
      @related = false
      @header = body.split(/^\s*$/)[0]
      @ContentType = /^Content-Type: (.+$)/.match(@header).to_a[1]
      @ContentDisposition = /^Content-Disposition: (.+$)/.match(@header).to_a[1]
      @ContentTransferEncoding = /^Content-Transfer-Encoding: (.+$)/.match(@header).to_a[1]
      @ContentID = /^Content-ID: (.+$)/.match(@header).to_a[1]
      @Content = body.sub(@header,'').strip.split(/^\s*$/)[0].strip
      
      filename = /filename=(.+$)/.match(@header).to_a[1]
      @filename = filename.gsub('"', '').strip unless filename.nil?
      
      if @ContentType.include?('multipart/related')
        @related = true
        parse()
      else
        @Html = ''
        @Images = []
      end
      
    end
    
    def related?
      @related
    end
    
    private
    
    def parse
      boundary = /boundary=(.+$)/.match(@header).to_a[1]
      separator = "--#{boundary}"
      @parts = @Content.split(separator).select {|s|
        s.include?('Content-Type:')
      }.map { |s| Part.new(s.strip) }
      
      @Images = @parts.select {|p|
        p.ContentType.include?('image')
      }
      
      @Html =  @parts.select {|p|
        p.ContentType.include?('text/html')
      }[0]
      
    end
    
  end
  
  def parse
    @header = @raw.split(/^\s*$/)[0]
    @From = /^From: (.+$)/.match(@header).to_a[1]
    @AddressFrom = /\<(.+)\>/.match(@From).to_a[1] || @From
    @To = /^To: (.+$)/.match(@header).to_a[1]
    @AddressTo = /\<(.+)\>/.match(@To).to_a[1] || @To
    @Subject = /^Subject: (.+$)/.match(@header).to_a[1]
    @SubjectID = /Subject: (.*)\[(.+)\]/.match(@header).to_a.last
    @Date = /^Date: (.+$)/.match(@header).to_a[1]
    @XMailer = /^X-Mailer: (.+$)/.match(@header).to_a[1]
    @ContentType = /^Content-Type: (.+$)/.match(@header).to_a[1]
    
    boundary = /boundary=(.+$)/.match(@header).to_a[1]
    @Boundary = boundary.gsub('"', '') unless boundary.nil?
    
    unless boundary.nil?
      separator = "--#{@Boundary}"
      
      @raw_body = @raw[@raw.index(separator)..-1]
      
      @parts = @raw_body.split(separator).select { |s|
        s.include?('Content-Type:')
      }.map { |s| Part.new(s.strip) }
      
      @Files = @parts.select { |p|
        (!p.ContentDisposition.nil? && p.ContentDisposition.include?('attachment'))
      }
      
      @Body = @parts.select {|p|
        p.ContentType.include? 'text'
      }[0]
      
    else
      @Files = []
      @Body = Part.new(@raw)
    end
  
  end
  
 
  
end
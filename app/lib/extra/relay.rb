require 'singleton'
require 'net/smtp'

class Relay < J::Thread
  include Singleton
  RELAY_ROOT = storagedir('relay');
  TICK = 0.05
  
  def handle path
    begin
      eml = Eml.new(path)
      Net::SMTP.start('localhost', 587) do |smtp|
        smtp.send_message eml.raw, 'relay-agent@localhost', eml.AddressTo
      end
      File.delete(path)
    rescue
      puts "Failed to relay an email"
      FileUtils.mkdir_p("#{RELAY_ROOT}/fail")
      FileUtils.mv(path, "#{RELAY_ROOT}/fail/#{path.split('/').last}")
    end
  end  
  
  def check
    files = Dir["#{RELAY_ROOT}/*.relay"]
    for file in files
      handle(file)
    end
  end
  
  def put eml
    dump = eml.raw.sub!(/.*?(?=From:)/im, "").gsub!(/\r/,"")
    name = (0..12).map { (('a'..'z').to_a + ('A'..'Z').to_a)[rand(52)] }.join
    file = "#{RELAY_ROOT}/#{name}.temp"
    f = open(file, 'w')
    f.write(dump)
    f.close()
    FileUtils.mv(file, "#{RELAY_ROOT}/#{name}.relay")
  end
  
  def run
    count = 0
    while true
      check()
      count+=1 if TICK * count < 600
      count = 0 if TICK * count >= 600
      sleep TICK
    end
  end
  
end
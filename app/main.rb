=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end

require 'singleton'
require_relative 'lib/globals'
require_relative 'lib/server'
require_relative 'lib/drops'
require_relative 'lib/console'
require_relative 'lib/mta'

if File.exist?(
    File.dirname(__FILE__).sub('/app', '/web/server.rb')
  )
  require_relative '../web/server'
  class WebUI < J::Thread
    def run
      Server.run!
    end
    
    def interrupt
      super()
    end
  end
  WebUI.new.start
end


class Main < J::Thread
  
  def run
    Mta.instance if MTA_SERVER_ON
    Mireka::ISubmitQue.start() if MTA_SERVER_ON
    Mireka::IRetryQue.start() if MTA_SERVER_ON
    Mireka::IDsnQue.start() if MTA_SERVER_ON
    Mireka.subserver.start() if MX_SERVER_ON
    Mireka.mxserver.start() if MX_SERVER_ON
    Mireka.popserver.start() if POP3_SERVER_ON
    Mireka.rpcserver.start()
  end
  
  def interrupt
    Mireka::ISubmitQue.shutdown() if MTA_SERVER_ON
    Mireka::IDsnQue.shutdown() if MTA_SERVER_ON
    Mireka::IRetryQue.shutdown() if MTA_SERVER_ON
    Mireka.subserver.stop() if MTA_SERVER_ON
    Mireka.mxserver.stop() if MX_SERVER_ON
    Mireka.popserver.shutdown() if POP3_SERVER_ON
    super()
  end
  
end

class ShutdownHook
  include java.lang.Runnable
  def run
    puts 'Shutdown signal received'
    $thread.interrupt()
  end
  java.lang.Runtime.getRuntime.addShutdownHook(java.lang.Thread.new(ShutdownHook.new))
end

$thread = Main.new()
$thread.start()

$drops = MaildropWatcher.new()
$drops.start()




arg = ARGV[0]
if arg == 'console'
  Console.new
else
  $thread.join
end

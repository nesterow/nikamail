require 'singleton'
require_relative 'lib/globals'
require_relative 'lib/server'
require_relative 'lib/drops'
require_relative 'lib/console'


class Main < J::Thread
  
  def run
    Mireka::ISubmitQue.start()
    Mireka::IRetryQue.start()
    Mireka::IDsnQue.start()
    Mireka.subserver.start()
    Mireka.mxserver.start()
    Mireka.popserver.start()
    Mireka.rpcserver.start()
  end
  
  def interrupt
    Mireka::ISubmitQue.shutdown()
    Mireka::IDsnQue.shutdown()
    Mireka::IRetryQue.shutdown()
    Mireka.subserver.stop()
    Mireka.mxserver.stop()
    Mireka.popserver.shutdown()
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

drops = MaildropWatcher.new()
drops.start()

arg = ARGV[0]
if arg == 'console'
  Console.new
else
  $thread.join
end

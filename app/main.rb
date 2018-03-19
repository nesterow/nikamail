require 'singleton'
require_relative 'lib/config'
require_relative 'lib/server'
require_relative 'lib/console'


class Main < J::Thread
  
  def run
    Mireka.subserver.start()
    Mireka.mxserver.start()
    Mireka.popserver.start()
    Mireka.submitque.start()
    Mireka.retryque.start()
    Mireka.rpcserver.start()
  end
  
  def interrupt
    Mireka.subserver.stop()
    Mireka.mxserver.stop()
    Mireka.popserver.shutdown()
    Mireka.submitque.shutdown()
    Mireka.retryque.shutdown()
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

arg = ARGV[0]

if arg == 'console'
  Console.new
else
  $thread.join
end

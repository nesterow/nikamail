require 'singleton'

require_relative 'lib/config'
require_relative 'lib/server'
require_relative 'lib/console'

class ShutdownHook
  include java.lang.Runnable
  def run
    puts 'Shutdown signal received'
    Mireka.popserver.shutdown()
    Mireka.submitque.shutdown()
    Mireka.retryque.shutdown()
  end
  java.lang.Runtime.getRuntime.addShutdownHook(java.lang.Thread.new(ShutdownHook.new))
end

t1 = Thread.new do
  Mireka.subserver.start()
  Mireka.mxserver.start()
  Mireka.popserver.start()
  Mireka.submitque.start()
  Mireka.retryque.start()
  Mireka.rpcserver.start()
end

Console.new


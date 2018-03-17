require 'singleton'

require_relative 'lib/config'
require_relative 'lib/server'
  
class MailServer
  include Singleton

  def initialize
    @thread = nil
    @running = false
    start()
  end

  def start
    @thread = Thread.new {
      Mireka.subserver.start()
      Mireka.mxserver.start()
      Mireka.popserver.start()
      Mireka.submitque.start()
      Mireka.retryque.start()
      @running = true
    }
    @thread
  end

  def stop
    @thread = Thread.new {
      Mireka.subserver.shutdown()
      Mireka.mxserver.shutdown()
      Mireka.popserver.shutdown()
      Mireka.submitque.shutdown()
      Mireka.retryque.shutdown()
      @running = false
    }
    @thread
  end

  def restart
    Thread.new {
      stop()
      sleep(5)
      start()
    }
  end
  
end

Mireka.subserver.start()
Mireka.mxserver.start()
Mireka.popserver.start()
Mireka.submitque.start()
Mireka.retryque.start()
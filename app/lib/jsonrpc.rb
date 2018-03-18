require 'jimson'

module Mireka
  
  class JsonRpcServer
    extend Jimson::Handler
    
    def ping
      'pong'
    end
    
  end
  
  
  
end
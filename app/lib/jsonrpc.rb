=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end

require 'jimson'

module Mireka
  
  class JsonRpcServer
    extend Jimson::Handler
    
    def ping
      'pong'
    end
    
    def exit
      java.lang.System.exit(0)
    end
    
    def finduser name
      users = Mireka.getUsers.select {|u|
        u.getUsernameObject().toString().start_with? name.to_s
      }.map {|u|
        u.getUsernameObject().toString()
      }
      users
    end
    
    def adduser name, password
      Mireka.addUser username: name.to_s, password: password.to_s
      "OK"
    end
    
    def deluser name
      Mireka.removeUser(name)
      "OK"
    end
    
    def password name, password
      Mireka.removeUser(name)
      Mireka.addUser username: name.to_s, password: password.to_s
      "OK"
    end
    
    def forward from, *to
      Mireka.addForwarding from, *to
      "OK"
    end
    
    def unforward from, *to
      Mireka.removeForwarding from, *to
      "OK"
    end
    
    def domains
      HOST_LIST
    end
    
    def setdomain *arg
      Mireka.addDomains(*arg)
      "OK"
    end
    
    def deldomain *arg
      Mireka.removeDomains(*arg)
      "OK"
    end
    
    def setalias from, to
      Mireka.addAlias(from, to)
      "OK"
    end
    
    def delalias from
      Mireka.removeAlias(from)
      "OK"
    end
    
  end
  
  
  
end
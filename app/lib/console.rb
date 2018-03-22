class Console
  
  def initialize
    sleep 1
    require 'irb'
    
    @dir = File.dirname(__FILE__)
    
    IRB.setup(nil)
    IRB.conf[:AUTO_INDENT] = true
    IRB.conf[:APP_NAME] = "nika"
    IRB.conf[:PROMPT_MODE] = :SIMPLE
    
    workspace = IRB::WorkSpace.new(binding)
    irb = IRB::Irb.new(workspace)
    IRB.conf[:MAIN_CONTEXT] = irb.context
    puts "NikaMail v0.1a ~ Mireka@f1ecbe5"
    puts "Entering Console"
    irb.eval_input
  end
  
  def exit
    java.lang.System.exit(0)
  end
  
  def ping
    'pong'
  end
  
  def finduser name
    users = Mireka.getUsers.select {|u|
      u.getUsernameObject().toString().start_with? name.to_s
    }.map {|u|
      u.getUsernameObject().toString()
    }
    puts "Search results:"
    puts users
    puts 'Not Found' if users.length == 0
    users.length
  end
  
  def adduser name, password
    begin
      Mireka.addUser username: name.to_s, password: password.to_s
      puts "User '#{name}' added"
    rescue Exception => e
      puts e.message
    end
    name
  end
  
  def deluser name
    begin
      Mireka.removeUser(name)
      puts "User #{name} removed"
    rescue Exception => e
      puts e.message
    end
    name
  end
  
  def password name, password
    begin
      Mireka.removeUser(name)
      Mireka.addUser username: name.to_s, password: password.to_s
      puts 'Password Changed'
    rescue Exception => e
      puts e.message
    end
    name
  end
  
  def forward from, *to
    Mireka.addForwarding from, *to
  end
  
  def unforward from, *to
    Mireka.removeForwarding from, *to
  end
  
  def domains
    puts 'Host List:'
    puts HOST_LIST
    0
  end
  
  def setdomain *arg
    Mireka.addDomains(*arg)
  end
  
  def deldomain *arg
    Mireka.removeDomains(*arg)
  end
  
  def setalias from, to
    Mireka.addAlias(from, to)
  end
  
  def delalias from
    Mireka.removeAlias(from)
  end
  
  def genssl
    generate_cert()
  end
  
  def help
    puts """
      METHODS:
        help -> Print This Message
        
        finduser name -> Find user by name
        adduser name, password -> Add New User
        deluser name -> Remove user
        password user, password -> Change user password
        
        forward email, *recipients -> forward email to 'recipients'
        unforward email, *recipients || :all -> remove forwarding for specified recipients
        
        alias name, alias -> Add alias address
        delalias name -> Remove alias
        
        domains -> Print domain list
        setdomain name1, name2 -> Add hostnames to list
        deldomain name1, name2 -> Remove domains from list
        
        genssl  -> Generate a self-signed certificate
        importssl -> Import authorory-signed certificate
        
        exit -> Exit
      
      ENVIRONMENT:
        Mireka -> Module::Mireka
        WebUI -> (Available in NikaMail Pro)
        
    """
  end
  
  
  
end
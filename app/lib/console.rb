class Console
  
  def initialize
    sleep 1
    require 'irb'
    
    IRB.setup(nil)
    IRB.conf[:AUTO_INDENT] = true
    IRB.conf[:APP_NAME] = "nika"
    IRB.conf[:PROMPT_MODE] = :SIMPLE
    
    workspace = IRB::WorkSpace.new(binding)
    irb = IRB::Irb.new(workspace)
    IRB.conf[:MAIN_CONTEXT] = irb.context
    puts "NikaMail v0.1a :: Console"
    irb.eval_input
  end
  
  def exit
    java.lang.System.exit(0)
    Kernel.exit
  end
  
  def ping
    'pong'
  end
  
end
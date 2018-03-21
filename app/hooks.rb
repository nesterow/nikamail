# Post-processing hooks
module Hooks
  
  def self.registry
  @r||={
    
      mario: [ method(:printme) ]
  
  }
  end
  
  def self.printme(file)
    puts "Post-prcessing is here"
    puts file
  end
  

end
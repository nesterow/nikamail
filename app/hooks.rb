# Post-processing hooks
module Hooks
  
  def self.registry
  @r||={
    
      mario: [ method(:print_mario_emails) ]
  
  }
  end
  
  def self.print_mario_emails(eml)
    puts "Post-processing is here"
    puts "
      From: #{eml.From}
      Subject: #{eml.Subject}
      Date: #{eml.Date}
      Files: #{eml.Files.map {|f| f.filename}}
      Body: #{eml.Body.Content}
    "
  end
  

end
# Post-processing hooks
module Hooks
  
  def self.registry
  @r||={
    
      mario: [ method(:print_mario_emails), method(:redirect_mario_email) ]
  
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
  
  def self.redirect_mario_email(eml)
    eml.setSubject("Redirected")
    eml.copy(:luigi, :princess)
  end
  

end
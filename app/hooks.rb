# Post-processing hooks
require_relative "lib/extra/listings"

module Hooks
  
  def self.load_extensions
    ListingsExtension.new(@registry)
  end
  
  def self.registry
    return @registry if @registry
    @registry={
      
      mario: [ method(:print_mario_emails), method(:redirect_mario_email) ]
    
    }
    load_extensions()
    return @registry
  end
  
  
  
  def self.print_mario_emails(eml)
    puts "Post-processing is here"
    puts "
      From: #{eml.From}
      Subject: #{eml.Subject}
      SubjectID: #{eml.SubjectID}
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
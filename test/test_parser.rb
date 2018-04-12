require_relative '../app/lib/extra/eml'

gmail = "#{File.dirname(__FILE__)}/gmail.eml"

eml = Eml.new(gmail)

puts eml.From
puts eml.To
puts eml.Subject
puts eml.Body.Content
puts eml.ContentType
=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end

require_relative "relay"
RELAY = Relay.instance
RELAY.start()

class ListingsExtension
  
  def initialize(registry)
    lists = []
    for l in Dir["#{storagedir("lists")}/*.list"]
      begin 
        lists.push Marshal.load(File.read(l))
      rescue Exception => e
        puts e.message 
      end
    end

    @listings = {}
    for list in lists
      @listings["#{list[:relay]}@#{DOMAIN}"] = @listings["#{list[:mailbox]}@#{DOMAIN}"] = list
      case list[:type]
      when 'subscription'
        registry[list[:relay]] = [method(:handle)]
      when 'privategroup'
        registry[list[:mailbox]] = [method(:handle)]
      when 'opengroup'
        registry[list[:relay]] = [method(:unsubscribe)]
        registry[list[:mailbox]] = [method(:handle)]
      end
    end
  end
  
  def handle(eml)
    data = @listings[eml.AddressTo.strip]
    type = data[:type]
    case type
    when 'subscription'
      handle_subscription(eml, data)
    when 'privategroup'
      handle_privategroup(eml, data)
    end
    
  end
  
  def handle_subscription(eml, data)
    list = data[:list]
    from = "#{data[:name]} <#{data[:mailbox]}@#{DOMAIN}>"
    
    sender = eml.AddressFrom.strip
    return if sender != data[:sender]
    
    list.each { |k|
      email = Eml.new(eml.raw, true)
      email.cleanHeaders
      email.setTo(k["address"])
      email.setFrom(from)
      RELAY.put(email)
    }
  end
  
  def unsubscribe(eml)
    data = @listings[eml.AddressTo.strip]
  end
  
  def handle_privategroup(eml, data)
    list = data[:list]
    sender = eml.AddressFrom.strip
    member = list.select { |k|
      k['address'].include?("<#{sender}>")
    }[0]
    return unless member
    
    from = "#{member['address'].sub!(/\<(.*)\>/,'')} <#{data[:mailbox]}@#{DOMAIN}>"
    list.select { |k| k['address'] != member['address']}.each { |k|
      email = Eml.new(eml.raw, true)
      email.cleanHeaders
      email.setTo(k["address"])
      email.setFrom(from)
      RELAY.put(email)
    }
  end

end

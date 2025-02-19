=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end

require 'java'

module Mireka
  include_package "mireka"
  include_package "mireka.destination"
  include_package "mireka.filter"
  include_package "mireka.filter.misc"
  include_package "mireka.filter.dnsbl"
  include_package "mireka.filter.local"
  include_package "mireka.filter.local.table"
  include_package "mireka.filter.proxy"
  include_package "mireka.filter.spf"
  include_package "mireka.filterchain"
  include_package "mireka.forward"
  include_package "mireka.list"
  include_package "mireka.login"
  include_package "mireka.pop"
  include_package "mireka.pop.store"
  include_package "mireka.smtp"
  include_package "mireka.smtp.client"
  include_package "mireka.smtp.server"
  include_package "mireka.startup"
  include_package "mireka.submission"
  include_package "mireka.transmission"
  include_package "mireka.transmission.dsn"
  include_package "mireka.transmission.immediate"
  include_package "mireka.transmission.immediate.host"
  include_package "mireka.transmission.queue"
  include_package "mireka.transmission.queuing"
  
  def self.inject(obj)
    DependencyInjection.addInjectable(obj)
    Lifecycle.addManagedObject(obj)
    return obj
  end
  
  def self.domains
    return @domains if @domains
    @domains = InlineDomainRegistry.new()
    @domains.setRemoteParts(HOST_LIST)
    inject(@domains)
    @domains
  end
  
  def self.addDomains *arg
    File.open(confile('host.list'), 'a') { |f|
      for domain in arg
        f.puts "#{domain}\n"
      end
      f.close
    }
    puts "Restart server to apply changes"
  end
  
  def self.removeDomains *arg
    filtered = HOST_LIST.select {|d| !arg.include?(d) }
    File.delete(confile('host.list'))
    File.open(confile('host.list'), 'a') { |f|
      for domain in filtered
        f.puts "#{domain}\n"
      end
      f.close
    }
    puts "Restart server to apply changes"
  end
  
  ISrs = Srs.new
  #ISrs.set_secret_key('470F1A70470F1A70')
  ISrs.setLocalDomains(domains)
  inject(ISrs)
  
  
  REPOSITORY = MaildropRepository.new()
  REPOSITORY.setDir(folder('storage/maildrops'))
  inject(REPOSITORY)
  
  

end

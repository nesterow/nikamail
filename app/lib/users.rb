
module Mireka
  
  java_import "mireka.login.IGlobalUsers"
  
  class LoginSpec
    java_implements Mireka::LoginSpecification
    java_signature 'LoginResult evaluatePlain(String username, String password)'
    java_signature 'LoginResult evaluateApop(String username, String timestamp, byte[] digestBytes)'
  
    def initialize
      @usernamePasswordMap = java.util.HashMap.new
      @usernamePrincipalMap = java.util.HashMap.new
    end
  
    def evaluatePlain(usernameString,password)
      username = Mireka::Username.new(usernameString)
      actualPassword = @usernamePasswordMap.get(username)
      if actualPassword.nil?
        return Mireka::LoginResult.new(Mireka::LoginDecision::USERNAME_NOT_EXISTS, nil);
      elsif check_password(password, actualPassword)
        return Mireka::LoginResult.new(Mireka::LoginDecision::VALID, @usernamePrincipalMap.get(username));
      else
        return Mireka::LoginResult.new(Mireka::LoginDecision::PASSWORD_DOES_NOT_MATCH, nil);
      end
    end
  
    def setUser(user)
      @usernamePasswordMap.put(user.getUsernameObject(), user.getPassword())
      @usernamePrincipalMap.put(user.getUsernameObject(), Mireka::Principal.new(user.getUsernameObject().toString()))
    end
  
    def removeUser(name)
      user = nil
      for u in USERS
        if u.getUsernameObject().toString() == name
          user = u
          break
        end
      end
      return if user.nil?
      @usernamePasswordMap.remove(user.getUsernameObject())
      @usernamePrincipalMap.remove(user.getUsernameObject())
    end
  
    def setUsers(users)
      @usernamePasswordMap.clear()
      @usernamePrincipalMap.clear()
      for user in users
        @usernamePasswordMap.put(user.getUsernameObject(), user.getPassword())
        @usernamePrincipalMap.put(user.getUsernameObject(), Mireka::Principal.new(user.getUsernameObject().toString()))
      end
    end
    
  
  end
  
  def self.getUsers
    users = STORAGE.all
    result = []
    users.keys.each {|name|
      user = GlobalUser.new()
      user.setUsername(name)
      user.setPassword(users[name])
      result.push user
    }
    return result
  end
  
  def self.addUser **data
    
    unless STORAGE.get(data[:username]).nil?
      raise "User Aready Exists"
    end
    data[:password] = hash_password(data[:password])
    user = GlobalUser.new()
    user.setUsername(data[:username])
    user.setPassword(data[:password])
    ILoginSpecification.setUser(user)
    STORAGE.add(data[:username], data[:password])
    USERS.addUser(user)
  end
  
  def self.removeUser name
    if STORAGE.get(name).nil?
      raise "User Does't Exist"
    end
    ILoginSpecification.removeUser(name)
    USERS.removeUser(name)
    STORAGE.remove(name)
  end
  
  def self.forward from, *recipients
    members = []
    for addr in recipients
      m = Member.new()
      m.setAddress(addr)
      members.push(inject(m))
    end
    
    f = ForwardDestination.new()
    f.setSrs(ISrs)
    f.setTransmitter(PrimaryTransmitter)
    f.setMembers(members)
    
    dest = RecipientDestinationPair.new()
    dest.setRecipient(from)
    dest.setDestination(inject(f))
    
    return inject(dest)
  end
  
  def self.addForwarding from, *recipients
    list = FLISTSDB.get(from) || []
    list = list + recipients
    FLISTSDB.add(from, list)
    puts 'Restart server in order to apply changes'
  end
  
  def self.removeForwarding from, *recipients
    
    
    if recipients.length == 0
      puts "Specify either recipients or use :all symbol to remove all"
      return
    end
    
    if recipients[0] == :all
      FLISTSDB.remove(from)
      puts "Forwarding list was removed"
      puts 'Restart server in order to apply changes'
      return
    end
    
    list = (FLISTSDB.get(from) || []).select { |addr|
      !recipients.include? addr
    }
    FLISTSDB.add(from, list)
    puts 'Restart server in order to apply changes'
  end
  
  
  def self.setalias aliasAddr, targetAddr
    adest = AliasDestination.new
    adest.setRecipient(targetAddr)
    dest = RecipientDestinationPair.new
    dest.setRecipient(aliasAddr)
    dest.setDestination(inject(adest))
    inject(dest)
  end
  
  def self.addAlias from, to
    ALIASDB.add(from, to) 
    puts 'Restart server in order to apply changes'
  end
  
  def self.removeAlias from
    ALIASDB.remove(from) 
    puts 'Restart server in order to apply changes'
  end
  

  POSTMASTER = PostmasterAliasMapper.new()
  POSTMASTER.setCanonical("postmaster@#{DOMAIN}")
  inject(POSTMASTER)
  
  STORAGE = Storage.new('users.storage')
  
  
  USERS = IGlobalUsers.new()
  USERS.setUsers(getUsers())
  inject(USERS)
  
  IMaildropRepository = GlobalUsersMaildropDestinationMapper.new()
  IMaildropRepository.setUsers(USERS)
  IMaildropRepository.setMaildropRepository(REPOSITORY)
  inject(IMaildropRepository)
  
  ILoginSpecification = LoginSpec.new()
  ILoginSpecification.setUsers(USERS)
  inject(ILoginSpecification)
  
  
  IForwardList = []
  FLISTSDB = Storage.new('forwarding.storage')
  flist = FLISTSDB.all
  flist.keys.each { |from|
    destinations = flist[from]
    IForwardList.push(forward(from, *destinations))
  }
  
  IAliasesList = []
  ALIASDB = Storage.new('aliases.storage')
  alist = ALIASDB.all
  alist.keys.each { |from|
    to = alist[from]
    IAliasesList.push(setalias(from, to))
  }
  
  RecipientSpec = RecipientSpecificationDestinationPair.new()
  
  ISrsDestination = SrsDestination.new()
  ISrsDestination.setSrs(ISrs)

  RecipientSpec.setRecipientSpecification(inject(SrsRecipientSpecification.new()))
  RecipientSpec.setDestination(inject(ISrsDestination))
  inject(RecipientSpec)
  
  LocalRecipientsTable = LocalRecipientTable.new()
  LocalRecipientsTable.setLocalDomains(domains)
  LocalRecipientsTable.setMappers(IForwardList + IAliasesList + [IMaildropRepository, POSTMASTER, RecipientSpec])
  inject(LocalRecipientsTable)
  
  SubmissionRecipientTable = RecipientTable.new()
  pair = RecipientSpecificationDestinationPair.new()
  pair.setRecipientSpecification(inject(AnyRecipient.new()))
  pair.setDestination(inject(TransmitterDestination.new()))
  SubmissionRecipientTable.setMappers([LocalRecipientsTable, pair])
  inject(SubmissionRecipientTable)
  
  
 
  
end

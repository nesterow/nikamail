require 'java'

module Mireka
  
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
      elsif actualPassword == password
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
    user = GlobalUser.new()
    user.setUsername(data[:username])
    user.setPassword(data[:password])
    USERS.addUser(user)
    ILoginSpecification.setUser(user)
    STORAGE.add(data[:username], data[:password])
  end
  
  def self.removeUser name
    ILoginSpecification.removeUser(name)
    STORAGE.remove(name)
  end
  
  POSTMASTER = PostmasterAliasMapper.new()
  puts 1111111
  POSTMASTER.setCanonical("postmaster@#{DOMAIN}")
  inject(POSTMASTER)
  
  STORAGE = Storage.new('users.storage')
  
  USERS = GlobalUsers.new()
  USERS.setUsers(getUsers())
  inject(USERS)
  
  IMaildropRepository = GlobalUsersMaildropDestinationMapper.new()
  IMaildropRepository.setUsers(USERS)
  IMaildropRepository.setMaildropRepository(REPOSITORY)
  inject(IMaildropRepository)
  
  ILoginSpecification = LoginSpec.new()
  ILoginSpecification.setUsers(USERS)
  inject(ILoginSpecification)
  
  RecipientSpec = RecipientSpecificationDestinationPair.new()
  RecipientSpec.setRecipientSpecification(inject(SrsRecipientSpecification.new()))
  RecipientSpec.setDestination(inject(SrsDestination.new()))
  inject(RecipientSpec)
  
  LocalRecipientsTable = LocalRecipientTable.new()
  LocalRecipientsTable.setLocalDomains(domains)
  LocalRecipientsTable.setMappers([REPOSITORY, POSTMASTER, RecipientSpec])
  inject(LocalRecipientsTable)
  
  SubmissionRecipientTable = RecipientTable.new()
  pair = RecipientSpecificationDestinationPair.new()
  pair.setRecipientSpecification(inject(AnyRecipient.new()))
  pair.setDestination(inject(TransmitterDestination.new()))
  SubmissionRecipientTable.setMappers([LocalRecipientsTable, pair])
  inject(SubmissionRecipientTable)
  
  
 
  
end

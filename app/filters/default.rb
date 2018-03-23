module Mireka
  
  IAuthIPAddress = ConnectedFromAuthorizedIpAddress.new
  IAuthIPAddress.setAddresses([
    IpAddress.new('127.0.0.1')
  ])
  
  SubRejectIfUnauthenticatedFilter = RejectIfUnauthenticated.new
  SubRejectIfUnauthenticatedFilter.setAuthenticatedSpecifications([
    inject(SmtpAuthenticated.new),
    inject(IAuthIPAddress)
  ])
  
  
  SubLookupDestinationFilter = LookupDestinationFilter.new
  
  RemoteSpec = RecipientSpecificationDestinationPair.new
  RemoteSpec.setRecipientSpecification(inject(AnyRecipient.new))
  SubTransmitter = TransmitterDestination.new
  SubTransmitter.setTransmitter(PrimaryTransmitter)
  RemoteSpec.setDestination(inject(SubTransmitter))
  inject(RemoteSpec)
  
  SubRecipientTable = RecipientTable.new
  SubRecipientTable.setMappers([
    LocalRecipientsTable,
    RemoteSpec
  ])
  inject(SubRecipientTable)
  
  SubLookupDestinationFilter.setRecipientDestinationMapper(SubRecipientTable)

  SavePostmasterMailFilter = SavePostmasterMail.new
  SavePostmasterMailFilter.setDir(folder("storage/mail/postmaster"))
  
  
  MxLookupDestinationFilter = LookupDestinationFilter.new
  MxLookupDestinationFilter.setRecipientDestinationMapper(LocalRecipientsTable)
  
  MxProhibitRelayingFilter = ProhibitRelaying.new
  MxProhibitRelayingFilter.setLocalDomainSpecifications([domains])
  
  MxRefuseBlacklistedRecipientFilter = RefuseBlacklistedRecipient.new
  BL = Mireka::Dnsbl.new
  BL.setDomain("zen.spamhaus.org.")
  MxRefuseBlacklistedRecipientFilter.setBlacklists([inject(BL)])
  

end
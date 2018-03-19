module Mireka
  
  SubRejectIfUnauthenticatedFilter = RejectIfUnauthenticated.new
  SubRejectIfUnauthenticatedFilter.setAuthenticatedSpecifications([inject(SmtpAuthenticated.new)])
  
  #SubMeasureTrafficFilter = MeasureTraffic.new()
  #SubMeasureTrafficFilterSmtpSummary = IncomingSmtpSummary.new
  #SubMeasureTrafficFilterSmtpSummary.setName('submission')
  #SubMeasureTrafficFilter.setIncomingSmtpSummary(inject(SubMeasureTrafficFilterSmtpSummary))
  #
  
  SubLookupDestinationFilter = LookupDestinationFilter.new
  SubLookupDestinationFilter.setRecipientDestinationMapper(LocalRecipientsTable)

  
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
=begin

  Anton A. Nesterov (c) 2018, CC-BY-SA 4.0
  License: https://creativecommons.org/licenses/by-sa/4.0/

=end

Dir["#{File.dirname(__FILE__)}/filters/*.rb"].each do |filter|
  require filter
end

module Mireka
  
  SUBMISSION_FILTERS = [
    SubRejectIfUnauthenticatedFilter,
    SubLookupDestinationFilter,
    RejectLargeMail.new,
    AcceptGlobalPostmaster.new,
    AcceptDomainPostmaster.new,
    AcceptAllRecipient.new,
    SavePostmasterMailFilter,
    StopLoop.new,
    DestinationProcessorFilter.new,
  ]
  
  MX_FILTERS = [
    MxLookupDestinationFilter,
    RejectLargeMail.new,
    AddReceivedSpfHeader.new,
    TarpitOnGlobalRejections.new,
    AcceptGlobalPostmaster.new,
    MxProhibitRelayingFilter,
    AcceptDomainPostmaster.new,
    MxRefuseBlacklistedRecipientFilter,
    RefuseUnknownRecipient.new,
    RejectOnFailedSpfCheck.new,
    AcceptAllRecipient.new,
    SavePostmasterMailFilter,
    StopLoop.new,
    DestinationProcessorFilter.new,
  ]
  
  
  MxFilters = Filters.new
  MxFilters.setFilters(MX_FILTERS.map {|f|
    inject(f)
  })
  inject(MxFilters)
  
  SubFilters = Filters.new
  SubFilters.setFilters(SUBMISSION_FILTERS.map {|f|
    inject(f)
  })
  inject(SubFilters)
  
  
end
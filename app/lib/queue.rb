module Mireka
  ILogIdFactory = inject(LogIdFactory.new())
  PrimaryTransmitter = inject(QueuingTransmitter.new())
  DsnTransmitter = inject(QueuingTransmitter.new())
  RetryTransmitter = inject(QueuingTransmitter.new())
  OutgoingRegistry = inject(OutgoingConnectionsRegistry.new())
  
  IMailToHostTransmitter = MailToHostTransmitter.new()
  IMailToHostTransmitter.setOutgoingConnectionRegistry(OutgoingRegistry)
  IMailToHostTransmitter.setLogIdFactory(ILogIdFactory)
  
  IClientFactory = ClientFactory.new
  IClientFactory.setHelo(DOMAIN)
  
  DirectSender = DirectImmediateSender.new()
  DirectSender.setClientFactory(inject(IClientFactory))
  DirectSender.setMailToHostTransmitter(inject(IMailToHostTransmitter))
  inject(DirectSender)
  
  MailCreator = DsnMailCreator.new()
  MailCreator.setReportingMtaName(DOMAIN)
  MailCreator.setFromAddress(MAILER)
  inject(MailCreator)
  
  
  IRetryPolicy = RetryPolicy.new()
  IRetryPolicy.setDsnMailCreator(MailCreator)
  IRetryPolicy.setDsnTransmitter(DsnTransmitter)
  IRetryPolicy.setRetryTransmitter(RetryTransmitter)
  inject(IRetryPolicy)
  
  ISubStore = FileDirStore.new(
    java.io.File.new(folder('storage/queue/submitted')),
    1024.to_int
  )
  ISubmitQue = ScheduleFileDirQueue.new(
    inject(ISubStore),
    PrimaryTransmitter,
    java.util.concurrent.ScheduledThreadPoolExecutor.new(10)
  )
  inject(ISubmitQue)
  
  PrimaryTransmitter.setQueue(ISubmitQue)
  PrimaryTransmitter.setImmediateSender(DirectSender)
  PrimaryTransmitter.setRetryPolicy(IRetryPolicy)
  PrimaryTransmitter.setLogIdFactory(ILogIdFactory)
  ts = TransmitterSummary.new()
  ts.setName('submission')
  ts.register()
  PrimaryTransmitter.setSummary(inject(ts))
  inject(PrimaryTransmitter)
  
  
  DsnStore = FileDirStore.new(
    java.io.File.new(folder('storage/queue/dsn')),
    1024.to_int
  )
  IDsnQue = ScheduleFileDirQueue.new(
    inject(DsnStore),
    PrimaryTransmitter,
    java.util.concurrent.ScheduledThreadPoolExecutor.new(10)
  )
  inject(IDsnQue)
  
  
  DsnTransmitter.setQueue(IDsnQue)
  DsnTransmitter.setImmediateSender(DirectSender)
  DsnTransmitter.setRetryPolicy(IRetryPolicy)
  DsnTransmitter.setLogIdFactory(ILogIdFactory)
  ts1 = TransmitterSummary.new()
  ts1.setName('dsn')
  ts1.register()
  DsnTransmitter.setSummary(inject(ts1))
  inject(DsnTransmitter)
  
  
  RetryStore = FileDirStore.new(
    java.io.File.new(folder('storage/queue/retry')),
    1024.to_int
  )
  IRetryQue = ScheduleFileDirQueue.new(
    inject(DsnStore),
    PrimaryTransmitter,
    java.util.concurrent.ScheduledThreadPoolExecutor.new(10)
  )
  inject(IRetryQue)
  
    
  RetryTransmitter.setQueue(IRetryQue)
  RetryTransmitter.setImmediateSender(DirectSender)
  RetryTransmitter.setRetryPolicy(IRetryPolicy)
  RetryTransmitter.setLogIdFactory(ILogIdFactory)
  ts1 = TransmitterSummary.new()
  ts1.setName('retry')
  ts1.register()
  RetryTransmitter.setSummary(inject(ts1))
  inject(RetryTransmitter)
  
  
  
  
end
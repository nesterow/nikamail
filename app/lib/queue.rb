module Mireka
  
  def self.mail2host_tx
    mailToHostTransmitter = MailToHostTransmitter.new()
    mailToHostTransmitter.setOutgoingConnectionRegistry(OutgoingRegistry)
    mailToHostTransmitter.setLogIdFactory(ILogIdFactory)
    mailToHostTransmitter
  end
  
  def self.submitque
    return @submitque if @submitque
    
    @submitque = ScheduleFileDirQueue.new()
    subStore = FileDirStore.new()
    subStore.setDir(folder('storage/queue/submitted'))
    subStore.setMaxSize(1024)
    @submitque.setStore(inject(subStore))
    @submitque.setMailProcessorFactory(PrimaryTransmitter)
    @submitque.setThreadCount(10)
    @submitque
  end
  
  def self.retryque
    return @retryque if @retryque
    
    @retryque = ScheduleFileDirQueue.new()
    retStore = FileDirStore.new()
    retStore.setDir(folder('storage/queue/retry'))
    retStore.setMaxSize(1024)
    @retryque.setStore(inject(retStore))
    @retryque.setMailProcessorFactory(RetryTransmitter)
    @retryque.setThreadCount(5)
    @retryque
  end
  
  def self.dsnque
    return @dsnque if @dsnque
    
    @dsnque = ScheduleFileDirQueue.new()
    dsnStore = FileDirStore.new()
    dsnStore.setDir(folder('storage/queue/dsn'))
    dsnStore.setMaxSize(1024)
    @dsnque.setStore(inject(dsnStore))
    @dsnque.setMailProcessorFactory(DsnTransmitter)
    @dsnque.setThreadCount(5)
    @dsnque
  end

  
  PrimaryTransmitter = inject(QueuingTransmitter.new())
  DsnTransmitter = inject(QueuingTransmitter.new())
  RetryTransmitter = inject(QueuingTransmitter.new())
  ILogIdFactory = inject(LogIdFactory.new())
  OutgoingRegistry = inject(OutgoingConnectionsRegistry.new())
  
  DirectSender = DirectImmediateSender.new()
  DirectSender.setMailToHostTransmitter(mail2host_tx)
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
  
  
  PrimaryTransmitter.setQueue(submitque)
  PrimaryTransmitter.setImmediateSender(DirectSender)
  PrimaryTransmitter.setRetryPolicy(IRetryPolicy)
  PrimaryTransmitter.setLogIdFactory(ILogIdFactory)
  ts = TransmitterSummary.new()
  ts.setName('submission')
  ts.register()
  PrimaryTransmitter.setSummary(inject(ts))
  
  
  DsnTransmitter.setQueue(dsnque)
  DsnTransmitter.setImmediateSender(DirectSender)
  DsnTransmitter.setRetryPolicy(IRetryPolicy)
  DsnTransmitter.setLogIdFactory(ILogIdFactory)
  ts1 = TransmitterSummary.new()
  ts1.setName('dsn')
  DsnTransmitter.setSummary(inject(ts1))
  
  RetryTransmitter.setQueue(retryque)
  RetryTransmitter.setImmediateSender(DirectSender)
  RetryTransmitter.setRetryPolicy(IRetryPolicy)
  RetryTransmitter.setLogIdFactory(ILogIdFactory)
  ts1 = TransmitterSummary.new()
  ts1.setName('retry')
  RetryTransmitter.setSummary(inject(ts1))
  

  
end
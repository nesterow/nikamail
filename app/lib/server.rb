require_relative './mireka'
require_relative './queue'
require_relative './users'
require_relative './filter'
require_relative '../filters'
require_relative './jsonrpc'

java_import "org.subethamail.smtp.auth.EasyAuthenticationHandlerFactory"

module Mireka
  
  
  def self.subserver
    return @subserver if @subserver
    usernamePasswordValidator = UsernamePasswordValidatorImpl.new()
    usernamePasswordValidator.setLoginSpecification(LoginSpecification);
    inject(usernamePasswordValidator)
    submissionMessageHandler = MessageHandlerFactoryImpl.new()
    submissionMessageHandler.setFilters(SubFilters)
    inject(submissionMessageHandler)
    @submission = SubmissionServer.new(submissionMessageHandler)
    authenticationHandlerFactory = EasyAuthenticationHandlerFactory.new(usernamePasswordValidator)
    @submission.setAuthenticationHandlerFactory(authenticationHandlerFactory)
    @submission.setHostName(DOMAIN)
    @submission.setEnableTLS(true)
    inject(@submission)
  end
  
  def self.mxserver
    return @mxserver if @mxserver
    mxMessageHandler = MessageHandlerFactoryImpl.new
    mxMessageHandler.setFilters(MxFilters)
    inject(mxMessageHandler)
    @mxserver = SMTPServer.new(mxMessageHandler)
    @mxserver.setHostName(DOMAIN)
    @mxserver.setEnableTLS(true)
    inject(@mxserver)
  end
 
  
  def self.popserver
    return @popserver if @popserver
    @popserver = PopServer.new()
    @popserver.setLoginSpecification(LoginSpecification)
    @popserver.setPrincipalMaildropTable(inject(GlobalUsersPrincipalMaildropTable.new()))
    @popserver.setMaildropRepository(REPOSITORY)
    @popserver.setTlsConfiguration(inject(JsseDefaultTlsConfiguration.new()))
    inject(@popserver)
  end
  
  def self.rpcserver
    return @rpcserver if @rpcserver
    @rpcserver = Jimson::Server.new(JsonRpcServer.new, port: JSONRPC_PORT)
    return @rpcserver
  end
  


end
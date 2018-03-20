module Kernel
  require 'java'
  require_relative "./utils"
  require_relative '../../lib/ext.jar'
  
  #javaconf("logback.configurationFile", confile("logback.xml"));
  javaconf("javax.net.ssl.keyStore", confile("keystore.jks"));
  javaconf("javax.net.ssl.keyStorePassword", "password");
  
  SHA1_SALT = 'a6f519d72b910000'
  
  DOMAIN = File.read(confile('hostname')).strip()
  DOMAIN = 'localhost' if DOMAIN.length == 0
  JSONRPC_PORT = 12080
  
  if File.exists?('/etc/hostname')
    LOCAL_DOMAIN = File.read('/etc/hostname').strip()
  else
    LOCAL_DOMAIN = 'local'
  end
  
  HOST_LIST = [DOMAIN, LOCAL_DOMAIN, 'localhost'] + File.read(confile('host.list')).strip().split("\n")
  
  class Storage
    def initialize path
      @path = path
      load()
    end
    
    def load
      data = File.read(confile(@path))
      @data = data.length != 0 && Marshal.load(data) || Hash.new
      @data
    end
    
    def save
      dump = Marshal.dump(@data)
      file = File.open confile(@path), 'w'
      file.write(dump)
      file.close
      load()
    end
    
    def get k
      @data[k]
    end
    
    def add k,v
      @data[k] = v
      save()
    end
    
    def remove k
      @data.delete(k)
      save()
    end
    
    def length
      @data.length
    end
    
    def all &block
      yield(@data) if block_given?
      @data
    end
    
  end


end
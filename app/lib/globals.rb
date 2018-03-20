module Kernel
  require 'java'
  require_relative "./utils"
  require_relative '../../lib/ext.jar'
  require_relative '../../config/configuration'

  javaconf("logback.configurationFile", confile("logback.xml")) unless DEBUG
  javaconf("javax.net.ssl.keyStore", confile(KEYSTORE))
  javaconf("javax.net.ssl.keyStorePassword", KEYSTORE_PASSWORD)
  
  HOST_LIST = ['localhost', DOMAIN ] + File.read(confile('host.list')).strip().split("\n")
  
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
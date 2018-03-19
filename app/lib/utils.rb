require 'fileutils'

module J
  java_import "java.lang.Thread"
end

module FFIProcess
  require 'ffi'
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
  attach_function :fork, [], :int
end

def javaconf prop, value
  java.lang.System.setProperty(prop, value)
end

def folder(path)
  root = File.dirname(__FILE__).gsub('/lib','').gsub('/app', '/')
  path = "#{root}/#{path}"
  unless Dir.exist? path
    FileUtils.mkdir_p(path)
  end
  path
end

def confile(path)
  root = File.dirname(__FILE__).gsub('/lib','').gsub('/app', '/config')
  unless Dir.exist? root
    FileUtils.mkdir_p(root)
  end
  file = "#{root}/#{path}"
  FileUtils.touch file
  return file
end


def generate_cert
  path = confile("keystore.jks")
  File.delete(path) if File.file?(path)
  out = `keytool -genkey -keyalg RSA -alias servercert -dname \"CN=sweet, OU=SWF, O=SWEET, L=SWEET, S=SWEET, C=GB\" -keystore #{path} -storepass password -keypass password -validity 1440 -keysize 2048 -noprompt`
end


def import_cert(cer, key)
  path = confile("keystore.jks")
  File.delete(path) if File.file?(path)
  File.delete("#{path}.p12") if File.file?("#{path}.p12")
  system("openssl pkcs12 -export -name servercert -in #{cer} -inkey #{key} -out #{path}.p12 -password pass:password")
  cmd = "keytool -importkeystore -destkeystore #{path} -srckeystore #{path}.p12 -srcstoretype pkcs12 -srcstorepass password -storepass password -keypass password -noprompt -alias servercert"
  system(cmd)
  File.delete("#{path}.p12")
end

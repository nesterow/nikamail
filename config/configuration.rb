load confile('server.rb')
load confile('keystore.rb')

DEBUG = false
DOMAIN = File.read(confile('domain.fqdn'))
JSONRPC_PORT = 12080
SHA1_SALT = 'a6f519d72b910000'
STARTTLS = true

NikaMail ~0.1a
========
Portable SMTP/POP3 server and MTA for JVM featuring JRuby.
**NikaMail** is a zero-config solution. You can run it without wasting  time on pre-configuration. Only dependency is Java.
**NikaMail** is **[Mireka](http://mireka.org/)** on JRuby.

* SMTP Server
* POP3 Server
* MTA
* STARTTLS
* JSON-RPC
* Email post-processing
* JRuby
* [Mireka](http://mireka.org/) filters in java




Installation
------------

1. Install Dependencies
    - `sudo apt install openjdk-8-jdk-headless`
    - `sudo apt install docker.io` - docker
    - `sudo gpasswd -a $USER docker` - add yourself to docker group
    - `newgrp docker` - refresh group permissions

2. Clone & Buld
    - `git clone git@bitbucket.org:nesterow/nikamail.git` - clone latest version from 'master' branch
    - `cd ./nikamail` 
    - `make build`

3. Run interactive console
    - `make console`
    
### Can it run without docker?
    * Yes! The command is `bin/jruby app/main.rb`

Commands
--------
```
    make build         - (re)build docker container and java extensions
    make console       - run ineractive console
    make run           - run NikaMail
    make start         - run NikaMail in daemon mode
    make stop          - stop daemon
    make restart       - restart daemon
```


Configuration
-------------

### Managing
There are two ways to manage server:

1. Using command line tool
2. Using JSON RPC.

#### Using command line
NikaMail command line tool is simply a Ruby IRB. That means you should use all commands as you would use ruby methods.

Example:
```ruby

    (irb)> adduser 'mario', 'password123'  # add a new user
    (irb)> adduser 'luiji', 'password123'
    (irb)> setalias 'mario+castle@domain.fqdn', 'mario@domain.fqdn' # set alias
    (irb)> forward 'bros@domain.fqdn', 'mario@domain.fqdn', 'luiji@domain.fqdn'

```
- Server does not need restart when you add new users.
- However you have to restart server after adding *aliases*, *forward lists*, *mailing lists* and other *filters*


### STARTTLS/SSL

* Import a certificate signed for your domain into Java Key Store.
```
    keytool -importcert -file certificate.cer -keystore keystore.jks -alias servercert
```

* Or generate a self-signed certificate
```
    keytool -genkey -keyalg RSA -alias servercert -dname "CN=1, OU=2, O=2, L=4, S=5, C=GB" -keystore keystore.jks  -storepass password -keypass password -validity 1440 -keysize 2048 -noprompt
```

* Put `keystore.jks` to the `config` directory


* Edit `configuration.rb` as follows:
```ruby
STARTTLS = true
KEYSTORE = "keystore.jks"
KEYSTORE_PASSWORD = "password"
```


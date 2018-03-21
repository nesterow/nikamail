NikaMail
========
- SMTP Server
- SMTP MTA
- POP3 Server
- STARTTLS

NikaMail is Mireka on JRuby.


##### *Currently in pre-alpha development. There can be untested features on 'master' branch before complete release


Installation
------------

1. Install Dependencies
    - `sudo apt install openjdk-8-jdk-headless`
    - `sudo apt install docker.io` - Docker
    - `sudo gpasswd -a $USER docker` - Add yourself to docker group
    - `newgrp docker` - Refresh group permissions

2. Clone & Buld
    - `git clone git@bitbucket.org:nesterow/nikamail.git` - Clone latest version from 'master' branch
    - `cd ./nikamail` 
    - `make build`

3. Run interactive console
    - `make console`
    

Commands
--------
```
    make build         - (re)build docker container and java extensions
    make console       - run ineractive console
    make run           - run NikaMail
    make run-daemon    - run NikaMail in daemon mode
    make stop-daemon   - stop daemon
```


Configuration
-------------

### STARTTLS/SSL

1. Import a certificate signed for your domain into Java Key Store.
```
    keytool -importcert -file certificate.cer -keystore keystore.jks -alias servercert
```

2. Or generate a self-signed certificate
```
    keytool -genkey -keyalg RSA -alias servercert -dname "CN=1, OU=2, O=2, L=4, S=5, C=GB" -keystore keystore.jks  -storepass password -keypass password -validity 1440 -keysize 2048 -noprompt
```

3. Put `keystore.jks` to the `config` directory


4. Edit `configuration.rb` as follows:
```ruby
STARTTLS = true
KEYSTORE = "keystore.jks"
KEYSTORE_PASSWORD = "password"
```

### Managing NikaMail
There are two ways to manage server: 1. Using command line tool 2. Using JSON RPC.

#### 1. Using command line
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



NikaMail
========

Installation
------------

1. Install Dependencies
    - `sudo apt install docker.io` - Docker
    - `sudo gpasswd -a $USER docker` - Add yourself to docker group
    - `newgrp docker` - Refresh group permissions

2. Clone & Buld
    - `git clone git@bitbucket.org:nesterow/nikamail.git` - Clone latest version from 'master' branch
    - `cd ./nikamail` 
    - `make build`


3. Commands
```
    make build         - (re)build docker container
    make run           - run NikaMail and interactive console
    make run-daemon    - run NikaMail in daemon mode
    make stop-daemon   - stop daemon
```


Configuration
-------------

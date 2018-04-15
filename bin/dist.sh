#!/usr/bin/env bash

rm -f config/.install_lock
rm -f config/host.list
rm -f config/domain.fqdn
rm -f config/update*
rm -f config/keystore.rb
rm -r storage

echo -n "local" > config/host.list
echo -n "localhost" > config/domain.fqdn
echo -n $'KEYSTORE_PASSWORD="password"\nKEYSTORE="keystore.jks"\nKEYSTORE_ALIAS="servercert"' > config/keystore.rb
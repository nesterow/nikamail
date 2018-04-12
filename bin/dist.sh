#!/usr/bin/env bash

rm config/.install_lock
rm config/host.list
rm config/domain.fqdn
rm config/update*
rm config/keystore.rb
rm -r storage

echo -n "local" > config/host.list
echo -n "localhost" > config/domain.fqdn
echo -n $'KEYSTORE_PASSWORD="password"\nKEYSTORE="keystore.jks"\nKEYSTORE_ALIAS="servercert"' > config/keystore.rb
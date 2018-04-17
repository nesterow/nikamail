#!/usr/bin/env bash
rm -rf /tmp/NikaMail_dist
rm -rf /tmp/NikaMail.tar.xz 
cp -r . /tmp/NikaMail_dist
rm -f /tmp/NikaMail_dist/config/.install_lock
rm -f /tmp/NikaMail_dist/config/host.list
rm -f /tmp/NikaMail_dist/config/domain.fqdn
rm -f /tmp/NikaMail_dist/config/update*
rm -f /tmp/NikaMail_dist/config/keystore.rb
rm -f /tmp/NikaMail_dist/config/dkim.rb
rm -rf /tmp/NikaMail_dist/storage
rm -rf /tmp/NikaMail_dist/.git
rm -rf /tmp/NikaMail_dist/web/.git
echo -n "local" > /tmp/NikaMail_dist/config/host.list
echo -n "localhost" > /tmp/NikaMail_dist/config/domain.fqdn
echo -n $'KEYSTORE_PASSWORD="password"\nKEYSTORE="keystore.jks"\nKEYSTORE_ALIAS="servercert"' > /tmp/NikaMail_dist/config/keystore.rb
echo -n $'DKIM_ON=false\nDKIM_PRIVATE_KEY=File.read(confile('dkim.key'));' > /tmp/NikaMail_dist/config/dkim.rb
rm -f /tmp/installer.run
cp bin/installer.run  /tmp/installer.run

cd  /tmp/NikaMail_dist && tar -cf - . | xz -9 -c - > /tmp/NikaMail.tar.xz 
cat /tmp/NikaMail.tar.xz >> /tmp/installer.run
rm /tmp/NikaMail.tar.xz 
rm -rf /tmp/NikaMail_dist
mv /tmp/installer.run ~/Documents/nika.run
chmod u+x ~/Documents/nika.run


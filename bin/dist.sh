#!/usr/bin/env bash

rm config/.install_lock
rm config/host.list
rm config/domain.fqdn
rm config/update*
rm -r storage
echo "local" > config/host.list
echo "localhost" > domain.fqdn
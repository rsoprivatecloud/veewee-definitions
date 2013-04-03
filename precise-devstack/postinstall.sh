#!/bin/sh
apt-get update
apt-get install -qqy git build-essential
git clone https://github.com/openstack-dev/devstack.git
chown -R stack. devstack
cd devstack
echo ADMIN_PASSWORD=password > localrc
echo MYSQL_PASSWORD=password >> localrc
echo RABBIT_PASSWORD=password >> localrc
echo SERVICE_PASSWORD=password >> localrc
echo SERVICE_TOKEN=tokentoken >> localrc
echo ENABLED_SERVICES="$ENABLED_SERVICES,-rabbit,-qpid,zeromq" >> localrc
./stack.sh

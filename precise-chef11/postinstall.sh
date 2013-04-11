#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

apt-get install -y vim-tiny wget ssl-cert curl acpid

CHEF_SERVER_VERSION=${CHEF_SERVER_VERSION:-11.0.6}

PRIMARY_INTERFACE=$(ip route list match 0.0.0.0 | awk 'NR==1 {print $5}')
#MY_IP=$(ip addr show dev ${PRIMARY_INTERFACE} | awk 'NR==3 {print $2}' | cut -d '/' -f1)
MY_IP=169.254.123.2
CHEF_UNIX_USER=${CHEF_UNIX_USER:-root}
# due to http://tickets.opscode.com/browse/CHEF-3849 CHEF_FE_PORT is not used yet
CHEF_FE_PORT=${CHEF_FE_PORT:-80}
CHEF_FE_SSL_PORT=${CHEF_FE_SSL_PORT:-443}
CHEF_URL=${CHEF_URL:-https://${MY_IP}:${CHEF_FE_SSL_PORT}}

HOMEDIR=$(getent passwd ${CHEF_UNIX_USER} | cut -d: -f6)
export HOME=${HOMEDIR}

curl -L "http://www.opscode.com/chef/download-server?p=ubuntu&pv=12.04&m=x86_64&v=${CHEF_SERVER_VERSION}" > /tmp/chef-server.deb
dpkg -i /tmp/chef-server.deb
chef-server-ctl reconfigure

mkdir -p ${HOMEDIR}/.chef
cp /etc/chef-server/{chef-validator.pem,chef-webui.pem,admin.pem} ${HOMEDIR}/.chef
chown -R ${CHEF_UNIX_USER}: ${HOMEDIR}/.chef

if [[ ! -e ${HOMEDIR}/.chef/knife.rb ]]; then
    cat <<EOF | /opt/chef-server/embedded/bin/knife configure
${HOMEDIR}/.chef/knife.rb
${CHEF_URL}
admin
chef-webui
${HOMEDIR}/.chef/chef-webui.pem
chef-validator
${HOMEDIR}/.chef/chef-validator.pem

ch3fz11
EOF
    # setup the path
    echo 'export PATH=${PATH}:/opt/chef-server/embedded/bin' >> ${HOMEDIR}/.profile
fi

apt-get autoremove
apt-get clean
rm -f /tmp/chef-server.deb 
# rm -rf /var/cache

cat >> /etc/sysctl.conf <<END
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
END

cat > /etc/network/interfaces <<END
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
        address 169.254.123.2
        netmask 255.255.255.0
        network 169.254.123.0
        broadcast 169.254.123.255
        gateway 169.254.123.1
        # dns-* options are implemented by the resolvconf package, if installed
        dns-nameservers 8.8.8.8
        dns-search rackspace.com
END

echo "rack        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/rack
chmod 0440 /etc/sudoers.d/rack

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty console=ttyS0 console=hvc0"/' /etc/default/grub
grub-install /dev/vda
update-grub2

dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

#dd if=/dev/zero of=/tmp/zeros
#rm -f /tmp/zeros

exit

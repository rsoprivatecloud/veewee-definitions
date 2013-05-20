#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

apt-get install -y vim-tiny wget ssl-cert curl acpid

cat >> /etc/sysctl.conf <<END
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
END

echo "rack        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/rack
chmod 0440 /etc/sudoers.d/rack

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty console=ttyS0 console=hvc0"/' /etc/default/grub
install-grub /dev/vda
update-grub



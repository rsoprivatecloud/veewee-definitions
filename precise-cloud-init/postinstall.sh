#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

#echo "cloud-init cloud-init/datasources string NoCloud, OVF, Ec2" > /tmp/debconf-selections
#/usr/bin/debconf-set-selections /tmp/debconf-selections
#rm -f /tmp/debconf-selections

apt-get install -y vim-tiny wget ssl-cert curl acpid cloud-init cloud-utils cloud-initramfs-growroot

sed -i 's/^user: ubuntu/user: stack/g' /etc/cloud/cloud.cfg
sed -i 's/^# datasource_/datasource_/' /etc/cloud/cloud.cfg

echo "stack        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty console=ttyS0 console=hvc0"/' /etc/default/grub
install-grub /dev/vda
update-grub

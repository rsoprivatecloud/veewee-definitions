#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

apt-get install -y vim-tiny wget ssl-cert curl acpid cloud-init cloud-utils #cloud-initramfs-growroot

sed -i 's/^user: ubuntu/user: stack/g' /etc/cloud/cloud.cfg

cat > /etc/rc.local <<END
    [[ ! -f /etc/dont_grow ]] && \
        growpart /dev/vda 2 | fgrep 'CHANGED:' && \
        shutdown -r now
END

# some os stuffs
#usermod -a -G sudo $SUDO_USER
#cp /etc/sudoers /etc/sudoers.orig
#sed -i -e 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers
echo "stack        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack

chown -R $SUDO_USER:$SUDO_USER .

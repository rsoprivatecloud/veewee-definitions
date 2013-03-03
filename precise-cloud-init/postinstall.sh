#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

apt-get install -y vim-tiny wget ssl-cert curl acpid cloud-init cloud-utils cloud-initramfs-growroot

sed -i 's/^user: ubuntu/user: stack/g' /etc/cloud/cloud.cfg

# cat > /etc/rc.local <<END
#     PATH="$PATH:/sbin"
#     #ROOTPART=\`parted -s /dev/vda print | awk '/boot/ {print \$1}'\`
#     ROOTPART=\`sfdisk -d /dev/vda 2>&1 | awk '\$1 ~ "/dev/vda" && \$8 == "bootable" {gsub("/dev/vda", "", \$1); print \$1}'\`
#     [[ ! -f /etc/dont_grow ]] && \\
#         growpart /dev/vda \$ROOTPART | fgrep 'CHANGED:' && \\
#         shutdown -r now
# END

echo "stack        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack

sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty console=ttyS0 console=hvc0"/' /etc/default/grub
update-grub

#chown -R $SUDO_USER:$SUDO_USER .

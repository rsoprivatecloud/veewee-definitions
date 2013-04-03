yum install -y http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum -y update
yum -y upgrade
yum install -y cloud-init

## why is /usr/bin/growpart 0 bytes when installed this way?
# yum install -y http://kojipkgs.fedoraproject.org//packages/cloud-utils/0.27/0.2.bzr216.fc18/noarch/cloud-utils-0.27-0.2.bzr216.fc18.noarch.rpm

wget http://kojipkgs.fedoraproject.org//packages/cloud-utils/0.27/0.2.bzr216.fc18/src/cloud-utils-0.27-0.2.bzr216.fc18.src.rpm
rpm2cpio cloud-utils-0.27-0.2.bzr216.fc18.src.rpm | cpio -id
tar xzf cloud-utils-0.27-bzr216.tar.gz cloud-utils-0.27-bzr216/bin/growpart
install -m 0755 cloud-utils-0.27-bzr216/bin/growpart /usr/bin/growpart
rm -rf cloud-utils*

sed -i 's/^user: ec2-user/user: stack/g' /etc/cloud/cloud.cfg

cat >> /etc/rc.local <<END
    for dev in \`awk '\$1 ~ /^eth/ {print \$1}' /proc/net/dev\` ; do
        dev=\${dev/:/}
        script=/etc/sysconfig/network-scripts/ifcfg-\$dev
        if [[ ! -f \$script ]] ; then
            cat > \$script <<EOF
DEVICE="\$dev"
BOOTPROTO="dhcp"
IPV6INIT="no"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"
EOF
        fi
    done
    sed -i 's/IPV6INIT="yes"/IPV6INIT="no"/' /etc/sysconfig/network-scripts/ifcfg-*
    [[ ! \`grep GATEWAYDEV /etc/sysconfig/network\` ]] && \\
        echo GATEWAYDEV=eth0 >> /etc/sysconfig/network
    service network restart
    PATH="$PATH:/sbin"
    #ROOTPART=\`parted -s /dev/vda print | awk '/boot/ {print \$1}'\`
    ROOTPART=\`sfdisk -d /dev/vda 2>&1 | awk '\$1 ~ "/dev/vda" && \$8 == "bootable" {gsub("/dev/vda", "", \$1); print \$1}'\`
    [[ ! -f /etc/growroot-disabled ]] && \\
        growpart /dev/vda \$ROOTPART | fgrep 'CHANGED:' && \\
        shutdown -r now
END

sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -n > /etc/udev/rules.d/70-persistent-net.rules
echo -n > /lib/udev/rules.d/75-persistent-net-generator.rules
chattr +i /etc/udev/rules.d/70-persistent-net.rules
chattr +i /lib/udev/rules.d/75-persistent-net-generator.rules

cat >> /etc/sysctl.conf <<END
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
END

# needed for console logging in kvm
sed -i 's/kernel.*/& console=tty console=ttyS0 console=hvc0/' /boot/grub/grub.conf # pci=nobfsort

exit
wget http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
rpm -Uvh epel*
rm -f epel*

yum -y update
yum -y upgrade
yum install -y vim-enchanced man man-pages acpid cloud-init

#wget http://kojipkgs.fedoraproject.org/packages/cloud-utils/0.27/0.2.bzr216.fc18/noarch/cloud-utils-0.27-0.2.bzr216.fc18.noarch.rpm
#rpm -Uvh cloud-utils*

wget http://kojipkgs.fedoraproject.org//packages/cloud-utils/0.27/0.2.bzr216.fc18/src/cloud-utils-0.27-0.2.bzr216.fc18.src.rpm
rpm2cpio cloud-utils-0.27-0.2.bzr216.fc18.src.rpm | cpio -id
tar xzf cloud-utils-0.27-bzr216.tar.gz cloud-utils-0.27-bzr216/bin/growpart
install -m 0755 cloud-utils-0.27-bzr216/bin/growpart /usr/bin/growpart
rm -rf cloud-utils*

sed -i 's/^user: ec2-user/user: stack/g' /etc/cloud/cloud.cfg

cat > /etc/rc.local <<END
    for dev in \`awk '\$1 ~ /^eth/ {print \$1}' /proc/net/dev\` ; do
        dev=\${dev/:/}
        script=/etc/sysconfig/network-scripts/ifcfg-\$dev
        if [[ ! -f \$script ]] ; then
            cat > \$script <<EOF
DEVICE="\$dev"
BOOTPROTO="dhcp"
IPV6INIT="yes"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"
EOF
        fi
    done
    if [[ ! \`grep GATEWAYDEV /etc/sysconfig/network\` ]]; then
        echo GATEWAYDEV=eth0 >> /etc/sysconfig/network
        #shutdown -r now
        service network restart
    fi
    [[ ! -f /etc/dont_grow ]] && \
        growpart /dev/vda 2 | fgrep 'CHANGED:' && \
        shutdown -r now
END

sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -n > /etc/udev/rules.d/70-persistent-net.rules
echo -n > /lib/udev/rules.d/75-persistent-net-generator.rules

# needed for console logging in kvm
sed -i 's/kernel.*/& console=tty console=ttyS0 console=hvc0/' /boot/grub/grub.conf # pci=nobfsort

exit

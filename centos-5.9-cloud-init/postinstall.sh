yum -y update
yum -y upgrade

yum install -y http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
yum install -y http://kojipkgs.fedoraproject.org//packages/cloud-utils/0.27/0.2.bzr216.fc18/noarch/cloud-utils-0.27-0.2.bzr216.fc18.noarch.rpm
yum install -y vim man man-pages acpid acpitools cloud-init

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
    if [[ ! -f /etc/dont_grow ]] ; then
        if [[ \`growpart /dev/vda 2 | fgrep 'CHANGED:'\` ]] ; then
            shutdown -r now
        fi
    fi
END

sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -n > /etc/udev/rules.d/70-persistent-net.rules
echo -n > /lib/udev/rules.d/75-persistent-net-generator.rules

# needed for console logging in kvm
sed -i 's/kernel.*/& console=tty console=ttyS0 console=hvc0/' /boot/grub/grub.conf # pci=nobfsort

exit

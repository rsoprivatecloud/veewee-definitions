#cat > /etc/yum.repos.d/epel.repo <<END
#[epel]
#name=epel
#baseurl=http://mirror.us.leaseweb.net/epel/5/x86_64/
#gpgcheck=0
#END

yum -y update
yum -y upgrade

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release*

yum install -y vim man man-pages acpid acpitools cloud-init

#/usr/sbin/useradd -m stack
#echo 'stack ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sed -i 's/^user: ec2-user/user: stack/g' /etc/cloud/cloud.cfg

# cat > /etc/rc.local <<END
#   sed -i "s/HWADDR=\".*\"/HWADDR=\"`ip a s eth1 | awk '/link\// {print $2}'`\"/" /etc/sysconfig/network-scripts/ifcfg-eth0
#   rm -rf /etc/udev/rules.d/70-persistent-net.rules
#   udevadm trigger 
# END

sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -n > /etc/udev/rules.d/70-persistent-net.rules
echo -n > /lib/udev/rules.d/75-persistent-net-generator.rules

# needed for console logging in kvm
sed -i 's/kernel.*/& console=tty console=ttyS0 console=hvc0/' /boot/grub/grub.conf # pci=nobfsort

exit


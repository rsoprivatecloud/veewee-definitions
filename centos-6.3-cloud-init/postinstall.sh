
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

yum install -y cloud-init

#/usr/sbin/useradd -m stack
#echo 'stack ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sed -i 's/^user: ec2-user/user: stack/g' /etc/cloud/cloud.cfg

cat > /etc/rc.local <<END
echo -n > /etc/udev/rules.d/70-persistent-net.rules
exit
END

exit

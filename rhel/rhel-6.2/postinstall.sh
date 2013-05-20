yum -y update
yum -y upgrade

# need to blow away udev rules so no stale interfaces remain after booting from snapshot
sed -i '/^HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
echo -n > /etc/udev/rules.d/70-persistent-net.rules

# needed for boot logging in kvm
sed -i 's/kernel.*/& console=tty console=ttyS0 console=hvc0/' /boot/grub/grub.conf # pci=nobfsort

exit

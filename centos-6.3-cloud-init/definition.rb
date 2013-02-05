Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size=> '1024',
  :disk_size => '4096',
  :disk_format => 'qcow2',
  :hostiocache => 'off',
  :ioapic => 'on',
  :pae => 'on',
  :os_type_id => 'RedHat_64',
  :iso_file => "CentOS-6.3-x86_64-minimal.iso",
  :iso_src => "http://www.mirrorservice.org/sites/mirror.centos.org/6.3/isos/x86_64/CentOS-6.3-x86_64-minimal.iso",
  :iso_md5 => "087713752fa88c03a5e8471c661ad1a2",
  :iso_download_timeout => 10000,
  :boot_wait => "10",
  :boot_cmd_sequence => [
    '<Tab> text ks=http://%IP%:%PORT%/ks.cfg<Enter>'
  ],
  :kickstart_port => "7122",
  :kickstart_timeout => 10000,
  :kickstart_file => "ks.cfg",
  :ssh_login_timeout => "10000",
  :ssh_user => "stack",
  :ssh_password => "stack",
  :ssh_key => "",
  :ssh_host_port => "7222",
  :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S bash '%f'",
  :shutdown_cmd => "/sbin/halt -h -p",
  :postinstall_files => [
    "postinstall.sh"
  ],
  :postinstall_timeout => 10000
})
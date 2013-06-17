Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size=> '1024',
  :disk_size => '19456',
  :disk_format => 'qcow2',
  :hostiocache => 'on',
  :ioapic => 'on',
  :pae => 'on',
  :os_type_id => 'RedHat_64',
  :iso_file => "rhel-server-6.4-x86_64-dvd.iso",
  :iso_src => "http://kickstart.rackspace.com/isos/redhat/6.4/x86_64/rhel-server-6.4-x86_64-dvd.iso",
  :iso_md5 => "",
  :iso_download_timeout => 10000,
  :boot_wait => "20",
  :boot_cmd_sequence => [
    '<Tab> text ks=http://%IP%:%PORT%/ks.cfg<Enter>'
  ],
  :kickstart_port => "7122",
  :kickstart_timeout => 10000,
  :kickstart_file => "ks.cfg",
  :ssh_login_timeout => "10000",
  :ssh_user => "root",
  :ssh_password => "qwerty",
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

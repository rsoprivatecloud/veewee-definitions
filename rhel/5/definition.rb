$defaults = {
  :cpu_count => '1',
  :memory_size=> '1024',
  :disk_size => '4096',
  :disk_format => 'qcow2',
  :hostiocache => 'on',
  :ioapic => 'on',
  :pae => 'on',
  :os_type_id => 'RedHat_64',
  :iso_download_timeout => 10000,
  :boot_wait => "20",
  :boot_cmd_sequence => [
    'linux text ks=http://%IP%:%PORT%/ks.cfg<Enter>'
  ],
  :kickstart_file => "ks.cfg",
  :kickstart_port => "7122",
  :kickstart_timeout => 10000,
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
}

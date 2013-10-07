require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'rhel-server-6.2-x86_64-dvd.iso'
definition.iso_src = 'http://kickstart.rackspace.com/isos/redhat/6.2/x86_64/rhel-server-6.2-x86_64-dvd.iso'
definition.iso_md5 = '7525d7ea1b1fd074538c7505bccd143d'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'rhel-server-6.1-x86_64-dvd.iso'
definition.iso_src = 'http://kickstart.rackspace.com/isos/redhat/6.1/x86_64/rhel-server-6.1-x86_64-dvd.iso'
definition.iso_md5 = 'a051dbf28ef444a019dc6660efe3e3a4'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

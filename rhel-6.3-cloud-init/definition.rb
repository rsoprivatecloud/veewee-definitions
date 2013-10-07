require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'rhel-server-6.3-x86_64-dvd.iso'
definition.iso_src = 'http://kickstart.rackspace.com/isos/redhat/6.3/x86_64/rhel-server-6.3-x86_64-dvd.iso'
definition.iso_md5 = 'd717af33dd258945e6304f9955487017'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

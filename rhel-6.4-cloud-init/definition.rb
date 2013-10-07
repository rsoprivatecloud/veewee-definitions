require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'rhel-server-6.4-x86_64-dvd.iso'
definition.iso_src = 'http://kickstart.rackspace.com/isos/redhat/6.4/x86_64/rhel-server-6.4-x86_64-dvd.iso'
definition.iso_md5 = '467b53791903f9a0c477cbb1b24ffd1f'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

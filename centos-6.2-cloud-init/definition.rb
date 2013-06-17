require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_src = 'http://vault.centos.org/6.2/isos/x86_64/CentOS-6.2-x86_64-minimal.iso'
definition.iso_file = 'CentOS-6.2-x86_64-minimal.iso'
definition.iso_md5 = '20dac370a6e08ded2701e4104855bc6e'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

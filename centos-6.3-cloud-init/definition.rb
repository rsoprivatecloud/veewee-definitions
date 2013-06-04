require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'CentOS-6.3-x86_64-minimal.iso',
definition.iso_src = 'http://www.mirrorservice.org/sites/mirror.centos.org/6.3/isos/x86_64/CentOS-6.3-x86_64-minimal.iso',
definition.iso_md5 = '087713752fa88c03a5e8471c661ad1a2',

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

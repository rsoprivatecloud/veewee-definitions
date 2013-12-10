require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'CentOS-6.1-x86_64-minimal.iso'
definition.iso_src = 'http://mirror.symnds.com/distributions/CentOS-vault/6.1/isos/x86_64/CentOS-6.1-x86_64-minimal.iso'
definition.iso_md5 = '03177dfefb4ebfeb03f457c29f00b0a1'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

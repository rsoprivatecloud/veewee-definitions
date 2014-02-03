require '../rhel/5/definition'

definition.declare($defaults)

definition.iso_src = 'http://mirror.symnds.com/distributions/CentOS-vault/5.9/isos/x86_64/CentOS-5.9-x86_64-bin-DVD-1of2.iso'
definition.iso_file = 'CentOS-5.9-x86_64-bin-DVD-1of2.iso'
definition.iso_md5 = 'c8caaa18400dfde2065d8ef58eb9e9bf'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

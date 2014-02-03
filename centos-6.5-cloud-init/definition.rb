require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'CentOS-6.5-x86_64-minimal.iso'
definition.iso_src = 'http://mirror.symnds.com/distributions/CentOS-vault/6.5/isos/x86_64/CentOS-6.5-x86_64-minimal.iso'
definition.iso_md5 = '0d9dc37b5dd4befa1c440d2174e88a87'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

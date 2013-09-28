require '../rhel/6/definition'

definition.declare($defaults)

definition.iso_file = 'CentOS-6.4-x86_64-minimal.iso'
definition.iso_src = 'http://www.mirrorservice.org/sites/mirror.centos.org/6.4/isos/x86_64/CentOS-6.4-x86_64-minimal.iso'
definition.iso_md5 = '4a5fa01c81cc300f4729136e28ebe600'

# definition specific post-install files
#definition.postinstall_files << 'custom.sh'

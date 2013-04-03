#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" upgrade
yes '' | apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

export IP="`ip a s eth0 | awk '/inet / {sub(/\/[0-9]+$/, "", $2); print $2}'`"

apt-get install -y ruby1.9.1 ruby1.9.1-dev build-essential wget ssl-cert curl
update-alternatives --set ruby /usr/bin/ruby1.9.1
update-alternatives --set gem /usr/bin/gem1.9.1

# gem install chef --no-ri --no-rdoc chef

# ### gem install chef with chef-solo
# mkdir -p /etc/chef

# cat > /etc/chef/solo.rb <<END
# file_cache_path "/tmp/chef-solo"
# cookbook_path "/tmp/chef-solo/cookbooks"
# END

# cat > chef.json <<END
# {
#   "chef_server": {
#     "server_url": "http://localhost:4000",
#     "webui_enabled": false
#   },
#   "run_list": [ "recipe[chef-server::rubygems-install]" ]
# }
# END

# # bootstrap chef-server
# chef-solo -c /etc/chef/solo.rb -j chef.json -r http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz
# ln -sf /usr/local/bin/chef-server /usr/sbin/chef-server
# ln -sf /usr/local/bin/chef-server-webui /usr/sbin/chef-server-webui
# ln -sf /usr/local/bin/chef-solr /usr/sbin/chef-solr
# ln -sf /usr/local/bin/chef-expander /usr/sbin/chef-expander
# rm -f /etc/chef/validation.pem
# service chef-solr restart
# service chef-expander restart
# service chef-server restart
# update-rc.d chef-solr enable
# update-rc.d chef-expander enable
# update-rc.d chef-server enable

echo "deb http://apt.opscode.com/ precise-0.10 main" | sudo tee /etc/apt/sources.list.d/opscode.list
gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
gpg -a --export  83EF826A | apt-key add - 

apt-get update
apt-get install opscode-keyring
apt-get install chef chef-server -y

# create a chef client
cat > /etc/chef/client.rb <<END
log_level        :info
log_location     STDOUT
chef_server_url  "http://$IP:4000"
validation_client_name "chef-validator"
END

rm -rf .chef
mkdir -p .chef
cp /etc/chef/validation.pem /etc/chef/webui.pem .chef
chown -R $USER: .chef

cat <<END | expect
spawn knife configure -i
expect "\[/$USER/.chef/knife.rb\] "
send "/home/$SUDO_USER/.chef/knife.rb\r"
expect "\[http://$HOSTNAME:4000\] "
send "\r"
expect "\[$SUDO_USER\] "
send "stack\r"
expect "\[chef-webui\] "
send "\r"
expect "\[/etc/chef/webui.pem\] "
send "/home/$SUDO_USER/.chef/webui.pem\r"
expect "\[chef-validator\] "
send "\r"
expect "\[/etc/chef/validation.pem\] "
send "/home/$SUDO_USER/.chef/validation.pem\r"
expect "\(or leave blank\): "
send "\r"
expect eof
END

# # pull cookbooks
# mkdir -p /opt/rpcs
# apt-get install -y git
# git clone --recursive https://github.com/rcbops/chef-cookbooks /opt/rpcs/chef-cookbooks
# git checkout v3.0.1

# # upload cookbooks and roles to chef
# knife cookbook upload -a -o /opt/rpcs/chef-cookbooks/cookbooks
# knife role from file /opt/rpcs/chef-cookbooks/roles/*.rb

# # chef environment
# cat > rpcs.json <<END
# {
#   "name": "rpcs",
#   "description": "",
#   "cookbook_versions": {
#   },
#   "json_class": "Chef::Environment",
#   "chef_type": "environment",
#   "chef_server": {
#     "server_url": "http://localhost:4000",
#     "webui_enabled": true,
#     "prereleases": true
#   },
#   "default_attributes": {
#     "horizon": {
#       "theme": "Rackspace"
#     },
#     "package_component": "folsom"
#   },
#   "override_attributes": {
#     "hardware" : {
#       "install_oem": true
#     },
#     "monitoring" : {
#       "metric_provider" : "collectd",
#       "procmon_provider" : "monit"
#     },
#     "mysql": {
#       "allow_remote_root": true,
#       "root_network_acl": "%"
#     },
#    "keystone": {
#       "tenants": [
#          "admin",
#          "service"
#       ],
#       "users":{
#          "admin": {
#             "password": "foobarbaz",
#             "roles":{
#                "admin": [
#                   "admin"
#                ]
#             }
#          }
#       },
#       "admin_user": "admin"
#    }, 
#     "osops": {
#       "apply_patches": true
#     },
#     "developer_mode": false,
#     "glance": {
#       "api": {
#       },
#       "images": [
#         "cirros",
#         "precise"
#       ],
#       "image_upload": false
#     },
#     "nova": {
#       "config": {
#         "ram_allocation_ratio": 1.0,
#         "cpu_allocation_ratio": 16,
#         "start_guests_on_host_boot": false,
#         "resume_guests_state_on_host_boot": false,
#         "use_single_default_gateway": false
#       },
#       "network": {
#         "fixed_range": "172.16.0.0/24",
#         "public_interface": "br0",
#         "multi_host": true,
#         "dmz_cidr": "10.128.0.0/24"
#       },
#       "networks": [
#         {
#           "num_networks": "1",
#           "bridge": "br0",
#           "label": "public",
#           "bridge_dev": "eth0",
#           "dns1": "8.8.8.8",
#           "dns2": "4.2.2.2",
#           "network_size": "256",
#           "ipv4_cidr": "172.16.0.0/24"
#         }
#       ]
#     },
#     "osops_networks": {
#       "management": "$IP/24",
#       "nova": "$IP/24",
#       "public": "$IP/24"
#     }
#   }
# }
# END

# knife environment from file rpcs.json

# # registers client and node
# chef-client

# EDITOR="sed -i 's/_default/rpcs/'" knife node edit `hostname`
# knife node run_list add `hostname` 'role[allinone]'

# # do the needful!
# chef-client

# # some os stuffs
# usermod -a -G sudo $SUDO_USER
# cp /etc/sudoers /etc/sudoers.orig
# sed -i -e 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

# chown -R $SUDO_USER: .

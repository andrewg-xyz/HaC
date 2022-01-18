#!/bin/bash

# I could use this command to ID device name, but for current template it is static. ip -o link show | awk '{print $2}' | grep 'ens'

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

cat << EOF > /etc/netplan/00-installer-config.yaml
network:
  ethernets:
    ens18:
      dhcp4: false
      addresses:
          - 192.168.1.$1/24
      gateway4: 192.168.1.1
      nameservers:
          addresses: [8.8.8.8]
  version: 2
EOF

netplan apply
#          addresses: [192.168.1.198, 192.168.1.199, 8.8.8.8]
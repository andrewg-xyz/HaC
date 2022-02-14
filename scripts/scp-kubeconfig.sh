#!/bin/zsh

if [[ "$#" -ne 2 ]]; then
  echo "Usage: copies remote config file to local
              ./scp-kubeconfig.sh last_three_of_ip dest_filename
              Ex. ./scp-kubeconfig 174 174-config"
  exit
fi

source_ip=192.168.1.$1
dest_file=$HOME/.kube/$2

scp user@$source_ip:/etc/rancher/k3s/k3s.yaml $dest_file
sed -i'' -e "s|127.0.0.1|$source_ip|g" $dest_file
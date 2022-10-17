# Cluster Up

1. `scp cluster/scripts/k3s.sh <all_nodes>`
2. `chmod +x k3s.sh`
3. on Primary node execute: `k3s.sh -m -t <token> -s https://<node_ip>:6443`
4. on additional nodes execute: `k3s.sh -m -t <token> -s https://<node_ip>:6443`


> note: /usr/local/bin/k3s-uninstall.sh
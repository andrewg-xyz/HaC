# VPN

Using [WireGuard](wireguard.com) to operate a VPN. Environment has a primary and a backup VPN. create a new client with the `create_client.sh` on each VM.

## Installation

1. Create a linked clone VM on each node
- name: vpnXX
- 1 CPU, 1GB RAM
2. Configure VM
3. `scp vpn/*.sh <node>`
4. on each node `sudo ./configure -p <port> -s <vpnXX_ip> -i <network_gw> -n <network_cidr>`
5. for each <peer> and <vpn> `sudo ./create_client.sh -i <peer_name> -a <rand_ip> -e <vpn ip or dns>`

## Troubleshooting and debugging

`wg` command includes several options for viewing the configuration/connections. `wg show` is the best first step.

Wireguard uses journald, view logs and events via
```shell
modprobe wireguard
echo module wireguard +p | sudo tee /sys/kernel/debug/dynamic_debug/control
journalctl -ekf
```

## Notes
- [ ] enabled [bbr](https://djangocas.dev/blog/huge-improve-network-performance-by-change-tcp-congestion-control-to-bbr/) for potential performance improvements

## refs
https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04
https://www.procustodibus.com/blog/2021/05/wireguard-ufw/#point-to-site
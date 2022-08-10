#!/usr/bin/env bash

usage() {
  echo "Usage: WireGuard Configuration Script for Ubuntu"
  echo "  -p [string_val] WireGuard Port, default 51820"
  echo "  -s [string_val] WireGuard Interface/server Address"
  echo "  -i [string_val] DNS Address, if using DNS Tunneling"
  echo "  -n [string_val] Internal Network CIDR Peer can connect to when VPN connection established (i.e. 10.1.4.1/24)"
  exit 1
}

print_config() {
  echo "Running with..."
  echo "    WIREGUARD_INTERFACE_ADDR=$WIREGUARD_INTERFACE_ADDR"
  echo "    WIREGUARD_PORT=$WIREGUARD_PORT"
  echo "    DNS_IP=$DNS_IP"
  echo "    NETWORK_CIDR=$NETWORK_CIDR"
}

WIREGUARD_PORT=51820
DNS_IP=

while getopts "uhdp:s:i:n:" o; do
  case "${o}" in
  p)
    export WIREGUARD_PORT=${OPTARG}
    ;;
  s)
    export WIREGUARD_INTERFACE_ADDR=${OPTARG}
    ;;
  i)
    export DNS_IP=${OPTARG}
    ;;
  n)
    export NETWORK_CIDR=${OPTARG}
    ;;
  d)
    export DEBUG=1
    ;;
  *)
    usage
    ;;
  esac
done
shift $((OPTIND - 1))

if [ -n "$DEBUG" ]; then
  print_config
fi

if [ -z "$WIREGUARD_INTERFACE_ADDR" ] || [ -z "$NETWORK_CIDR" ]; then
  echo "Error required values not set. exiting..."
  print_config
  exit 1;
fi

#----SCRIPT START----#
apt update
apt upgrade -y
apt install -y wireguard qrencode

# Allow SSH within network
ufw allow proto tcp from $NETWORK_CIDR to any port 22

# Enable Packet forwarding
sed -i 's|#net/ipv4/ip_forward=1|net/ipv4/ip_forward=1|' /etc/ufw/sysctl.conf
sed -i 's|#net/ipv6/conf/default/forwarding=1|net/ipv6/conf/default/forwarding=1|' /etc/ufw/sysctl.conf
sed -i 's|#net/ipv6/conf/all/forwarding=1|net/ipv6/conf/all/forwarding=1|' /etc/ufw/sysctl.conf

sysctl -p /etc/ufw/sysctl.conf

# Enable Masquerading
### Note the interface name `ip -brief address show`
### If using IPV6 modify this file /etc/ufw/before6.rules
cat <<EOT >> /etc/ufw/before.rules

*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -o ens18 -j MASQUERADE
COMMIT
EOT

# Allow UDP traffic on WireGuard port
ufw allow $WIREGUARD_PORT/udp
echo "y" | ufw enable

echo "Creating wireguard server private/public key and 'wg0.conf' file.."
wg genkey | tee "/etc/wireguard/privatekey" | wg pubkey > "/etc/wireguard/publickey"

SERVER_PUBLIC_KEY=$(cat /etc/wireguard/publickey)
SERVER_PRIVATE_KEY=$(cat /etc/wireguard/privatekey)

cat <<EOT > /etc/wireguard/wg0.conf
[Interface]
Address = $WIREGUARD_INTERFACE_ADDR/32
ListenPort = $WIREGUARD_PORT
PrivateKey = $SERVER_PRIVATE_KEY
SaveConfig = true
PostUp = ufw route allow in on wg0 out on ens18
PostUp = iptables -t nat -I POSTROUTING -o ens18 -j MASQUERADE
PostUp = ip6tables -t nat -I POSTROUTING -o ens18 -j MASQUERADE
PreDown = ufw route delete allow in on wg0 out on ens18
PreDown = iptables -t nat -D POSTROUTING -o ens18 -j MASQUERADE
PreDown = ip6tables -t nat -D POSTROUTING -o ens18 -j MASQUERADE
EOT

echo "Starting Wireguard.."
systemctl start wg-quick@wg0.service
systemctl enable wg-quick@wg0.service

# Update 'create_client.sh' helper script
sed -i -e "s|REPLACE_WIREGUARD_PORT|$WIREGUARD_PORT|" /root/create_client.sh
sed -i -e "s|REPLACE_NETWORK_CIDR|$NETWORK_CIDR|" /root/create_client.sh
if [ -z "$DNS_IP" ]; then
  sed -i -e "/REPLACE_DNS_LINE/d" /root/create_client.sh
else
  sed -i -e "s/REPLACE_DNS_LINE/LOCAL_DNS_IP=$DNS_IP/g" /root/create_client.sh
fi

echo ""
echo "To create your first client, run the following:"
echo "/root/create_client.sh"
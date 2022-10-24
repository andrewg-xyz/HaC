#!/usr/bin/env bash

usage() {
  echo "Usage: WireGuard Client Creation helper script"
  echo "  -i [string_val] Peer ID, must be unique, i.e. Peer1, laptop, etc..."
  echo "  -a [string_val] Peer IP Address this is the IP on the VPN"
  echo "  -e [string_val] WireGuard External Address, i.e. vpn.my.domain, 1.2.3.4"
  echo "\n"
  echo "Example: sudo ./create_client -i tablet -a 149.45.205.6 -e vpn01.my.domain"
  exit 1
}

print_config() {
  echo "Running with..."
  echo "    WIREGUARD_EXTERNAL_HOSTNAME=$WIREGUARD_EXTERNAL_HOSTNAME"
  echo "    WIREGUARD_EXTERNAL_PORT=$WIREGUARD_EXTERNAL_PORT"
  echo "    LOCAL_DNS_IP=$LOCAL_DNS_IP"
  echo "    PEER_ID=$PEER_ID"
  echo "    PEER_IP=$PEER_IP"
}

WIREGUARD_EXTERNAL_PORT=REPLACE_WIREGUARD_PORT
REPLACE_DNS_LINE
NETWORK_CIDR=REPLACE_NETWORK_CIDR

while getopts "uhdi:a:e:" o; do
  case "${o}" in
  i)
    export PEER_ID=${OPTARG}
    if [[ -d "/etc/wireguard/clients/$PEER_ID" ]]; then
        echo "ERROR: Client ID '$PEER_ID' already exists."
        exit 1
    fi
    ;;
  a)
    export PEER_IP=${OPTARG}
    ;;
  e)
    export WIREGUARD_EXTERNAL_HOSTNAME=${OPTARG}
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

if [ -z "$PEER_ID" ] || [ -z "$PEER_IP" ] || [ -z "$WIREGUARD_EXTERNAL_HOSTNAME" ] || [ -z "$NETWORK_CIDR" ]; then
  echo "Error required values not set. exiting..."
  print_config
  usage
  exit 1;
fi

#----SCRIPT START----#
mkdir -p /etc/wireguard/clients/$PEER_ID

echo "Creating peer public/private keys.."
wg genkey | tee "/etc/wireguard/clients/$PEER_ID/privatekey" | wg pubkey > "/etc/wireguard/clients/$PEER_ID/publickey"

SERVER_PUBLIC_KEY=$(cat /etc/wireguard/publickey)
PEER_PRIVATE_KEY=$(cat /etc/wireguard/clients/$PEER_ID/privatekey)
PEER_PUBLIC_KEY=$(cat /etc/wireguard/clients/$PEER_ID/publickey)

echo "Creating peer config.."
cat <<EOT > /etc/wireguard/clients/$PEER_ID/peer.conf
[Interface]
Address = $PEER_IP/32
PrivateKey = $PEER_PRIVATE_KEY
DNS = $LOCAL_DNS_IP

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $WIREGUARD_EXTERNAL_HOSTNAME:$WIREGUARD_EXTERNAL_PORT
AllowedIPs = $NETWORK_CIDR
EOT

echo "Stopping Wireguard to update config.."
systemctl stop wg-quick@wg0.service

echo "Creating backup of wg0.conf (/etc/wireguard/wg0.conf.bak).."
cp /etc/wireguard/wg0.conf /etc/wireguard/wg0.conf.bak

echo "Adding peer information to 'wg0.conf.bak'.."
cat <<EOT >> /etc/wireguard/wg0.conf

[Peer]
PublicKey = $PEER_PUBLIC_KEY
AllowedIPs = $PEER_IP/32
EOT

echo "Starting Wireguard back up.."
systemctl start wg-quick@wg0.service

echo "Done! Here is the peer's QRCode for mobile devices.."
echo ""
qrencode -t ansiutf8 < /etc/wireguard/clients/$PEER_ID/peer.conf

echo ""
echo "To get the client config, run the following:"
echo "cat /etc/wireguard/clients/$PEER_ID/peer.conf"
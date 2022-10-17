# DNS

Using [AdGuard](https://github.com/AdguardTeam/AdguardHome) Home for DNS and synchronzing changes with [AdGuardHome Sync](https://github.com/bakito/adguardhome-sync).

## Installation

1. Create a linked clone VM on each node
- name: dnsXX
- 1 CPU, 1GB RAM
2. Configure VM
```
sudo hostnamectl hostname dnsXX
sudo vi /etc/netplan/00-installer-config.yaml # set IP
sudo netplan apply
sudo apt-get update && sudo apt-get upgrade -y
sudo reboot
```
3. Adguard Installation
```
scp dns/*.sh && chmod +x adguard-install.sh
./adguard-install.sh
```
4. Configure Adguard
goto `<ip>:3000`
- Listen Interface: network device, static ip
- follow on screen instructions
8. certs
```
sudo apt-get install certbot
certbot certonly --manual --preferred-challenges dns --config-dir=./certs/config --work-dir=./certs/work --logs-dir=./certs/logs
```
9. setting > encryption settings > configure and add certs
10. goto `https://<url>`

## Adguard Sync
1. on dns01, update values in `adguard-sync.sh`
2. dns01, must kmnow about DNS records
3. `./adguard-sync.sh &`
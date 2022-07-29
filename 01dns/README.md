# DNS

AdGuardHome(agh) DNS

## Post install configuration
1. Navigate to dns_ip_01:3000 and dns_ip_02:3000 and configure via web client
2. [optional] configure agh for [encryption](#encryption)
3. Add records for each dns server to /etc/hosts
4. Update variables in /home/user/adguardsync.sh on dns01
5. execute `/home/user/adguardsync.sh &` on dns01
6. Update router to use static ip-ed agh DNS server

## encryption
Generate certificates (running offline and using agh to DNS rewrite with a valid domain)
```shell
sudo apt-get install certbot
certbot certonly --manual --preferred-challenges dns --config-dir=./certs/config --work-dir=./certs/work --logs-dir=./certs/logs
```

agh web ui > settings > encryption settings
1. configure as desired
2. add certs or filepath

## Refs

[AdGuard](https://github.com/AdguardTeam/AdguardHome)

[AdGuardHome Sync](https://github.com/bakito/adguardhome-sync)

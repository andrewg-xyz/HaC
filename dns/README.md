# DNS

## TODO
- [ ] Update to use cloud-init, then possible provision with scripts

## Infra

Terraform to provision DNS servers. Without cloud init templates: I had issues with remote-exec provisioner (I think due to changing the IP via script while terraform is connected). So after provisioning, configuration and install has to be done manually.

## Configuration

1. set static ip
2. Install [AdGuard](https://github.com/AdguardTeam/AdguardHome) via `curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v` and configure via web client
3. Install and Configure [AdGuardHome Sync](https://github.com/bakito/adguardhome-sync)
   1. [Install Golang](https://go.dev/doc/install)
   2. Install Sync `go install github.com/bakito/adguardhome-sync@latest`
   3. Copy `config/adguardsync.sh`, update variables, and run `./adguardsync.sh &`
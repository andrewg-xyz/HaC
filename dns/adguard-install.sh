#!/bin/bash

curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
curl -sSLO https://go.dev/dl/go1.17.7.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.7.linux-amd64.tar.gz
export GOPATH=/home/user/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
go install github.com/bakito/adguardhome-sync@latest
echo 'export GOPATH=/home/user/go' >> /home/user/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/user/.bashrc
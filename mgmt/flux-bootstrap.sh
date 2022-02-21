#!/bin/zsh

[ -z $GITHUB_TOKEN ] && echo "no github token found"; exit

flux bootstrap github --owner=andrewsgreene --repository=hac --path=mgmt/cluster --personal
#!/bin/bash

usage() {
  echo "Usage: Utility script for managing cluster"
  echo "  -h              help"
  echo "  -c [file]       copy file to all nodes"
  echo "  -k              copy kubeconfig to all nodes"
  exit 1
}


source ../.env-z8s

function scp_to_nodes() {
  local file=$1
  for node in ${ipList[@]}; do
    scp $file $node:
  done
}

function copy_kubeconfig() {
  FILE=/etc/rancher/k3s/k3s.yaml
  KUBECONFIG=/home/user/cluster-config
#  ssh ${ipList[0]} "sudo -S cp $FILE $KUBECONFIG"
  scp ${ipList[0]}:$KUBECONFIG cluster-config
  sed -i'.bak' "s|127.0.0.1|${ipList[0]}|g" cluster-config
}

function new_session() {
  tmux new-window \; send-keys "ssh ${ipList[0]}" C-m
  tmux split-window -h \; send-keys "ssh ${ipList[1]}" C-m
  tmux select-pane -t 1
  tmux split-window -v \; send-keys "ssh ${ipList[2]}" C-m
  tmux split-window -v \; send-keys "ssh ${ipList[3]}" C-m
  tmux split-window -v \; send-keys "ssh ${ipList[4]}" C-m
  tmux select-pane -t 5
  tmux split-window -v \; send-keys "ssh ${ipList[5]}" C-m
  tmux split-window -v \; send-keys "ssh ${ipList[6]}" C-m
  tmux split-window -v \; send-keys "ssh ${ipList[7]}" C-m
}

while getopts "hskc:" o; do
  case "${o}" in
  c)
    scp_to_nodes $OPTARG
    ;;
  k)
    copy_kubeconfig
    ;;
  s)
    new_session
    ;;
  *)
    usage
    ;;
  esac
done
shift $((OPTIND - 1))
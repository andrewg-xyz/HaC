#!/bin/bash

node=$1
id=$2

cd /tmp
wget https://cloud-images.ubuntu.com/kinetic/current/kinetic-server-cloudimg-amd64.img
apt-get install libguestfs-tools -y
virt-customize -a /tmp/focal-server-cloudimg-amd64.img --install qemu-guest-agent
virt-customize -a /tmp/focal-server-cloudimg-amd64.img --run-command "echo -n > /etc/machine-id"
touch /etc/pve/nodes/$node/qemu-server/$id.conf
qm importdisk $id /tmp/kinetic-server-cloudimg-amd64.img local-lvm
qm set $id --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$id-disk-0
qm set $id --ide2 local-lvm:cloudinit
qm set $id --boot c --bootdisk scsi0
qm set $id --serial0 socket --vga serial0
qm set $id --agent enabled=1
qm set $id --name ubuntu-ci-template
qm template $id
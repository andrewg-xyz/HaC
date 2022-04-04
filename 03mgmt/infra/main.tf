terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "mgmt0" {
  name = "mgmt0"
  target_node = "bane"
  ipconfig0 = "ip=192.168.1.210/24,gw=192.168.1.1"
  agent = var.qemu_agent
  clone = var.clone_template
  memory = var.memory
  cores = var.cores
  os_type   = var.os_type
  nameserver = var.dns_servers
  sshkeys = var.ssh_key_public
  ciuser = var.ssh_user
  cipassword = var.user_secret

  disk {
    type = var.disk_type
    storage = var.storage_pool
    size = var.disk_size
  }
}

resource "null_resource" "mgmt0-config" {
  depends_on = [proxmox_vm_qemu.mgmt0]
  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = "${file(var.ssh_key)}"
    host = proxmox_vm_qemu.mgmt0.ssh_host
  }

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k3s.sh",
      "/tmp/k3s.sh -m -n mgmt0 -t ${random_string.random.result} -s https://192.168.1.210:6443 -d",
      "sudo chown user:user /etc/rancher/k3s/k3s.yaml"
    ]
  }
}

resource "proxmox_vm_qemu" "mgmt1" {
  name = "mgmt1"
  target_node = "revan"
  ipconfig0 = "ip=192.168.1.211/24,gw=192.168.1.1"
  agent = var.qemu_agent
  clone = var.clone_template
  memory = var.memory
  cores = var.cores
  os_type   = var.os_type
  nameserver = var.dns_servers
  sshkeys = var.ssh_key_public
  ciuser = var.ssh_user
  cipassword = var.user_secret

  disk {
    type = var.disk_type
    storage = var.storage_pool
    size = var.disk_size
  }
}

resource "null_resource" "mgmt1-config" {
  depends_on = [proxmox_vm_qemu.mgmt1, null_resource.mgmt0-config]
  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = "${file(var.ssh_key)}"
    host = proxmox_vm_qemu.mgmt1.ssh_host
  }

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k3s.sh",
      "/tmp/k3s.sh -n mgmt1 -t ${random_string.random.result} -s https://192.168.1.210:6443 -d",
    ]
  }
}

resource "proxmox_vm_qemu" "mgmt2" {
  name = "mgmt2"
  target_node = "revan"
  ipconfig0 = "ip=192.168.1.212/24,gw=192.168.1.1"
  agent = var.qemu_agent
  clone = var.clone_template
  memory = var.memory
  cores = var.cores
  os_type   = var.os_type
  nameserver = var.dns_servers
  sshkeys = var.ssh_key_public
  ciuser = var.ssh_user
  cipassword = var.user_secret

  disk {
    type = var.disk_type
    storage = var.storage_pool
    size = var.disk_size
  }
}

resource "null_resource" "mgmt2-config" {
  depends_on = [proxmox_vm_qemu.mgmt2, null_resource.mgmt1-config]
  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = "${file(var.ssh_key)}"
    host = proxmox_vm_qemu.mgmt2.ssh_host
  }

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k3s.sh",
      "/tmp/k3s.sh -n mgmt2 -t ${random_string.random.result} -s https://192.168.1.210:6443 -d",
    ]
  }
}

resource "random_string" "random" {
  length = 16
  special = false
}
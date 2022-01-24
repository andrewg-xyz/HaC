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

resource "proxmox_vm_qemu" "mgmt-master0" {
  name = "mgmt-master0"
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

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

resource "proxmox_vm_qemu" "mgmt-master1" {
  name = "mgmt-master1"
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

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

resource "proxmox_vm_qemu" "mgmt-master2" {
  name = "mgmt-master2"
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

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

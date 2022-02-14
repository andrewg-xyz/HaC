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

resource "proxmox_vm_qemu" "node01" {
  name = "node01"
  target_node = "bane|revan"
  ipconfig0 = "ip=192.168.1.XXX/24,gw=192.168.1.1"
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
    source = "local/path/to/script.sh"
    destination = "/tmp/script.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "remote-exec" {
    inline = [
      "command 1",
      "command 2",
    ]
    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}
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

resource "proxmox_vm_qemu" "dns01" {
  name = "dns01"
  target_node = "bane"
  agent = var.qemu_agent
  clone = var.clone_template
  memory = var.memory
  cores = var.cores

  provisioner "file" {
    source = "scripts/configure.sh"
    destination = "/tmp/configure.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

resource "proxmox_vm_qemu" "dns02" {
  name = "dns02"
  target_node = "revan"
  agent = var.qemu_agent
  clone = var.clone_template
  memory = var.memory
  cores = var.cores

  provisioner "file" {
    source = "scripts/configure.sh"
    destination = "/tmp/configure.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

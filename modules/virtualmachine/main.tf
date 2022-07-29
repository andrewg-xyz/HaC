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

resource "proxmox_vm_qemu" "virtualmachine" {
  name        = var.name
  target_node = var.target_node
  ipconfig0   = "ip=${var.vm_ip}/24,gw=${var.vm_gw}"
  agent       = var.qemu_agent
  clone       = var.clone_template
  full_clone  = false
  memory      = var.memory
  cores       = var.cores
  os_type     = var.os_type
  sshkeys     = var.ssh_key_public
  ciuser      = var.ssh_user
  cipassword  = var.user_secret

  disk {
    type    = var.disk_type
    storage = var.storage_pool
    size    = var.disk_size
  }
}
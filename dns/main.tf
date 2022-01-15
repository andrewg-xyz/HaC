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
  agent = 1
  clone = "ubuntu-template"
  memory = "4096"
  cores = 4
}

resource "proxmox_vm_qemu" "dns02" {
  name = "dns02"
  target_node = "revan"
  agent = 1
  clone = "ubuntu-template"
  memory = "4096"
  cores = 4
}

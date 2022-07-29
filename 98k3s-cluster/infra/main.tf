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
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "kv0" {
  name = "k3s0"
  target_node = "bane"
  ipconfig0 = "ip=${var.ci_ip_01}/24,gw=${var.ci_gw}"
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

resource "null_resource" "kv0-config" {
  depends_on = [proxmox_vm_qemu.kv0]
  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = "${file(var.ssh_key)}"
    host = proxmox_vm_qemu.kv0.ssh_host
  }

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k3s.sh",
      "/tmp/k3s.sh -m -n kv0 -t ${random_string.random.result} -s https://${var.ci_ip_01}:6443 -d",
      "sudo chown user:user /etc/rancher/k3s/k3s.yaml"
    ]
  }
}

resource "proxmox_vm_qemu" "kv1" {
  name = "k3s1"
  target_node = "revan"
  ipconfig0 = "ip=${var.ci_ip_02}/24,gw=${var.ci_gw}"
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

resource "null_resource" "kv1-config" {
  depends_on = [proxmox_vm_qemu.kv1, null_resource.kv0-config]
  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = "${file(var.ssh_key)}"
    host = proxmox_vm_qemu.kv1.ssh_host
  }

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k3s.sh",
      "/tmp/k3s.sh -n kv1 -t ${random_string.random.result} -s https://${var.ci_ip_01}:6443 -d",
    ]
  }
}

resource "proxmox_vm_qemu" "kv2" {
  name = "k3s2"
  target_node = "bane"
  ipconfig0 = "ip=${var.ci_ip_03}/24,gw=${var.ci_gw}"
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

resource "null_resource" "kv2-config" {
  depends_on = [proxmox_vm_qemu.kv2, null_resource.kv1-config]
  connection {
    type     = "ssh"
    user     = var.ssh_user
    private_key = "${file(var.ssh_key)}"
    host = proxmox_vm_qemu.kv2.ssh_host
  }

  provisioner "file" {
    source = "scripts/k3s.sh"
    destination = "/tmp/k3s.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/k3s.sh",
      "/tmp/k3s.sh -n kv2 -t ${random_string.random.result} -s https://${var.ci_ip_01}:6443 -d",
    ]
  }
}

resource "random_string" "random" {
  length = 16
  special = false
}
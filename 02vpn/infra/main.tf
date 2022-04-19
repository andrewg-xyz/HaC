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

resource "proxmox_vm_qemu" "wireguard01" {
  name = "wireguard01"
  target_node = "bane"
  ipconfig0 = "ip=${var.ci_ip_wg0}/24,gw=${var.ci_gw}"
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
    source = "scripts/configure.sh"
    destination = "/tmp/configure.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "file" {
    source = "scripts/create_client.sh"
    destination = "/tmp/create_client.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/create_client.sh /root/create_client.sh",
      "sudo chmod +x /root/create_client.sh",
      "sudo chmod +x /tmp/configure.sh",
      "sudo /tmp/configure.sh -p ${var.wg0_port} -s ${var.ci_ip_wg0} -i ${var.ci_gw} -n ${var.wg_network_cidr}",
    ]
    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

resource "proxmox_vm_qemu" "wireguard02" {
  name = "wireguard02"
  target_node = "revan"
  ipconfig0 = "ip=${var.ci_ip_wg1}/24,gw=${var.ci_gw}"
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
    source = "scripts/configure.sh"
    destination = "/tmp/configure.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "file" {
    source = "scripts/create_client.sh"
    destination = "/tmp/create_client.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/create_client.sh /root/create_client.sh",
      "sudo chmod +x /root/create_client.sh",
      "sudo chmod +x /tmp/configure.sh",
      "sudo /tmp/configure.sh -p ${var.wg1_port} -s ${var.ci_ip_wg1} -i ${var.ci_gw} -n ${var.wg_network_cidr}",
    ]
    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}

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
  ipconfig0 = "ip=192.168.1.198/24,gw=192.168.1.1"
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
    source = "scripts/adguardsync.sh"
    destination = "/tmp/adguardsync.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "remote-exec" {
    inline = [
      "curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v",
      "curl -sSLO https://go.dev/dl/go1.17.7.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf go1.17.7.linux-amd64.tar.gz",
      "export GOPATH=/home/user/go",
      "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin",
      "go install github.com/bakito/adguardhome-sync@latest",
      "cp /tmp/adguardsync.sh /home/user/adguardsync.sh && chmod +x /home/user/adguardsync.sh",
      "echo 'export GOPATH=/home/user/go' >> /home/user/.bashrc",
      "echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/user/.bashrc",
    ]
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
  ipconfig0 = "ip=192.168.1.199/24,gw=192.168.1.1"
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
    source = "scripts/adguardsync.sh"
    destination = "/tmp/adguardsync.sh"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }

  provisioner "remote-exec" {
    inline = [
      "curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v",
      "curl -sSLO https://go.dev/dl/go1.17.7.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf go1.17.7.linux-amd64.tar.gz",
      "export GOPATH=/home/user/go",
      "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin",
      "go install github.com/bakito/adguardhome-sync@latest",
      "cp /tmp/adguardsync.sh /home/user/adguardsync.sh && chmod +x /home/user/adguardsync.sh",
      "echo 'export GOPATH=/home/user/go' >> /home/user/.bashrc",
      "echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /home/user/.bashrc",
    ]
    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = "${file(var.ssh_key)}"
      host = self.ssh_host
    }
  }
}
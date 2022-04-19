variable "memory" {
  description = "Memory for each node"
  type        = string
  default     = "1024"
}

variable "cores" {
  description = "Cores for each node"
  type        = number
  default     = 1
}

variable "clone_template" {
  description = "Source template to clone"
  type        = string
  default     = "ci-ubuntu-template-v1"
}

variable "qemu_agent" {
  description = "Enable qemu guest agent"
  type        = number
  default     = 1
}

variable "ssh_user" {
  description = "Username for ssh"
  type = string
  default = "user"
}

variable "ssh_key" {
  description = "SSH private key"
  type = string
  default = "~/.ssh/id_ed25519"
}

variable "ssh_key_public" {
  description = "SSH public key"
  type = string
  default = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5gDqGux/p7JR/I/mBE/LYoJc8RBdSikmyVj7OTqBMW andrewsgreene89@gmail.com
EOF
}

variable "os_type" {
  description = "OS Type, cloud-init"
  type = string
  default = "cloud-init"
}

variable "dns_servers" {
  description = "DNS server address, space separated i.e. 1.2.3.4 1.2.3.5"
  type = string
}

variable "user_secret" {
  description = "User secret"
  type = string
  sensitive = true
}

variable "disk_type" {
  type = string
  default = "scsi"
}

variable "storage_pool" {
  type = string
  default = "local-lvm"
}

variable "disk_size" {
  type = string
  default = "25G"
}

variable "ci_ip_wg0" {
  description = "IP of wg0"
  type = string
}

variable "ci_ip_wg1" {
  description = "IP of wg1"
  type = string
}

variable "ci_gw" {
  description = "Network Gateway"
  type = string
}

variable "wg0_port" {
  description = "WireGuard(0) Port"
  type = string
}

variable "wg_network_cidr" {
  description = "CIDR of network (will be accessible on VPN) i.e. 192.168.1.1/24"
  type = string
}

variable "wg1_port" {
  description = "WireGuard(0) Port"
  type = string
}


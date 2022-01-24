variable "memory" {
  description = "Memory for each node"
  type        = string
  default     = "8192"
}

variable "cores" {
  description = "Cores for each node"
  type        = number
  default     = 2
}

variable "clone_template" {
  description = "Source template to clone"
  type        = string
  default     = "ci-ubuntu-template"
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
  description = "DNS server address"
  type = string
  default = "192.168.1.198 192.168.1.199"
}

variable "user_secret" {
  description = "User secret"
  type = string
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
  default = "75G"
}
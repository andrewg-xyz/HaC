variable "name" {
  description = "The name of the virtualmachine"
  type        = string
  default     = "virtualmachine"
}

variable "target_node" {
  description = "The name of the target node"
  type        = string
  default     = "bane"
}

variable "vm_ip" {
  description = "IP of resource, x.x.x.x"
  type        = string
}

variable "vm_gw" {
  description = "Network Gateway"
  type        = string
}

variable "qemu_agent" {
  description = "Enable qemu guest agent"
  type        = number
  default     = 1
}

variable "clone_template" {
  description = "Source template to clone"
  type        = string
  default     = "ubuntu-ci-template"
}

variable "memory" {
  description = "Memory for each node"
  type        = string
  default     = "4096"
}

variable "cores" {
  description = "Cores for each node"
  type        = number
  default     = 2
}

variable "os_type" {
  description = "OS Type, cloud-init"
  type        = string
  default     = "cloud-init"
}

variable "ssh_key_public" {
  description = "SSH public key"
  type        = string
  default     = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5gDqGux/p7JR/I/mBE/LYoJc8RBdSikmyVj7OTqBMW andrewsgreene89@gmail.com
EOF
}

variable "ssh_user" {
  description = "Username for ssh"
  type        = string
  default     = "user"
}

variable "user_secret" {
  description = "User secret"
  type        = string
}

variable "disk_type" {
  type    = string
  default = "scsi"
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "disk_size" {
  type    = string
  default = "75G"
}


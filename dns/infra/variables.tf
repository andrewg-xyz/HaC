variable "memory" {
  description = "Memory for each node"
  type        = string
  default     = "4096"
}

variable "cores" {
  description = "Cores for each node"
  type        = number
  default     = 4
}

variable "clone_template" {
  description = "Source template to clone"
  type        = string
  default     = "ubuntu-template"
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
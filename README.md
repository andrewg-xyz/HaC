# HaC
Homelab provisioning. Proxmox infrastructure provisioning. Using [Telmate Terraform Provider](https://github.com/Telmate/terraform-provider-proxmox). Various implementations for resource configuration.

## Repository Structure
Each folder is for a unique resource group and are executed independently. Within each resource group is a .env file containing environment specific values or secrets.

## Infrastructure
### Quick Start
```shell
cd <resource_group_dir>/infra
source .env
terraform init
terraform plan
terraform apply
```

### Debugging Terraform
Add the following to the `provider "proxmox"` block
```terraform
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
```
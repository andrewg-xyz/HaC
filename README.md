# HaC

Homelab as Code (mostly, kinda)

- Using [Telmate Terraform Provider](https://github.com/Telmate/terraform-provider-proxmox) for infrastructure on [ProxmoxVE](https://www.proxmox.com/en/proxmox-ve).

**July 2022 NOTE** - The terraform provider is not working :(. However, I'm unsure if it is related to teh provider or an issue with my underlying templates. Once resolved, my next improvement will be to use a local module for the creation of VMs as currently I'm copy/pasting a lot of terraform.

## Repository Structure
Root Directories: NN<name> (i.e. 01dns) indicating order of desired deployment of unique resource groups. 99*** folders are templates or samples
Within each resource group, the folder follows this general convention:
- infra folder with terraform and a .env for special values
- cluster folder with kubernetes things

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
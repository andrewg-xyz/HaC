## TLDR

1. `source .env`
2. `tf init`
3. `tf plan`
4. `tf apply`


### .env
```
# https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md#argument-reference
export PM_API_URL=

#token must be created without privilege separation checked
export PM_API_TOKEN_ID=
export PM_API_TOKEN_SECRET=

## Terraform Variables
export TF_VAR_ci_gw=
export TF_VAR_ci_ip_wg0=
export TF_VAR_ci_ip_wg1=
export TF_VAR_user_secret=
export TF_VAR_wg0_port=
export TF_VAR_wg1_port=
export TF_VAR_wg_network_cidr=
export TF_VAR_dns_servers=
```
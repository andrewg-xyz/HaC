# Mgmt Infra

Terraform to deploy a 3 node management cluster.

Infra deploys a k3s cluster :)

## Improvements
- [ ] terraform output for kube config


### terraform-provider-flux
[flux terraform](https://github.com/fluxcd/terraform-provider-flux) 
Looked promising. sandboxed without much luck. unsolved problem: install flux using flux patch files (i.e. gotk*.yaml) without deleting/modifying the git repository.
# Mgmt Infra

Terraform to deploy a 3 node management cluster.

cloud-init makes things much easier. Suspect terraform `remote-exec` provisioner would operate as expected now :)

Currently, k3s install has to be done manually on the provisioned resources.
# DNS Infra

Terraform to provision DNS servers.

I had issues with remote-exec provisioner (I think due to changing the IP via script while terraform is connected). So after provisioning, configuration and install has to be done manually.

Specifically
- set static ip
- Install Adguard (https://github.com/AdguardTeam/AdguardHome) and configure
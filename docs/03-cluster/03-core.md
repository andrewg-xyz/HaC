# Core

Documentation on core/common things.

## fluxv2 (gitops)

[ref](https://fluxcd.io/flux/get-started/)

```
source cluster/h8s/.env # contains GITHUB_TOKEN, GITHUB_USER
flux bootstrap github --owner=${GITHUB_USER} --repository=hac --branch=main --path
=cluster/h8s --personal
```


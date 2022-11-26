# Core

Documentation on core/common things.

## fluxv2 (gitops)

[ref](https://fluxcd.io/flux/get-started/)

```
source cluster/h8s/flux/.env # contains GITHUB_TOKEN, GITHUB_USER
flux bootstrap github --owner=andrewsgreene --repository=hac --path=cluster/h8s/flux --personal=true
```


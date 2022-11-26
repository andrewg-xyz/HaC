# Core

Documentation on core/common things.

## fluxv2 (gitops)

### Bootstrapping
[ref](https://fluxcd.io/flux/get-started/)
```
source cluster/h8s/.env # contains GITHUB_TOKEN, GITHUB_USER
flux bootstrap github --owner=${GITHUB_USER} --repository=hac --branch=main --path
=cluster/h8s --personalhttps://github.dev/fluxcd/flux2-kustomize-helm-example
```

### Directory Structure
[ref](https://github.dev/fluxcd/flux2-kustomize-helm-example)

```
cluster
-- apps     >>> Kustomizations for specific applications, i.e. helmrelease, namespace, etc...
-- h8s      >>> "Top" Kustomization objects for FluxV2. Defined sources, applications and flux-system
-- sources  >>> Helm Repository definitions
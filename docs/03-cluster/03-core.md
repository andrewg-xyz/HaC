# Core

Documentation on core/common things.

## fluxv2 (gitops)

[ref](https://fluxcd.io/flux/get-started/)

```
kubectl create ns flux-system
# Should be able to, but it fails >>>flux bootstrap github --owner=andrewsgreene --repository=hac --path=cluster/h8s/flux --personal=true
kubectl apply -k cluster/h8s/flux/flux-system
```


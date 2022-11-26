# Apps

All the (other) things

## Minecraft

from [../../cluster/h8s/minecraft](../../cluster/h8s/minecraft)
`helm repo add itzg https://itzg.github.io/minecraft-server-charts/`
`helm upgrade -i minecraft itzg/minecraft -f values.yaml`

- [ ] Expose with real service, instead of nodeport
- [ ] Chart has other unused features, i.e. backup, rcon, etc...
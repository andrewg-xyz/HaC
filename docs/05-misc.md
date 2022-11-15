# Miscellaneous

## Linux Mount
[ref](https://devconnected.com/how-to-mount-and-unmount-drives-on-linux/), [ref2](https://www.cyberciti.biz/faq/linux-disk-format/)

```
lsblk
mkfs.ext4 /dev/sdb
mkdir /data
mount /dev/sdb /data
df -h
vi /etc/fstab
#ADD>>> /dev/sdb /data ext4 defaults 0 1
```
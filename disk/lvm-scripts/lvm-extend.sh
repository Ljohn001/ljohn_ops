#!/bin/bash
#
set -e
#
fdisk  -l | grep dev
df -h
blkid
read -p "Enter drive Name: (ex: /dev/sdc)"  drive
drive=${drive:-'/dev/sdc'}
#vgdisplay
read -p "Enter volume group Name: (ex: centos)"  vgname
vgname=${vgname:-'centos'}
#lvdisplay
read -p "Enter logical volume path: (ex: /dev/centos/root)"  lvp
lvp=${lvp:-'/dev/centos/root'}
pvcreate $drive
vgextend $vgname $drive
lvextend -l +100%FREE $lvp
xfs_growfs $lvp
# display
pvs
vgs
lvs
df -lh
echo "drive addition complete"
exit 0


#!/bin/bash
#
set -e
#
fdisk  -l | grep dev
df -h
blkid
read -p "Enter drive Name: (ex: /dev/sdc)"  drive
drive=${drive:-'/dev/sdc'}
read -p "Enter drive mount path: (ex:/data)" mpath
mpath=${mpath:-'/data'}
vgname=${1:-'vgdata'}
lvp=${2:-'/dev/vgdata/lvdata'}

pvcreate $drive
vgcreate $vgname $drive
lvcreate -l +100%FREE -n lvdata $vgname
mke2fs.xfs $lvp
mkdir -p $mpath
echo "$lvp $mpath                      xfs     defaults        0 0" >> /etc/fstab
mount -a 
# display
pvs
vgs
lvs
df -lh
echo "drive addition complete"
exit 0


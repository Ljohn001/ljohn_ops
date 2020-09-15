#!/bin/bash
sudo df -h
sudo blkid
read -p "Enter drive Name: (ex: /dev/sdb)"  drive
sudo vgdisplay
read -p "Enter volume group Name: (ex: ubuntu-vg)"  vgname
sudo lvdisplay
read -p "Enter logical volume path: (ex: /dev/ubuntu-vg/root)"  lvp
sudo pvcreate $drive
sudo vgextend $vgname $drive
sudo lvextend -l +100%FREE $lvp
sudo resize2fs $lvp
echo "drive addition complete"
exit 0

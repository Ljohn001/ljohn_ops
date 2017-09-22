#!/bin/bash

# Author: Vtrois <seaton@vtrois.com>
# Author URL: https://www.vtrois.com
# Description: Auto fdisk for SpacePack Tools
# Project URI: https://github.com/SpacePack/Auto-fdisk
# Version: 1.2
# Date: 2017-02-17

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
clear
printf "
===========================================================================
                                Auto fdisk
      SpacePack tools for CentOS, CoreOS, Debian, openSUSE and Ubuntu
 For more information please visit https://github.com/SpacePack/Auto-fdisk
===========================================================================
"
echo -e "\n\033[36mStep 1: Initializing script and check root privilege\033[0m"
if [ "$(id -u)" = "0" ];then  
	echo -e "\033[33mIs running, please wait!\033[0m"
  	yum -y install e4fsprogs > /dev/null 2>&1
	echo -e "\033[32mSuccess, the script is ready to be installed!\033[0m"
else
	echo -e "\033[31mError, this script must be run as root!\n\033[0m"
	exit 1
fi
echo -e "\n\033[36mStep 2: Show all active disks:\033[0m"
fdisk -l 2>/dev/null | grep -o "Disk /dev/vd[b-z]"
echo -e -n "\n\033[36mStep 3: Please choose the disk(e.g., /dev/vdb and q to quit):\033[0m"
read Disk
if [ $Disk == q ];then
	exit
fi
until fdisk -l 2>/dev/null | grep -o "Disk /dev/vd[b-z]" | grep "Disk $Disk" &>/dev/null;do
echo -e -n "\033[31mOops, something went wrong, please try again (e.g., /dev/vdb or q to quit):\033[0m"
	read Disk
	if [ $Disk == q ];then
		exit
	fi
done
while mount | grep "$Disk" > /dev/null 2>&1;do
	echo -e "\033[31m\nYour disk has been mounted:\033[0m"
	mount | grep "$Disk"
	echo -e -n "\033[31m\nForce uninstalling? [y/n]:\033[0m"
	read Umount
	until [ $Umount == y -o $Umount == n ];do
		echo -e -n "\033[31mOops, something went wrong, please try again [y/n]:\033[0m"
		read Umount
	done
	if [ $Umount == n ];then
		exit
	else
		echo -e "\033[33mIs running, please wait!\033[0m"
		for i in `mount | grep "$Disk" | awk '{print $3}'`;do
			fuser -km $i >/dev/null
			umount $i >/dev/null
			sleep 2
		done
		echo -e "\033[32mSuccess, the disk is unloaded!\033[0m"
	fi
	echo -e -n "\n\033[36mReady to begin to format the disk? [y/n]:\033[0m"
	read Choice
	until [ $Choice == y -o $Choice == n ];do
		echo -e -n "\033[31mOops, something went wrong, please try again [y/n]:\033[0m"
		read Choice
	done
	if [ $Choice == n ];then
		exit
	else
		echo -e "\033[33mIs running, please wait!\033[0m"
		dd if=/dev/zero of=$Disk bs=512 count=1 &>/dev/null
		sleep 2
	sync
	fi
	echo -e "\033[32mSuccess, the disk has been formatted!\033[0m"
done
echo -e "\n\033[36mStep 4: The disk is partitioning and formatting\033[0m"
echo -e "\033[33mIs running, please wait!\033[0m"
fdisk_mkfs() {
fdisk -S 56 $1 << EOF
n
p
1


wq
EOF

sleep 2
mkfs.ext4 ${1}1
}
fdisk_mkfs $Disk > /dev/null 2>&1
echo -e "\033[32mSuccess, the disk has been partitioned and formatted!\033[0m"
echo -e "\n\033[36mStep 5: Make a directory and mount it\033[0m"
echo -e -n "\033[33mPlease enter a location to mount (e.g., /data):\033[0m"
read Mount
mkdir $Mount > /dev/null 2>&1
mount ${Disk}1 $Mount
echo -e "\033[32mSuccess, the mount is completed!\033[0m"
echo -e "\n\033[36mStep 6: Write configuration to /etc/fstab and mount device\033[0m"
echo ${Disk}1 $Mount 'ext4 defaults 0 0' >> /etc/fstab
echo -e "\033[32mSuccess, the /etc/fstab is Write!\033[0m"
echo -e "\n\033[36mStep 7: Show information about the file system on which each FILE resides\033[0m"
df -h
sleep 2
echo -e "\n\033[36mStep 8: Show the write configuration to /etc/fstab\033[0m"
cat /etc/fstab

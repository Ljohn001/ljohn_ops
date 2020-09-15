#!/bin/bash
# by ljohnmail@foxmail.com
# time 2020.4.29

# This script will increse the size of the LVM disk partition so that
# you can take advantage of additional space after increasing the virtual
# disk size either through virtualbox, openstack, or some other virtualization
# tool

# By default, this script is designed to work with a single LVM partition
# as is standard for an ubuntu 18.04 install (eg: /dev/sda1)

if [ -z "$1" ] ; then 
  echo "You must specify the partition being extended, eg: /dev/sda or /dev/vda";
  echo "Example Usage: ./extend-lvm.sh /dev/sda";
  echo "Run 'fdisk -l' to see the existing partitions. If there are more than one, this will also give you a clue as to which one has grown";
  exit 1
fi


# Part 1 - resize the disk partition
# ----------------------------------
# This script pipes commands into the interactive fdisk command so you
# do not have to interact with it

# The sed command strips off all the leading spaces and the comments so 
# that we can document what we're doing in-line with the actual commands

# Note that a blank line (commented as "default") will send a empty
# line terminated with a newline to take the fdisk default

# Script adapted from:
# https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script

# sed will select numeric and lowercase characters... adjust this if needed
# depending
sed -e 's/\s*\([0-9a-z]*\).*/\1/' << EOF | fdisk $1
  d # delete the parition table (will delete the only existing one)
  n # create a new partition
  e # create an extended partition
  1 # select the first parition
    # default, start from beginning of disk (or earlier partition)
    # default, extend partition to end of disk
  t # change the type of the partition
  8e # Set the partition type to LVM (hex code 8e)
  w # write the changes
  q # quit
EOF


# Part 2 - resize LVM logical volume
# ----------------------------------

# Get the physical volume device
pvdevice=$(pvs | grep $1 | awk ' { print $1; } ' | xargs);

# Resize the physical volume
pvresize $pvdevice

# Get the logical volume path
lvpath=$(lvdisplay | grep "LV Path" | awk ' { print $3; } ' | xargs);

# Extend the logical volume
lvextend -l +100%FREE $lvpath

# resize the file system on the logical volume
resize2fs $lvpath

echo "Finished!"


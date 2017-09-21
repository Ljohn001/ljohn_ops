#!/bin/bash
# Author:  yeho <lj2007331 AT gmail.com>
# BLOG:  https://blog.linuxeye.com
#
# Notes: OneinStack for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+
#
# Project home page:
#       https://oneinstack.com
#       https://github.com/lj2007331/oneinstack

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export LANG=en_US.UTF-8
clear
printf "
#######################################################################
#       OneinStack for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+      #
#                             Auto fdisk                              #
#       For more information please visit http://oneinstack.com       #
#######################################################################
"

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"

get_char() {
  SAVEDSTTY=`stty -g`
  stty -echo
  stty cbreak
  dd if=/dev/tty bs=1 count=1 2> /dev/null
  stty -raw
  stty echo
  stty $SAVEDSTTY
}

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; } 

MOUNT_DIR=/data
FSTAB_FILE=/etc/fstab

count=0
TMP1=/tmp/.tmp1
TMP2=/tmp/.tmp2

> $TMP1
> $TMP2

# check lock file, one time only let the script run one time 
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ];then
  echo
  echo "${CWARNING}The script is already exist, please next time to run this script${CEND}"
  echo
  exit
else
  echo
  echo "${CMSG}Step 1.No lock file, begin to create lock file and continue${CEND}"
  echo
  touch $LOCKfile
fi

# check disk partition
check_disk() {
  > $LOCKfile
  for i in `fdisk -l | grep -oE 'Disk /dev/x?[sv]d[b-z]' | awk '{print $2}'`
  do
    if [ -z "$(blkid | grep -v 'PTTYPE="dos"' | grep -w "$i")" ];then
      if [ -z "$(mount | grep "$i")" -a ! -e "${i}1" ]; then
        echo $i >> $LOCKfile
        echo "You have a free disk, Now will fdisk it and mount it"
      fi
      if [ -z "$(mount | grep "$i")" -a -e "${i}1" ]; then
         echo "${CWARNING}The $i has been partitioned! ${CEND}" 
         while :; do echo
           read -p "Do you want to reformat the partition? [y/n]: " reformat_yn
           if [[ ! $reformat_yn =~ ^[y,n]$ ]]; then
             echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
           else
             if [ "$reformat_yn" == 'y' ]; then
               echo "${CWARNING}You will format $i, Please backup the data in ${i}! ${CEND}"
               echo "Press Ctrl+c to cancel or Press any key to continue..."
               char=$(get_char)
               dd if=/dev/zero of=$i bs=512 count=1 &>/dev/null
               echo $i >> $LOCKfile
             fi
             break
           fi
         done
      fi
    fi
  done
  DISK_LIST=$(cat $LOCKfile)
  if [ "X$DISK_LIST" == "X" ];then
    echo
    echo "${CWARNING}No free disk need to be fdisk. Exit script${CEND}"
    echo
    rm -rf $LOCKfile
    exit 0
  else
    echo "${CMSG}This system have free disk :${CEND}"
    for i in `echo $DISK_LIST`
    do
      echo "$i"
      count=$((count+1))
    done
    [ $count -gt 1 ] && { echo "${CWARNING}This system has at least two free disk, You must manually mount it${CEND}"; exit 0; } 
  fi
}

# check os
check_os() {
  os_release=$(grep "Aliyun Linux release" /etc/issue 2>/dev/null)
  os_release_2=$(grep "Aliyun Linux release" /etc/aliyun-release 2>/dev/null)
  if [ "$os_release" ] && [ "$os_release_2" ];then
    if echo "$os_release" | grep "release 5" >/dev/null 2>&1;then
      os_release=aliyun5
      modify_env
    fi
  fi
}

# install ext4
modify_env() {
  modprobe ext4
  yum -y install e4fsprogs
}

# fdisk ,formating and create the file system
fdisk_fun() {
fdisk -S 56 $1 << EOF
n
p
1


wq
EOF

sleep 5
mkfs.ext4 ${1}1
}

# make directory
make_dir() {
  echo "${CMSG}Step 4.Begin to make directory${CEND}"
  while :; do echo
    read -p "Please enter a location to mount (Default directory: /data): " MOUNT_DIR 
    [ -z "$MOUNT_DIR" ] && MOUNT_DIR=/data
    if [ -z "`echo $MOUNT_DIR | grep '^/'`" ]; then
      echo "${CWARNING}input error! The directory must begin with / ${CEND}"
    else
      break
    fi
  done
  [ ! -e "$MOUNT_DIR" ] && mkdir -p $MOUNT_DIR
  mkdir -p $MOUNT_DIR
  echo "$MOUNT_DIR" >> $TMP1
}

# config /etc/fstab and mount device
main() {
  for i in `echo $DISK_LIST`
  do
    echo
    echo "${CMSG}Step 3.Begin to fdisk free disk${CEND}"
    [ -n "`mount | grep ${i}1`" ] && { echo "${CFAILURE}The ${i}1 already mount${CEND}"; echo; exit 0; }
    fdisk_fun $i > /dev/null 2>&1
    echo
    echo "${i}1" >> $TMP2
  done
  make_dir
  > $LOCKfile
  paste $TMP2 $TMP1 > $LOCKfile
  echo
  echo "${CMSG}Step 5.Begin to write configuration to /etc/fstab and mount device${CEND}"
  while read a b
  do
    Dline=`grep -n ^${a} /etc/fstab | awk -F: '{print $1}'`
    [ -n "$Dline" ] && sed -i "${Dline}d" $FSTAB_FILE
    echo "${a}	$b	ext4	defaults	0 0" >> $FSTAB_FILE
  done < $LOCKfile
  mount -a
  echo
}

# start script
echo "${CMSG}Step 2.Begin to check free disk${CEND}"
#service mysqld stop
#mv /data /root
check_os
check_disk
main
df -h
#mv /root/data/* /data
#service mysqld start
rm -rf $LOCKfile $TMP1 $TMP2


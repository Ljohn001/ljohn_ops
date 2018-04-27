#!/bin/bash
#
#===============================
# Description: 双网卡绑定
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.10.27
# Version: 1.0
#===============================

# examples:
# sh -x set_bond.sh bond0 eth0 eht1 10.0.54.28

if [ $# != 4 ] ; then
echo "USAGE: $0 bondname   eth1  eth2  IP "
echo " e.g.: $0 bond1 em3  em4  10.0.1.1"
exit 1
fi
 
 
bondname=$1
card1=$2
card2=$3
IP=$4
 
GATEWAY=`echo -n $IP | awk -F '.' '{ print $1 "." $2 "." $3 "." }'`'1'
echo ip address is $IP
echo netmask is 255.255.255.0
echo gateway is $GATEWAY
echo bondname is $bondname
 
echo   -e "\033[42;33m  do you want to go on (Y|N)(NO and exit default): \033[0m"
read ANS
    case $ANS in
    y|Y|yes|Yes|YES)
       ;;
    n|no|No|NO|N)
     exit 1
       ;;
     *)
     echo "exit becasuse you cancel it "
     exit 1
      ;;
    esac
     
#bond0 config
echo "DEVICE=$bondname" > /etc/sysconfig/network-scripts/ifcfg-$bondname
echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-$bondname
echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-$bondname
echo "IPADDR=$IP" >> /etc/sysconfig/network-scripts/ifcfg-$bondname
echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/ifcfg-$bondname
echo "GATEWAY=$GATEWAY" >> /etc/sysconfig/network-scripts/ifcfg-$bondname
 
 
cat > /etc/sysconfig/network-scripts/ifcfg-$card1 <<EOF
BOOTPROTO=none
DEVICE=$card1
ONBOOT=yes
MASTER=$bondname
SLAVE=yes
EOF
 
cat > /etc/sysconfig/network-scripts/ifcfg-$card2 <<EOF
BOOTPROTO=none
DEVICE=$card2
ONBOOT=yes
MASTER=$bondname
SLAVE=yes
EOF
     
     
     
#modprobe config
echo "alias $bondname bonding" >> /etc/modprobe.d/bonding.conf
echo "options $bondname miimon=100 mode=4" >> /etc/modprobe.d/bonding.conf
modprobe bonding

# restart network interface
# /etc/init.d/network  restart

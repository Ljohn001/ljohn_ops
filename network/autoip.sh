#!/bin/bash
#

ROUTE=$(route -n|grep "^0.0.0.0"|awk '{print $2}')

BROADCAST=$(/sbin/ifconfig eth0|grep -i bcast|awk '{print $3}'|awk -F":" '{print $2}')

HWADDR=$(/sbin/ifconfig eth0|grep -i HWaddr|awk '{print $5}')

IPADDR=$(/sbin/ifconfig eth0|grep "inet addr"|awk '{print $2}'|awk -F":" '{print $2}')

NETMASK=$(/sbin/ifconfig eth0|grep "inet addr"|awk '{print $4}'|awk -F":" '{print $2}')

cat >/etc/sysconfig/network-scripts/ifcfg-eth0<<EOF
DEVICE=eth0
BOOTPROTO=static
BROADCAST=$BROADCAST
HWADDR=$HWADDR
IPADDR=$IPADDR
NETMASK=$NETMASK
GATEWAY=$ROUTE
ONBOOT=yes
EOF

#IPADDR1=$(echo $IPADDR|awk -F"." '{print $4}')
#cat >/etc/sysconfig/network-scripts/ifcfg-eth1<<EOF
#DEVICE=eth1
#BOOTPROTO=static
#BROADCAST=10.0.0.255
#HWADDR=$(/sbin/ifconfig eth1|grep -i HWaddr|awk '{print $5}')
#IPADDR=10.0.0.$IPADDR1
#NETMASK=255.255.255.0
#ONBOOT=yes
#EOF

HOSTNAME=ops_ljohn_$(echo $IPADDR|awk -F"." '{print $4}')

cat >/etc/sysconfig/network<<EOF
NETWORKING=yes
NETWORKING_IPV6=no
HOSTNAME=$HOSTNAME
GATEWAY=$ROUTE
EOF

echo "127.0.0.1  $HOSTNAME" >> /etc/hosts

hostname=$HOSTNAME

echo "nameserver  8.8.8.8"  > /etc/resolv.conf
echo "nameserver  8.8.4.4" >> /etc/resolv.conf


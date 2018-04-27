#!/bin/bash
#
#===============================
# Description: 获取系统相关信息 
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.9.20
# Version: 1.0
#===============================
system_info()
{
   echo "====================system info========================"
   VERSION=`cat /etc/redhat-release| awk 'NR==1{print}'`
   KERNEL=`uname -a|awk '{print $3}'`
   HOSTNAME=`uname -a|awk '{print $2}'`
   cat /etc/issue &> /dev/null
   if [ "$?" -ne 0 ];then
   echo -e "\033[31m The system is no support \033[0m"
   exit 1
   else
      echo -e "system_version is \033[32m $VERSION \033[0m"
      echo -e "system_kernel_version is  \033[32m $KERNEL \033[0m"
      echo -e "system_hostname is \033[32m $HOSTNAME \033[0m"
   fi

}

disk_info ()
{
   echo "======================disk info========================"
   DISK=$(df -ThP|column -t)
   echo -e "\033[32m $DISK \033[0m"
}

cpu_info ()
{
   echo "=======================cpu info========================"
   echo -e "cpu processor is \033[32m $(grep "processor" /proc/cpuinfo |wc -l) \033[0m"
   echo -e "cpu mode name is \033[32m $(grep "model name" /proc/cpuinfo |uniq|awk '{print $4,$5,$6,$7,$8,$9}') \033[0m"
   grep "cpu MHz" /proc/cpuinfo |uniq |awk '{print $1,$2":"$4}'
   awk '/cache size/ {print $1,$2":"$4$5}' /proc/cpuinfo |uniq
}

mem_info ()
{
   echo "====================memory info========================"
   MemTotal=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
   MemFree=$(awk '/MemFree/ {print $2}' /proc/meminfo)
   Buffers=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
   Cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
   FreeMem=$(($MemFree/1024+$Buffers/1024+$Cached/1024))
   UsedMem=$(($MemTotal/1024-$FreeMem))
   echo -e "Total memory is \033[32m $(($MemTotal/1024)) MB \033[0m"
   echo -e "Free  memory is \033[32m ${FreeMem} MB \033[0m"
   echo -e "Used  memory is \033[32m ${UsedMem} MB \033[0m"
}

loadavg_info ()
{
   echo "==================load average info===================="
   Load1=$(awk  '{print $1}' /proc/loadavg)
   Load5=$(awk  '{print $2}' /proc/loadavg)
   Load10=$(awk '{print $3}' /proc/loadavg)
   echo -e "Loadavg in 1  min is \033[32m $Load1 \033[0m"
   echo -e "Loadavg in 5  min is \033[32m $Load5 \033[0m"
   echo -e "Loadavg in 10 min is \033[32m $Load10 \033[0m"
}

network_info ()
{
   echo "====================network info======================="
   network_card=$(ip addr |grep inet |egrep -v "inet6|127.0.0.1" | awk '{print $NF}')
   IP=$(ip addr |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}') 
   echo -e "network_device is \033[32m $network_card \033[0m  address is  \033[32m $IP \033[0m"
}


system_info
disk_info 
cpu_info
mem_info 
loadavg_info   
network_info

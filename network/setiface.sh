#!/bin/bash
#===============================
# Description: CentOS7 网卡重命名eth0
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.11.19
# Version: 1.0
#===============================

# 检查是否run in root 
[ $(id -u) -gt 0 ] && echo "please use root run the script! " && exit 1

# 判断lshw是否安装 
if [ `rpm -qa lshw|wc -l` -eq 0  ]; then
    echo -e "\033[31m Error please install lshw! \033[0m"
    exit 1
fi

[ -f /etc/init.d/functions ] && . /etc/init.d/functions
# 修改网卡配置文件名称
function net () {
b0=-1
cat /proc/net/dev |grep ':' | grep -v 'lo' | cut -d: -f1 | sort >> /tmp/net_name.txt
while read line
do
 c0=$line
 b0=`expr $b0 + 1`
 mv /etc/sysconfig/network-scripts/ifcfg-$c0 /etc/sysconfig/network-scripts/ifcfg-eth$b0
# 修改网卡模式为static
 sed -i 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-eth$b0
# 删除包含IPV6的行
 sed -i '/IPV6/d' /etc/sysconfig/network-scripts/ifcfg-eth$b0
# 修改网卡DEVICE为eth.
 sed -i 's/'$c0'/eth'$b0'/g' /etc/sysconfig/network-scripts/ifcfg-eth$b0
done < /tmp/net_name.txt
}
# 重新配置grub配置并更新内核
function grub () {
sed -i 's/crashkernel=auto rhgb quiet/crashkernel=auto net.ifnames=0 biosdevname=0 rhgb quiet/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
}
 
# 修改网卡创建命名规则
function rules () {
b0=-1;
 lshw -c network| egrep "logical name" |awk -F " " '{print $3}' |while read line
do
 a0=$line
 b0=`expr $b0 + 1`
 c0=`lshw -c network | egrep -C 2 $a0|egrep serial | awk -F " " '{print $2}'`
 d0=`lshw -c network |egrep -C 2 $a0|egrep "bus info" | awk -F "@" '{print $2}'`
 echo 'ACTION=="add", SUBSYSTEM=="net", BUS=="pci", ATTR{address}=="'$c0'", ID=="'$d0'", NAME="eth'$b0'"' >>/etc/udev/rules.d/70-persistent-net.rules
 sed -i '$a HWADDR='$c0'' /etc/sysconfig/network-scripts/ifcfg-eth$b0
done
}
net
grub
rules

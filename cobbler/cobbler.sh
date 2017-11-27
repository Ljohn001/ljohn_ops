#!/bin/bash
#
#===============================
# Description: Cobbler for CentOS6
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.11.28
# Version: 1.1
#===============================

server_ip=192.168.0.40
dhcp_ip=192.168.0

# install epel
echo "install epel..."
#yum list |grep -E '^epel'
rpm -qa |grep -i epel &> /dev/null
if [ $? -eq 0 ];then
 echo "epel alread installed"
else
 rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
 if [ $? -eq 0 ];then
 echo "epel install successfully"
 else
 echo "epel install faild"
 exit 1
 fi
fi

# disable selinux
echo "disable selinux..."
sed -i '/^SELINUX=/ s/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
#getenforce
sestatus

# disable iptables
echo "disable iptables..."
service iptables stop
chkconfig iptables off

# install cobbler
for i in cobbler cobbler-web tftp tftp-server xinetd dhcp httpd mod_wsgi mod_ssl rsync 
do
 rpm -qc ${i} &> /dev/null
 if [ $? -ne 0 ];then
 echo -n "install ${i}..."
 yum install -y ${i} &> /dev/null
 if [ $? -eq 0 ];then
 echo "ok"
 else
 echo "faild"
 fi
 else
 echo "${i} alread installed"
 fi
done

# install packages what cobbler needs
for i in pykickstart debmirror python-ctypes python-cheetah python-netaddr python-simplejson python-urlgrabber PyYAML syslinux cman fence-agents createrepo mkisofs yum-utils
do
 rpm -qc ${i} &> /dev/null
 if [ $? -ne 0 ];then
 echo -n "install ${i}..."
 yum install -y ${i} &> /dev/null
 if [ $? -eq 0 ];then
 echo "ok"
 else
 echo "faild"
 fi
 else
 echo "${i} alread installed"
 fi
done

echo -n "configing cobbler..."
# config httpd
sed -i "s/#ServerName www.example.com:80/ServerName ${server_ip}:80/" /etc/httpd/conf/httpd.conf
sed -i 's/#LoadModule/LoadModule/g' /etc/httpd/conf.d/wsgi.conf

# config tftp
sed -i '/disable/c disable = no' /etc/xinetd.d/tftp
#sed -i '/disable/c disable = no' /etc/cobbler/tftpd.template

# config rsysnc
sed -i -e 's/= yes/= no/g' /etc/xinetd.d/rsync

# config debmirror
sed -i -e 's/@dists=.*/#@dists=/' /etc/debmirror.conf 
sed -i -e 's/@arches=.*/#@arches=/' /etc/debmirror.conf

# config cobbler
pwd=$(openssl passwd -1 -salt 'ljohn' '123456')
sed -i "s@default_password_crypted: .*@default_password_crypted: ${pwd}@" /etc/cobbler/settings
sed -i "s/server: 127.0.0.1/server: ${server_ip}/g" /etc/cobbler/settings
sed -i "s/next_server: 127.0.0.1/next_server: ${server_ip}/g" /etc/cobbler/settings
# pxe安装 只允许一次，防止误操作( 在正式环境有用。实际测试来，这个功能可以屏蔽掉 )
sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
sed -i 's/manage_rsync: 0/manage_rsync: 1/g' /etc/cobbler/settings
sed -i 's/manage_dhcp: 0/manage_dhcp: 1/g' /etc/cobbler/settings

# config dhcp
cp /etc/cobbler/dhcp.template{,.bak}
sed -i 's/DHCPDARGS=.*/DHCPDARGS=eth0/' /etc/sysconfig/dhcpd
\cp -f dhcp.template /etc/cobbler/dhcp.template
sed -i "s@192.168.137@$dhcp_ip@g;22d;23d" /etc/cobbler/dhcp.template
\cp -f dhcpd.conf /etc/dhcp/dhcpd.conf
sed -i "s@192.168.137.38@$server_ip@g" /etc/dhcp/dhcpd.conf
sed -i "s@192.168.137@$dhcp_ip@g" /etc/dhcp/dhcpd.conf

echo "ok"

chkconfig httpd on
chkconfig xinetd on
chkconfig cobblerd on
chkconfig dhcpd on
/etc/init.d/httpd restart
/etc/init.d/xinetd restart
/etc/init.d/cobblerd restart

#cobbler init scripts 启动脚本
cat cobbler.init >/etc/init.d/cobbler
chmod +x /etc/init.d/cobbler
chkconfig cobbler on
/etc/init.d/cobbler restart


echo -e "\ncobbler get-loaders..."
cobbler get-loaders
echo -e "\ncobbler sync..."
cobbler sync
echo -e "\ncobbler check..."
cobbler check
/etc/init.d/dhcpd restart

#cpoy ks file
cp CentOS-* /var/lib/cobbler/kickstarts
sed -i "s@192.168.137.38@$server_ip@g" /var/lib/cobbler/kickstarts/CentOS-7.4-x86_64.cfg
sed -i "s@192.168.137.38@$server_ip@g" /var/lib/cobbler/kickstarts/CentOS-6.8-x86_64.cfg

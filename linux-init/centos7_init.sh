#!/bin/bash
#
#
#=================================================================
# Description:  centos7_init_shell
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.10.30
# Version: 1.1
#=================================================================
cat << EOF
 +--------------------------------------------------------------+  
 |              === Welcome to  System init ===                 |  
 +--------------------------------------------------------------+  
EOF
#判断是否为root用，platform是否为X64
if  [ $(id -u) -gt 0 ]; then
    echo "please use root run the script!"
    exit 1
fi
platform=`uname -i`
osversion=`cat /etc/redhat-release | awk '{print $1}'`
if [[ $platform != "x86_64" ||  $osversion != "CentOS" ]];then
    echo "Error this script is only for 64bit and CentOS Operating System !"
    exit 1
fi
    echo "The platform is ok"

#add hostname
if [ "$1" == "" ];then
    echo "The host name is empty."
    exit 1
else
        hostname  $1
        echo "HostName is $1"
        sed -i "/HOSTNAME=/d" /etc/sysconfig/network
        echo "HOSTNAME=$1" >>/etc/sysconfig/network
fi
sleep 3

#configure yum source
yum_config(){
    yum install wget epel-release -y
    cd /etc/yum.repos.d/ && mkdir bak && mv -f *.repo bak/
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum clean all && yum makecache
    yum -y install iotop iftop net-tools lrzsz gcc gcc-c++ make cmake libxml2-devel openssl-devel curl curl-devel unzip sudo ntp libaio-devel wget vim ncurses-devel autoconf automake zlib-devel  python-devel bash-completion
}
#firewalld
iptables_config(){
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    yum install iptables-services -y
    systemctl enable iptables
    systemctl start iptables
    iptables -F
    service iptables save
}
#system config
system_config(){
    sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
    timedatectl set-local-rtc 1 && timedatectl set-timezone Asia/Shanghai
    yum -y install chrony && systemctl start chronyd.service && systemctl enable chronyd.service 
}
ulimit_config(){
    echo "ulimit -SHn 102400" >> /etc/rc.local
    cat >> /etc/security/limits.conf << EOF
    *           soft   nofile       102400
    *           hard   nofile       102400
    *           soft   nproc        102400
    *           hard   nproc        102400
EOF

}

#set sysctl
sysctl_config(){
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
    cat > /etc/sysctl.conf << EOF
    net.ipv4.ip_forward = 0
    net.ipv4.conf.default.rp_filter = 1
    net.ipv4.conf.default.accept_source_route = 0
    kernel.sysrq = 0
    kernel.core_uses_pid = 1
    net.ipv4.tcp_syncookies = 1
    kernel.msgmnb = 65536
    kernel.msgmax = 65536
    kernel.shmmax = 68719476736
    kernel.shmall = 4294967296
    net.ipv4.tcp_max_tw_buckets = 6000
    net.ipv4.tcp_sack = 1
    net.ipv4.tcp_window_scaling = 1
    net.ipv4.tcp_rmem = 4096 87380 4194304
    net.ipv4.tcp_wmem = 4096 16384 4194304
    net.core.wmem_default = 8388608
    net.core.rmem_default = 8388608
    net.core.rmem_max = 16777216
    net.core.wmem_max = 16777216
    net.core.netdev_max_backlog = 262144
    net.core.somaxconn = 262144
    net.ipv4.tcp_max_orphans = 3276800
    net.ipv4.tcp_max_syn_backlog = 262144
    net.ipv4.tcp_timestamps = 0
    net.ipv4.tcp_synack_retries = 1
    net.ipv4.tcp_syn_retries = 1
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_tw_reuse = 1
    net.ipv4.tcp_mem = 94500000 915000000 927000000
    net.ipv4.tcp_fin_timeout = 1
    net.ipv4.tcp_keepalive_time = 30
    net.ipv4.ip_local_port_range = 1024 65000
EOF
    /sbin/sysctl -p
    echo "sysctl set OK!!"
}

main(){
    yum_config
    iptables_config
    system_config
    ulimit_config
    sysctl_config
}
main

cat << EOF
 +--------------------------------------------------------------+  
 |                === System init Finished ===                  |  
 +--------------------------------------------------------------+  
EOF
sleep 3
echo "Please reboot your system!"

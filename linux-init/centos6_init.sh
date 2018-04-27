#!/bin/bash
#=================================================================
# Description:  centos6_init_shell
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.12.26
# Version: 1.2
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

#0.set hostname
set_hostname() {
# 判断是否给脚本参数作为Hostname,参数为0跳出函数继续执行脚本，参数为1设置Hostname
if [ $# -eq 0 ];then
    echo "The host name is empty."
    return 1
elif [ $# -eq 1 ];then
    echo "HostName is $1"
    sed -i "/HOSTNAME=/d" /etc/sysconfig/network
    echo "HOSTNAME=$1" >>/etc/sysconfig/network
else
    echo "The parameter is invalid,Please input again and rerun it！"
    exit 1
fi
}

set_hostname $1
sleep 2

DATE=`date +%Y_%m_%d:%H_%M_%S`  
INIT_LOG="system_init_$DATE.log"  

#1.add_users_config  
#添加用户,指定UID，密码不能明文显示  
add_users_config(){
/usr/sbin/useradd -u 1001 -m -G 10 Ljohn
if [ $? -eq 0 ]; then
    echo "1356236" | passwd --stdin Ljohn &> /dev/null
fi
USER1=(Ljohn)  
for iii in `echo ${USER1[*]}`  
do  
    if grep -qs "$iii" /etc/passwd;then  
        echo "$DATE [1.add_users_config] $iii is added [success]" >>/root/${INIT_LOG}  
    fi  
done  
}

#2.sudoer_config
#给Ljohn用户配置sudo权限
sudoer_config(){
sed -i 's/Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers  
echo -e "User_Alias SYSADMINS = Ljohn" >> /etc/sudoers  
echo -e "SYSADMINS       ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers  
echo "$DATE [2.sudoer_config] is [success]" >>/root/${INIT_LOG}  
}

#3.limits_config  
#修改文件描述符
limits_config(){
echo "*                soft   nofile          65535" >>/etc/security/limits.conf  
echo "*                hard   nofile          65535" >>/etc/security/limits.conf  
echo "*                soft   noproc          65535" >>/etc/security/limits.conf  
echo "*                hard   noproc          65535" >>/etc/security/limits.conf  
sed -i '/1024/s/1024/65535/g' /etc/security/limits.d/90-nproc.conf  
echo "$DATE [3.limits_config] is [success]" >>/root/${INIT_LOG}  
}

#4.sysctl_config 
#内核参数配置，这个需要根据系统用途来配置。 
sysctl_config(){
echo "#基本参数优化" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_max_syn_backlog = 4096" >> /etc/sysctl.conf  
echo "net.core.netdev_max_backlog = 10240" >> /etc/sysctl.conf  
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf  
echo "net.core.somaxconn = 2048" >> /etc/sysctl.conf  
echo "net.core.wmem_default = 8388608" >> /etc/sysctl.conf  
echo "net.core.rmem_default = 8388608" >> /etc/sysctl.conf  
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf  
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf  
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_syn_retries = 2" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf  
echo "net.ipv4.ip_local_port_range = 5000    65000 " >> /etc/sysctl.conf  
sysctl -p 
echo "$DATE [4.sysctl_config] is [success]" >>/root/${INIT_LOG}  
}

#5.history_config  
#调整HISTSIZE大小，默认为1000
history_config(){
if [ ! -f "/etc/profile.d/ljohn.sh" ];then
cat >/etc/profile.d/ljohn.sh << EOF
HISTSIZE=10000
PS1='\[\e[32;1m\][\u@\h \W]\\$\[\e[0m\]'
HISTTIMEFORMAT="%F %T $(whoami) "

alias l='ls -AFhlt'
alias lh='l | head'
alias vi=vim

GREP_OPTIONS="--color=auto"
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
EOF
   chmod 644 /etc/profile.d/ljohn.sh
   source /etc/profile.d/ljohn.sh
else 
   echo "history_config is configed"
fi
   echo "$DATE [5.history_config] is [success]" >>/root/${INIT_LOG}  
}

#6.pass_length and login count limit  
pass_length(){
sed -i '25s/99999/90/g' /etc/login.defs  
sed -i '27s/5/8/g' /etc/login.defs  
sed -i '5i auth        required      /lib64/security/pam_tally2.so deny=3 unlock_time=300' /etc/pam.d/system-auth  
echo "$DATE [6.pass_length and login count limit] is [success]" >>/root/${INIT_LOG}
}

#7.disable_selinux_config  
#关闭selinux
disable_selinux_config(){
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config  
setenforce 0  
echo "$DATE [7.disable_selinux_config] is [success]" >>/root/${INIT_LOG}  
}

#8.ntp_config
#配置时间同步  
ntp_config(){
ntp_config_count=`crontab -l | grep ntpdate|wc -l`  
if [ ${ntp_config_count} -eq 0 ];then  
cat<<EOF >>/var/spool/cron/root  
0 1 * * * /usr/sbin/ntpdate -u ntp.api.bz >/dev/null 2>&1 
EOF
fi
if [ $? = 0 ];then
    echo "$DATE [8.ntp_config] is [success]" >>/root/${INIT_LOG}  
fi
}

#9.maxlogins_config
#限制用户最大连接数为:5  
maxlogins_config(){
echo "Ljohn          -       maxlogins       5" >> /etc/security/limits.conf  
echo "$DATE [9.maxlogins_config] is [success]" >>/root/${INIT_LOG}  
}
#10.disbled_ipv6_config
#关闭IPv6  
disbled_ipv6_config(){
cat >/etc/modprobe.d/disableipv6.conf << EOF  
alias net-pf-10 off  
options ipv6 disable=1  
EOF
echo "$DATE [10.disble_ipv6_config] is [success]" >>/root/${INIT_LOG}  
}

#11.character_config 
#设置字符集：en_US.UTF-8 
character_config(){
cat >/etc/sysconfig/i18n<<EOF
LANG="en_US.UTF-8"
SYSFONT="latarcyrheb-sun16"
EOF
echo "$DATE [11.character_config] is [sucess]" >>/root/${INIT_LOG}
}

#12.disable_service_config 
#关闭所有服务，在开启必须的四个服务
disable_service_config(){
for sun in `chkconfig --list|grep 3:on|awk '{print$1}'`;do chkconfig --level 3 $sun off;done
for sun in {crond,sshd,network,rsyslog};do chkconfig --level 3 $sun on;done
if [ $? -eq 0 ];then
    echo "$DATE [12.disable_service_config] is [success]" >>/root/${INIT_LOG}  
fi
}

#13.DNS config
#DNS配置 
dns_config(){
cat > /etc/resolv.conf << EOF 
nameserver 202.96.209.5
nameserver 8.8.8.8
EOF
if [ $? -eq 0 ];then
    echo "$DATE [13.DNS config] is [success]" >>/root/${INIT_LOG}
fi
}

#14.sshd_config  
#sshd相关优化,
sshd_config(){
#sed "s/#Port 22/Port 22/g" /etc/ssh/sshd_config -i  
#sed "s/^#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config -i  
#sed 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config -i  
#ssh连接速度优化
sed "s/#UseDNS yes/UseDNS no/g" /etc/ssh/sshd_config -i  
sed 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config -i  
/etc/init.d/sshd restart
echo "$DATE [14.sshd_config] is [success]" >>/root/${INIT_LOG}  
}

#15.yum resource config
#yum源配置
yum_config(){
cp -r /etc/yum.repos.d /etc/yum.repos.d.backup && rm -rf /etc/yum.repos.d/*
[ -d /etc/yum.repos.d/ ] && cd /etc/yum.repos.d/
curl -O http://mirrors.aliyun.com/repo/Centos-6.repo
curl -O http://mirrors.aliyun.com/repo/epel-6.repo
#wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/{Centos-6.repo,epel-6.repo}
yum clean all
yum install ntpdate vim openssh-clients lrzsz tree ftp telnet -y
if [ $? -eq 0 ];then
    echo "$DATE [15.yum resource config] is [success]" >>/root/${INIT_LOG}
fi
}

main(){
add_users_config
sudoer_config
limits_config
sysctl_config
history_config
pass_length
disable_selinux_config
ntp_config
maxlogins_config
disbled_ipv6_config
character_config
disable_service_config
dns_config
sshd_config
yum_config
}
main

cat << EOF
 +--------------------------------------------------------------+  
 |                === System init Finished ===                  |  
 +--------------------------------------------------------------+  
EOF
sleep 3 
#重启系统
Reboot(){
read -p "Do you want to reboot the system? {yes or no}: " command 
if [ "$command" == "yes" ]; then
   echo "Reboot now!"
   reboot
elif [ "$command" == "no" ]; then
   echo "Centos6 init is ok! please enjoy it!"
   exit 0
else
   echo "Please input  yes or no! but,you can manual reboot it !!"
   exit 1
fi
}
Reboot


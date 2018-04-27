#!/bin/bash
#
#===============================
# Description:  Install yum repo for CentOS6.x or 7.x
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.10.27
# Version: 1.0
#===============================


if  [ $(id -u) -gt 0 ]; then
    echo "please use root run the script!"
    exit 1
fi
platform=`uname -i`
osversion=`cat /etc/redhat-release | awk '{print $1}'`
if [[ $platform != "x86_64" ||  $osversion != "CentOS" ]];then
    echo "Error this script is only for 64bit and CentOS/5/6/7 Operating System !"
    exit 1
fi
    echo "the platform is ok"

OS_Version=$(awk '{print $(NF-1)}' /etc/redhat-release)
echo "Your system version is $OS_Version"
cp -r /etc/yum.repos.d /etc/yum.repos.d.backup && rm -rf /etc/yum.repos.d/*
if [[ $OS_Version > 6 &&  $OS_Version < 7 ]];then
    [ -d /etc/yum.repos.d/ ] && cd /etc/yum.repos.d/
    curl -O http://mirrors.aliyun.com/repo/Centos-6.repo &> /dev/null  && curl -O http://mirrors.aliyun.com/repo/epel-6.repo &> /dev/null
    rpm --import  https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6 
    yum clean all &> /dev/null  && echo "CentOS6 yum repo is installed"
elif [[ $OS_Version > 7 ]];then
    [ -d /etc/yum.repos.d/ ] && cd /etc/yum.repos.d/
    curl -O http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null && curl -O http://mirrors.aliyun.com/repo/epel-7.repo &> /dev/null
    rpm --import  https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
    yum clean all &> /dev/null && echo "CentOS7 yum repo is installed"
elif [[ $OS_Version < 6 ]];then
    [ -d /etc/yum.repos.d/ ] && cd /etc/yum.repos.d/
cat > CentOS-Base.repo << EOF
[base]
name=CentOS-\$releasever - Base
baseurl=http://vault.centos.org/5.11/os/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#released updates
[updates]
name=CentOS-\$releasever - Updates
baseurl=http://vault.centos.org/5.11/updates/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#additional packages that may be useful
[extras]
name=CentOS-i\$releasever - Extras
baseurl=http://vault.centos.org/5.11/extras/\$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus
baseurl=http://vault.centos.org/5.11/centosplus/\$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#contrib - packages by Centos Users
[contrib]
name=CentOS-\$releasever - Contrib
baseurl=http://vault.centos.org/5.11/contrib/\$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
EOF
    yum clean all &> /dev/null
    rpm --import http://vault.centos.org/RPM-GPG-KEY-CentOS-5
    echo "CentOS5 yum repo is installed"
else
    echo -e "\033[31m Do not support your OS!!\033[0m"
    exit 1
fi

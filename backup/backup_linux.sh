#!/bin/bash
#
# by ljohn
# time 2020.3.19
HIP=$(hostname -I|awk '{print $1}')
backupdir=/tmp/backup/${HIP}
[ ! -d $backupdir ] && mkdir -p $backupdir

# 备份deb包名称列表
( zcat /var/log/apt/history.log*.gz | grep Commandline: ;  zcat /var/log/apt/history.log*.gz | grep Commandline: ) > ${backupdir}/deb.list.txt
# 备份配置文件
cd /; sudo tar -cvzf ${backupdir}/etc.tgz etc var/spool/cron/crontabs usr/local/{bin,sbin}

# 备份重要个人文件
sudo tar --ignore-failed-read -zcvp -f ${backupdir}/backup-$(date '+%Y-%m-%d_%H_%M_%S').tgz  \
        --exclude=/root/.cache \
        --exclude=/root/.gradle \
        --exclude=/root/.m2 \
        --exclude=/root/.mozilla \
        --exclude=/root/.IntelliJIdea2019.1 \
        --exclude=/root/.xsession-errors \
        --exclude=/root/.deepinwine \
        --exclude=/root/.local \
        --exclude=/root/.config/google-chrome \
        --exclude=/root/.config/oss-browser \
        --exclude=/root/Documents \
        --exclude=/root/Downloads \
        --exclude=/root/Music \
        --exclude=/opt/prometheus \
        --add-file=/root \
        --add-file=/opt

# 远程备份
#rsync -av -P --progress  $backupdir/ ljohn@10.3.149.7:/backup/${HIP}/

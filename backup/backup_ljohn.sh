#!/bin/bash
#
# by ljohn
# time 2020.3.19

backupdir=/backup/`hostname`
sudo chown -R ljohn.ljohn $backupdir
[ ! -d $backupdir ] && sudo mkdir -p $backupdir

# 备份deb包名称列表
( zcat /var/log/apt/history.log*.gz | grep Commandline: ;  zcat /var/log/apt/history.log*.gz | grep Commandline: ) > ${backupdir}/deb.list.txt
# 备份配置文件
cd /; sudo tar -cvzf ${backupdir}/etc.tgz etc var/spool/cron/crontabs usr/local/{bin,sbin}

# 备份重要个人文件
sudo tar -zcvp -f ${backupdir}/backup-$(date '+%Y-%m-%d_%H_%M_%S').tgz  \
        --exclude=/home/ljohn/.cache \
        --exclude=/home/ljohn/.gradle \
        --exclude=/home/ljohn/.m2 \
        --exclude=/home/ljohn/.mozilla \
        --exclude=/home/ljohn/.IntelliJIdea2019.1 \
        --exclude=/home/ljohn/.xsession-errors \
        --exclude=/home/ljohn/.deepinwine \
        --exclude=/home/ljohn/.local \
        --exclude=/home/ljohn/.config/google-chrome \
        --exclude=/home/ljohn/.config/oss-browser \
        --exclude=/home/ljohn/Documents \
        --exclude=/home/ljohn/Downloads \
        --exclude=/home/ljohn/Music \
        --add-file=/home/ljohn \
        --add-file=/opt \
        --add-file=/server \
        --add-file=/vpwork 

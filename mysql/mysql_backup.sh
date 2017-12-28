#!/bin/bash
#
#===============================
# Description: mysql backup scripts
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.12.28
# Version: 1.0
#===============================
#
# mysql root账号
id="root"
pwd="root"
# mysql 库名称，注意要以空格隔开
databases="vsftpd  test " 
#databases="test"
# mysql 备份目录 
backupdir="/home/mysqldatabak"
# mysql 备份保留时间
day=15

[ ! -d $backupdir ] && mkdir -p $backupdir
cd $backupdir

backupname=$(date +%Y-%m-%d)
for db in $databases;
do
   mysqldump -u$id -p$pwd -S /var/lib/mysql/mysql.sock $db >$backupname_$db.sql 
   if [ "$?" == "0" ] 
   then
       echo $(date +%Y-%m-%d)" $db  mysqldump sucess">>mysql.log 
   else
      echo $(date +%Y-%m-%d)"  $db mysql dump failed">>mysql.log
      exit 0
   fi
done
for db in $databases;
do
	tar -czf $db.$backupname.tar.gz $db.sql
done
if [ "$?" == "0" ]
then
   echo $(date +%Y-%m-%d)" tar sucess">>mysql.log
else
   echo $(date +%Y-%m-%d)" tar failed">>mysql.log
   exit 0
fi

# 删除所有sql文件，删除15天前的备份
rm -f *.sql
delname=mysql_$(date -d "$day day ago" +%Y-%m-%d).tar.gz
rm -f $delname

#!/bin/bash
#
user='root'
passwd=''
database=test
nowtime=`date +%m-%d"-"%H:%M`
host=localhost
log=/var/log/mysqlbackup.log
backup_dir=/data/backup/
dump_command=/usr/local/mysql/bin/mysqldump
backup_file=/data/backup/$database-${nowtime}.sql

if [ ! -d "$backup_dir" ];then
    mkdir $backup_dir
fi
if [ ! -f "$log" ];then
    touch $log
fi
echo "Start to backup at $(date +%Y%m%d%H%M)" >> $log
$dump_command -u$user -p$passwd -h $host --opt --lock-all-tables --flush-logs --master-data=2 --databases $database|gzip > $backup_file.gz
if [ $? -eq 0 ];then
    echo "Backup is finish! at $(date +%Y%m%d%H%M)" >> $log    
    exit 0
else
    echo "Backup is Fail! at $(date +%Y%m%d%H%M)" >> $log
    exit 1
fi

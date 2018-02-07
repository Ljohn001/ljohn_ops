#!/bin/bash
#
#author: Ljohn
#last update: 2018.1.29
:<<BLOCK
每天1：00 备份/var/log 目录下前一天的日志文件并存放在当前目录中btslog 目录中，
然后删除15天前的log备份文件，实用shell脚本完成。日志格式：btsvr.log.2018-01-01,
打包备份文件搁置为btsvr.log.2018-01-01.tar.gz
BLOCK

yesterday=$(date  +"%Y-%m-%d" -d  "-1 days")
backupdir=/server/backup/btslog
[ ! -d $backupdir ] && mkdir -p $backupdir 

backup_yes() {
    cd ${backupdir}
    mv /var/log/btsvr.log.${yesterday} ${backupdir}
    tar -czvf btsvr.log.${yesterday}.tar.gz btsvr.log.${yesterday}
    
    if [ $? -eq 0 ];then
        rm -f ./btsvr.log.${yesterday}
    fi
}

delete_old() {
    find ./ -name "*.tar.gz" -ctime +15  -exec rm -rf {} \;
}
backup_yes
delete_old

# crontab -e 定时任务
# 0 1 * * * /bin/bash /server/scripts/bak_log.sh &> /dev/null

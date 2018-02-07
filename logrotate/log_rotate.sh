#!/bin/bash
#author: ljohn
#last update: 2018.1.29 

function rotate() {
logs_path=$1
 
echo Rotating Log: $1
cp ${logs_path} ${logs_path}.$(date -d "yesterday" +"%Y%m%d")
> ${logs_path}
    rm -f ${logs_path}.$(date -d "7 days ago" +"%Y%m%d")
}
 
for i in $*
do
        rotate $i
done


# crontab -e 添加定时任务: 每晚0点30分执行
# 30 0 * * * /bin/find /var/log/nginx/ -size +0 -name '*.log' | xargs /server/script/log_rotate.sh

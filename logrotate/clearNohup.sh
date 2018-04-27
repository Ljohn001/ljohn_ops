#!/bin/bash
# Author: Ljohn
# Last Update: 2018.02.24
# Description: nohup.out 日志分割

this_path=$(cd `dirname $0`;pwd)   #根据脚本所在路径
current_date=`date -d "-1 day" "+%Y%m%d"`   #列出时间
cd $this_path
echo $this_path
echo $current_date  

do_split () {
    [ ! -d logs ] && mkdir -p logs
    split -b 10m -d -a 4 ./nohup.out   ./logs/nohup-${current_date}  #切分10兆每块至logs文件中，格式为：nohup-xxxxxxxxxx
    if [ $? -eq 0 ];then
        echo "Split is finished!"
    else
        echo "Split is Failed!"
        exit 1
    fi
}

do_del_log() {
    find ./logs -type f -ctime +7 | xargs rm -rf #清理7天前创建的日志
    cat /dev/null > nohup.out #清空当前目录的nohup.out文件
}

if do_split ;then
    do_del_log
    echo "nohup is split Success"
else
    echo "nohup is split Failure"
    exit 2
fi

# crontab -e 添加定时任务:每周第一天的1点执行一次
#0 1 * * */1 /server/scripts/clearNohup.sh &>/dev/null

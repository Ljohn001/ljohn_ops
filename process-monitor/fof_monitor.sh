#!/bin/bash
#
#===============================
# Description:  monitor process，restart process
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2018.01.26
# Version: 1.0
#===============================
#
#set env 
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export LANG=en_US.UTF-8

# run this script use root
[ $(id -u) -gt 0 ] && echo "please use root run the script! " && exit 1 

# 进程名，路径，及服务URL
ProcNam=cljj_fof
PPATH=/cljj/apps/50cljj_fof
URLS=http://127.0.0.1:9015/webfof_login/login

MAIL=`which mail`
IP=`ip addr| grep eth0 |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
LOG=/tmp/process_monitor.log
TIME=$(date +%Y-%m-%d-%H-%M-%S)

# curl 获取状态码
curl_ip() {
  CURL=$(curl -o /dev/null -s --connect-timeout 5 -w '%{http_code}' $1|egrep "200|302"|wc -l)
  return $CURL
}

# mail name
NAME=(
liujian
wanhonglei
)

# 邮件
mail() {
     for m in ${NAME[*]}
     do
         echo "$1 restart failure on $TIME, Please check $1 on $IP!!" | $MAIL -s " FOF restart failure"  $m@erichfund.com
     done
}

# 重新拉起服务
start_proc() {
   ProcNum=`ps -ef|grep $ProcNam | grep -v grep |wc -l`
   curl_ip $URLS &> /dev/null
   if [ $CURL -eq 0 -o  $ProcNum  -eq 0 ]; then #判断进程是否存在，url请求是否成功，任意一个条件满足就执行重启
      $PPATH/startx.sh &> /dev/null 
      if [ $? -eq 0 ];then
         echo "-------$TIME-------" >> $LOG
         echo "starting $ProcNam..." >> $LOG
         echo "$ProcNam is restarted!!" >> $LOG
         sleep 30
         # 如果重启完成，还是无法访问url，则发邮件通知管理员
         curl_ip $URLS &> /dev/null
         if [ $CURL -ne 1 ];then
            mail $ProcNam
         else
            echo "$ProcNam status is ok" >> $LOG
         fi
      fi
   fi 
}

# 第一次判断URL是否正常访问，如果不正常，那么sleep 1分钟
curl_ip $URLS
if [ $? -eq 1 ];then
   action "curl $URLS" /bin/true
else
   action "curl $URLS" /bin/false
   sleep 60 #防止项目正在上线
     curl_ip $URLS
     if [ $CURL -eq 1 ];then
        action "Retry curl $URLS again" /bin/true
     else
        action "Retry curl $URLS again" /bin/false
        start_proc
    fi
fi


# crontab 定时每1分钟执行一次
# * * * * * /bin/bash /server/scripts/fof_monitor.sh &>/dev/null

#!/bin/bash
#
#===============================
# Description:  monitor process，restart process
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2018.01.25
# Version: 1.0
#===============================
#
#set env 
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

# 判断当进程数为0，或访问url失败则执行重启
ProcNum=`ps -ef|grep $ProcNam | grep -v grep |wc -l`
curl_ip $URLS &> /dev/null
if [ $CURL -eq 0 -o  $ProcNum  -eq 0 ]; then
   $PPATH/startx.sh &> /dev/null 
   if [ $? -eq 0 ];then
      echo "-------$TIME-------" >> $LOG 
      echo "starting $ProcNam..." >> $LOG
      echo "$ProcNam is restarted!!" >> $LOG
      sleep 10
      # 如果重启完成，还是无法访问url，则发邮件通知管理员
      curl_ip $URLS &> /dev/null
      if [ $CURL -ne 1 ];then 
         echo "$ProcNam state is failure on $TIME,Please check FOF on $IP!!" | $MAIL -s " FOF state Warning"  liujian@erichfund.com
      else
         echo "$ProcNam status is ok" >> $LOG
      fi
   fi
fi


# crontab 定时每5分钟执行一次
# */5 * * * * /bin/bash /server/scripts/fof_monitor.sh &>/dev/null

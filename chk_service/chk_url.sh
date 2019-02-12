#!/bin/bash
#
#===============================
# Description:  check url status
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2018.01.16
# Version: 1.0
#===============================
#
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

DATE=$(date +%Y-%m-%d-%H-%M-%S)
MAIL=`which mail`
# mail name
NAME=(
liujian
e_yunwei
)
# check urls status
URLS=(
http://192.168.1.233:9004/webfof_login/login
http://www.tst.com
)

# curl 获取状态码
curl_ip() {
  CURL=$(curl -o /dev/null -s --connect-timeout 5 -w '%{http_code}' $1|egrep "200|302"|wc -l)
  return $CURL
}

# 邮件
mail() {
     for m in ${NAME[*]}
     do
         echo "Retry curl $1 again is Failure,Please check url on $DATE" | $MAIL -s "Service state Warning" $m@erichfund.com
     done
}

# 主程序
main() {
   for n in ${URLS[*]}
   do
      curl_ip $n
      if [ $? -eq 1 ];then
         action "curl $n" /bin/true
      else
         action "curl $n" /bin/false
           curl_ip $n
           sleep 10
           if [ $CURL -eq 1 ];then
              action "Retry curl $n again" /bin/true
           else
              action "Retry curl $n again" /bin/false
              mail $n
          fi
      fi
   done
}
main

# crontab 添加定时任务5分钟执行一次。
# */5 * * * * /bin/bash /server/scripts/chk_url.sh &>/dev/null

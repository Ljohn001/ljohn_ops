#!/bin/bash
#
#===============================
# Description:  check url status
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2018.01.26
# Version: 1.0
#===============================
#
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

#chek url status
array=(
http://baidu.com
http://qq.com
http://taobao.com
http://192.168.1.233:9015/webfof_login/login
)

curl_ip() {
  CURL=$(curl -o /dev/null -s --connect-timeout 5 -w '%{http_code}' $1|egrep "200|302"|wc -l)
  return $CURL
}

main() {
   for n in ${array[*]}
   do 
      curl_ip $n
      if [ $? -eq 1 ];then
         action "curl $n" /bin/true
      else
         action "curl $n" /bin/false
         sleep 30 #try again after sleep 30 
          #CURL=$(curl $n|egrep "200|302"|wc -l)
           curl_ip $n
           if [ $CURL -eq 1 ];then
              action "Retry curl $n again" /bin/true
           else
              action "Retry curl $n again" /bin/false
          fi 
      fi
   done
} 
main

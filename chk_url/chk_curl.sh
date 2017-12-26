#!/bin/bash
#
#===============================
# Description:  check url status
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.12.26
# Version: 1.0
#===============================
#
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

#chek url status
array=(
http://baidu.com
http://qq.com
http://taobao.com
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
           CURL=$(curl_ip $n|egrep "200|302"|wc -l)
           if [ $CURL -eq 1 ];then
              action "Retry curl $n again" /bin/true
           else
              action "Retry curl $n again" /bin/false
          fi 
      fi
   done
} 
main

#!/bin/bash
#

[ -f /etc/init.d/functions ] && . /etc/init.d/functions

array=(
http://baidu.com
http://qq.com
http://taobao.com
)

curl_ip() {
  wget -T 5 -t 2 --spider $1 &>/dev/null
  return $?
}

main() {
   for n in ${array[*]}
   do 
      curl_ip $n
      if [ $? -eq 0 ];then
         action "curl $n" /bin/true
      else
         action "curl $n" /bin/false
      fi
   done
} 
main

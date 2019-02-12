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
#[ -f /lib/lsb/init-functions ] && . /lib/lsb/init-functions

if [ $# -ne 1 ];then
    echo "need 1 parameter"
    exit 0
fi

#env=$(echo $1| tr '[A-Z]' '[a-z]')
env=$1

#chek services status
services=(
vphotossaas
)

get_version() {
	version=$(curl -s  http://api-${env}.vphotos.cn/$1/mini/app/healthCheck| jq -r '.version'|awk '{print $1}') 
	#return ${version}
}

get_code_status() {
	code_status=$(curl -s  http://api-${env}.vphotos.cn/$1/mini/app/healthCheck| jq -r '.code')
	#return ${code_status}
}

get_pod_name() {
	pod_name=$(curl -s  http://api-${env}.vphotos.cn/$1/mini/app/healthCheck| jq -r '.localName')
	return ${pod_name}
}


curl_ip() {
  CURL=$(curl -o /dev/null -s --connect-timeout 5 -w '%{http_code}' $1|egrep "200|302"|wc -l)
  return $CURL
}

main() {
   for n in ${services[*]}
   do 
       get_version $n && get_code_status $n 
      if [ $? -eq 0 ];then
         echo -e "$n status: ${code_status}"  "\033[32m sucess \033[0m"  "version: ${version}"
      else
         echo -e  "$n status: ${code_status}" "\033[31m failed \033[0m" "version: ${version}"
         sleep 3 #try again after sleep 10 
          #CURL=$(curl $n|egrep "200|302"|wc -l)
           get_code_status $n
           if [ ${code_status} -eq 0 ];then
              echo -e  "Retry $n again status" "\033[32m sucess \033[0m" 
           else
              echo -e "Retry $n again status" "\033[31m failed \033[0m" 
          fi 
      fi
   done
} 
main

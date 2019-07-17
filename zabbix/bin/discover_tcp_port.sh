#!/bin/bash

portarray=(`netstat -tnl|egrep -i "$1"|awk {'print $4'}|awk -F':' '{if ($NF~/^[0-9]*$/) print $NF}'|sort|uniq`)
#portarray=(`netstat -tnlp|egrep -i "$1"|awk {'print $4'}|awk -F':' '{if ($NF~/^[0-9]*$/) print $NF}'`)
#portarray=(`ss -lnp |awk '{print $4}' |awk -F\: '/:/ {print  $NF}'`)
#namearray=(`netstat -tnl|egrep -i "$1"|awk {'print $7'}|awk -F'/' '{if ($NF != "Address") print $NF}'`)
#namearray=(`ss -lnp |awk '{print $NF}' |awk -F\" '{print $2}' |grep -v "^$"`)
length=${#portarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
  do
     printf '\n\t\t{'
     printf "\"{#TCP_PORT}\":\"${portarray[$i]}\"}"
#     printf "\"{#TCP_NAME}\":\"${namearray[$i]}\"}"
     if [ $i -lt $[$length-1] ];then
                printf ','
     fi
  done
printf  "\n\t]\n"
printf "}\n"

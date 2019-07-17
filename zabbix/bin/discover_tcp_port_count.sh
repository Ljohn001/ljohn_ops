#!/bin/bash
#source/etc/bashrc >/dev/null 2>&1
#source/etc/profile >/dev/null 2>&1
tcp_status_file='/tmp/tcp_status_count.txt'
tcp_interval="60"


tcp_port_discovery(){

	#portarray=(`netstat -tnl|egrep -i "$1"|awk {'print $4'}|awk -F':' '{if ($NF~/^[0-9]*$/) print $NF}'|sort|uniq`)
	portarray=(`sudo netstat -tnlp|egrep -i "$1"|awk {'print $4'}|awk -F':' '{if ($NF~/^[0-9]*$/) print $NF}'`)
	#portarray=(`ss -lnp |awk '{print $4}' |awk -F\: '/:/ {print  $NF}'`)
	namearray=(`sudo netstat -tnlp|egrep -i "$1"|awk {'print $7'}|awk -F'/' '{if ($NF != "Address") print $NF}'`)
	#namearray=(`ss -lnp |awk '{print $NF}' |awk -F\" '{print $2}' |grep -v "^$"`)
	length=${#portarray[@]}
	printf "{\n"
	printf  '\t'"\"data\":["
	for ((i=0;i<$length;i++))
		do
		printf '\n\t\t{'
		#printf "\"{#TCP_PORT}\":\"${portarray[$i]}\"}"
		printf "\"{#TCP_PORT}\":\"${portarray[$i]}\","
     		printf "\"{#TCP_NAME}\":\"${namearray[$i]}\"}"
		if [ $i -lt $[$length-1] ];then
			printf ','
		fi
	done
	printf  "\n\t]\n"
	printf "}\n"	
}



tcp_port_count(){
	#/usr/bin/curl-o /dev/null -s -w %{http_code} http://$1
	#ss -na |awk  "/$2/ {print $4}" |grep $1 -c

	if [ ! -f ${tcp_status_file} ];then
		sudo netstat -an|awk '/^tcp/ {print $0}' > $tcp_status_file
	else
		file_time=$(date +%s -d "`stat ${tcp_status_file} |awk '/Modify/ {print $2,$3}'`")
		if [ $((`date +%s` -60)) -ge ${file_time} ];then
			sudo netstat -an|awk '/^tcp/ {print $0}' > $tcp_status_file
		fi
	fi
	awk "/$2/ {print $4}" $tcp_status_file |grep $1 -c 
	
}
	

case "$1" in
tcp_port_discovery)
	tcp_port_discovery $2
;;
tcp_port_count)
	tcp_port_count $2 $3
;;
*)
	echo "Usage:$0 {tcp_port_discovery|tcp_port_count port status}"
;;
esac

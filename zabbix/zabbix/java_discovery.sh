#!/bin/bash
#Fucation:java low-level discovery
#Script_name  java_discovery.sh
# by wangxz@morningtec.cn
# 20180919

source /etc/profile 2>/dev/null

java_discovery() {
	#server=(`sudo ps -ef | grep -v grep | grep -v bin| grep -v sftp |grep server |grep -v awk | awk '{print $NF}' | awk -F "[ /]" '{print $2}' | awk -F "[ _]" '{print $1}'`)
	server=(`jps |grep -v "Jps" |awk '{print $2}'`)
	server_index=$[${#server[@]}-1]
	printf '{\n'
	printf '\t"data":[\n'
	for key in ${!server[@]}
	do
		printf '\t {\n'
		printf "\t\t\t\"{#JAVA_P}\":\"${server[${key}]}\"}\n"
		if [ $key -ne $server_index ];then
			printf ","
		fi
	done
	printf '\n\t]\n'
	printf '}\n'
}

java_vmem_status(){
	ps aux|grep java|grep "$1" |grep -Ev "grep|java_discovery.sh" | awk '{print $5}'
}

java_rmem_status(){
	ps aux|grep java|grep "$1" |grep -Ev "grep|java_discovery.sh" | awk '{print $6}'
}

java_cpu_status(){
	ps aux|grep java|grep "$1" |grep -Ev "grep|java_discovery.sh" | awk '{print $3}'
}

java_mem_status(){
        ps aux|grep java|grep "$1" |grep -Ev "grep|java_discovery.sh" | awk '{print $4}'
}

java_num_status(){
	ps aux|grep java|grep  "$1" |grep -Ev "grep|java_discovery.sh" | wc -l 
}

case "$1" in
java_discovery)
    java_discovery $2
	;;
java_vmem_status)
	java_vmem_status $2
	;;
java_rmem_status)
	java_rmem_status $2
	;;
java_cpu_status)
	java_cpu_status $2
	;;
java_mem_status)
        java_mem_status $2
        ;;
java_num_status)
	java_num_status $2
	;;
*)
    #echo "Bad Parameter."
	echo "Usage: $0 java_discovery|java_vmem_status|java_rmem_status|java_cpu_status|java_num_status"
	exit 1
	;;
esac                      

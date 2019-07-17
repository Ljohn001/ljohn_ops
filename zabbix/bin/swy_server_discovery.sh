#!/bin/bash
#Fucation:mysql low-level discovery
#Script_name server_discovery.sh
server() {
            #server=(`sudo ps -ef | grep -v grep | grep -v bin| grep -v sftp |grep server |grep -v awk | awk '{print $NF}' | awk -F "[ /]" '{print $2}' | awk -F "[ _]" '{print $1}'`)
            server=(`sudo ps -ef | grep -v grep | grep -v bin| grep -v sftp |grep server |grep -v awk | awk '{print $NF}' | awk -F "[ /]" '{print $2}'`)
            server_index=$[${#server[@]}-1]
	    printf '{\n'
            printf '\t"data":[\n'
               for key in ${!server[@]}
                   do
                      printf '\t {\n'
                      printf "\t\t\t\"{#SERVER}\":\"${server[${key}]}\"}\n"
		    if [ $key -ne $server_index ];then
		            printf ","
     		     fi
		    done
		    printf '\n\t]\n'
		    printf '}\n'
}
 
	case "$1" in
	    server)
	        "$1"
        	;;
	    *)
	        echo "Bad Parameter."
        	echo "Usage: $0 server"
        	exit 1
        	;;
	esac                      


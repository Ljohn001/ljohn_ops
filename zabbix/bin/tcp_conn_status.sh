#!/bin/bash
#
#
tcp_status_file='/tmp/tcp_status.txt'
tcp_interval="60"

if [ ! -f ${tcp_status_file} ];then
	/bin/netstat -an|awk '/^tcp/{++S[$NF]}END{for(i in S) print i,S[i]}' > $tcp_status_file
else
	file_time=$(date +%s -d "`stat ${tcp_status_file} |awk '/Modify/ {print $2,$3}'`")
	if [ $((`date +%s` -60)) -ge ${file_time} ];then
		/bin/netstat -an|awk '/^tcp/{++S[$NF]}END{for(i in S) print i,S[i]}' > $tcp_status_file
	fi
fi
#
tcp_status_num(){
	num=`awk "/${1}/ {print \\$2}" $tcp_status_file` 
	if [ "$num" == "" ];then
		echo "0"
	else
		echo $num
	fi
}

case $1 in
    ESTABLISHED)
		tcp_status_num "ESTABLISHED"
        ;;
    SYN_SENT)
		tcp_status_num SYN_SENT
        ;;
    SYN_RECV)
		tcp_status_num SYN_RECV
        ;;
    FIN_WAIT1)
		tcp_status_num FIN_WAIT1
        ;;
    FIN_WAIT2)
		tcp_status_num FIN_WAIT2
        ;;
    TIME_WAIT)
		tcp_status_num TIME_WAIT
		;;
    CLOSE)
		tcp_status_num CLOSE
        ;;
    CLOSE_WAIT)
		tcp_status_num CLOSE_WAIT
        ;;
    LAST_ACK)
		tcp_status_num LAST_ACK
        ;;
    LISTEN)
		tcp_status_num LISTEN
        ;;
    CLOSING)
		tcp_status_num CLOSING
        ;;
    UNKNOWN)
		tcp_status_num UNKNOWN
        ;;
    *)
        echo -e "\e[033mUsage: /bin/bash $0 [ESTABLISHED|SYN_SENT|SYN_RECV|FIN_WAIT1|FIN_WAIT2|TIME_WAIT|CLOSE|CLOSE_WAIT|LAST_ACK|LISTEN|CLOSING|UNKNOWN] \e[0m"
esac

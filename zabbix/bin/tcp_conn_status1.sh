#!/bin/bash
#
#
tcp_status_file='/tmp/tcp_status1.txt'
tcp_interval="60"

if [ ! -f ${tcp_status_file} ];then
	ss -an|awk '{++S[$1]}END{for(i in S) print i,S[i]}' > $tcp_status_file
else
	file_time=$(date +%s -d "`stat ${tcp_status_file} |awk '/Modify/ {print $2,$3}'`")
	if [ $((`date +%s` -60)) -ge ${file_time} ];then
		ss -an|awk '{++S[$1]}END{for(i in S) print i,S[i]}' > $tcp_status_file
	fi
fi
#
tcp_status_num(){
	num=`awk "/$1/{print \\$2}" $tcp_status_file` 
	if [ "$num" == "" ];then
		echo "0"
	else
		echo $num
	fi
}

case $1 in
    ESTAB)
		tcp_status_num ESTAB
        ;;
    SYN-SENT)
		tcp_status_num SYN-SENT
        ;;
    SYN-RECV)
		tcp_status_num SYN-RECV
        ;;
    FIN-WAIT1)
		tcp_status_num FIN-WAIT1
        ;;
    FIN-WAIT2)
		tcp_status_num FIN-WAIT2
        ;;
    TIME-WAIT)
		tcp_status_num TIME-WAIT
		;;
    CLOSE)
		tcp_status_num CLOSE
        ;;
    CLOSE-WAIT)
		tcp_status_num CLOSE-WAIT
        ;;
    LAST-ACK)
		tcp_status_num LAST-ACK
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
        echo -e "\e[033mUsage: /bin/bash $0 [ESTAB|SYN-SENT|SYN-RECV|FIN-WAIT1|FIN-WAIT2|TIME-WAIT|CLOSE|CLOSE-WAIT|LAST-ACK|LISTEN|CLOSING|UNKNOWN] \e[0m"
esac

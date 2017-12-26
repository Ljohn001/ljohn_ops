#!/bin/bash  
#
Date=`date`
ProcNam=zabbix_agent

while true  
do   
   ProcNum=`ps -ef|grep $ProcNam | grep -v grep |wc -l`
   if [ $ProcNum -eq 0 ]; then
       /etc/init.d/zabbix-agent restart  >> /tmp/process_monitor.log & 
      echo "-------$Date-------" >> /tmp/process_monitor.log
      echo "zabbix_agent is restarted!!" >> /tmp/process_monitor.log
   fi
   sleep 10 
done

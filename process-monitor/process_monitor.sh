#!/bin/bash
#
Date=`date`
MAIL=`which mail`
#ProcNam=netExtender
ProcNam=httpd
IP=`ip addr| grep eth0 |grep inet |egrep -v "inet6|127.0.0.1" |awk '{print $2}' |awk -F "/" '{print $1}'`
while true  
do   
   ProcNum=`ps -ef|grep $ProcNam | grep -v grep |wc -l`
#   ping -c 3 -i 0.2 -w 3 10.4.129.42 &> /dev/null
   curl 127.0.0.1 &>/dev/null
   if [ $? -gt 0 -o  $ProcNum  -eq 0 ]; then
#      nohup  /cljj/$ProcNam/start.sh &> /dev/null & 
      nohup  /etc/init.d/httpd start &> /dev/null & 
      if [ $? -eq 0 ];then
         echo "-------$Date-------" >> /tmp/process_monitor.log
         echo "starting $ProcNam..." >> /tmp/process_monitor.log
         echo "$ProcNam is restarted!!" >> /tmp/process_monitor.log
         sleep 10       
#         ping -c 3 -i 0.2 -w 3 10.4.129.42 &> /dev/null
#         if [ $? -eq 0 ];then 
#            echo "$ProcNam status is ok" >> /tmp/process_monitor.log
#         fi

         if curl 127.0.0.1 &>/dev/null;then
            echo "$ProcNam is SUCCESS!"
         fi
      else
         echo "$ProcNam state is failure on $Date,Please check VPN on $IP!!" | $MAIL -s "VPN state Warning"  liujian@erichfund.com
      fi
   fi
   sleep 30
done

#!/bin/bash
#
# chkconfig: 2345 67 34
#
srvName=$(basename $0)

lockFile=/var/lock/subsys/$srvName

start() {
    if [ -f $lockFile ];then
	echo "$srvName is already running."
	return 1
    else
	touch $lockFile
	[ $? -eq 0 ] && echo "Starting $srvName OK."
	return 0
     fi
}

stop() {
    if [ -f $lockFile ];then
	rm -f $lockFile &> /dev/null
	[ $? -eq 0 ] && echo "Stop $srvName OK" && return 0 
    else
	echo "$srvName is not started."
	return 1
    fi
}	

status() {
    if [ -f $lockFile ]; then
	echo "$srvName is running."
    else
	echo "$srvName is stopped."
    fi
    return 0
}

usage() {
     echo "Usage: $srvName {start|stop|restart|status}"
     return 0
}

case $1 in
start)
	start
	;;
stop)
	stop ;;
restart)
	stop
	start ;;
status)
	status ;;
*)
	usage
	exit 1 ;;
esac



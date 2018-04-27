#!/bin/bash
#
SvcName=`basename $0`
LockFile="/var/lock/subsys/$SvcName"

if [ $# -lt 1 ]; then
  echo "Usage: $SvcName {start|stop|restart|status}"
  exit 3
fi

if [ $1 == 'start' ]; then
  if [ -e $LockFile ]; then
    echo "$SvcName is running."
  else
    touch $LockFile &> /dev/null
    echo "Starting $SvcName successfully."
  fi
elif [ $1 == 'stop' ]; then
  if [ -e $LockFile ];then 
    rm -f $LockFile &> /dev/null
    echo "Stopping $SvcName finished."
  else
    echo "$SvcName is stopped yet."
  fi
elif [ $1 == 'restart' ]; then
  rm -f $LockFile &> /dev/null
  touch $LockFile &> /dev/null
  echo "Restarting $SvcName successfully."
elif [ $1 == 'status' ]; then
  if [ -e $LockFile ]; then
    echo "$SvcName is running."
  else
    echo "$SvcName is stopped."
  fi
else
  echo "Usage: $SvcName {start|stop|restart|status}"
  exit 4
fi

#!/bin/bash
#
SvcName=`basename $0`
LockFile=/var/lock/subsys/$SvcName

if [ $# -lt 1 ]; then
  echo "Usage: $SvcName {start|restart|stop|status}"
  exit 5
fi

case $1 in
start)
  touch $LockFile
  echo "Starting $SvcName finished." ;;
stop)
  rm -f $LockFile
  echo "Stopping $SvcName finished." ;;
restart)
  rm -f $LockFile
  touch $LockFile
  echo "Restarting $SvcName finished." ;;
status)
  if [ -e $LockFile ]; then
    echo "$SvcName is running..."
  else
    echo "$SvcName is stopped..."
  fi
  ;;
*)
  echo "Usage: $SvcName {start|restart|stop|status}"
  exit 6
esac
  




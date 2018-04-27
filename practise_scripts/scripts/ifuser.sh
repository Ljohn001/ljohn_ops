#!/bin/bash
#

if [ $# -lt 1 ]; then
  echo "Usage: `basename $0` username"
  exit 2
fi

if id $1 &> /dev/null; then
    userID=`id -u $1`
    echo "$1 id is: $userID."
fi

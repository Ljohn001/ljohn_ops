#!/bin/bash
#

Com=$1

if [ -z $Com ]; then
  Com=gzip
fi

[ -d /backup ] || mkdir /backup

if [ $Com == 'gzip' ]; then
  tar zcf /backup/etc-`date +%F-%H-%M-%S`.tar.gz /etc/*
  [ $? -eq 0 ] && echo "Backup etc finished.(gzip)."
elif [ $Com == 'bzip2' ]; then
  tar jcf /backup/etc-`date +%F-%H-%M-%S`.tar.bz2 /etc/*
  [ $? -eq 0 ] && echo "Backup etc finished.(bzip2)."
elif [ $Com == 'xz' ]; then
  tar Jcf /backup/etc-`date +%F-%H-%M-%S`.tar.xz /etc/*
  [ $? -eq 0 ] && echo "Backup etc finished.(xz)."
else
  echo "Usage: `basename $0` {[gzip|bzip2|xz]}"
  exit 6
fi


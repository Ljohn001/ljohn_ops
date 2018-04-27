#!/bin/bash
for File in /etc/fstab /etc/inittab /etc/rc.d/init.d/functions; do
  FileName=`basename $File`
  cp $File /tmp/$FileName-`date +%F`
done

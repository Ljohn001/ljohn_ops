#!/bin/bash
#
#===============================
# Description: Check hosts from filelist
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.9.22
# Version: 1.1
#===============================

start=$(date +%s)
uphosts=0
downhosts=0
while read line
do
    ping -c 3 -i 0.2 -w 3 $line  &> /dev/null
    if [ $? -eq 0 ]
    then
        echo "Host $line is UP!"
        let uphosts++
    else
        echo "Host $line is down!"
        let downhosts++
    fi
done < ipadds.txt
stop=$(date +%s)
echo "Up hosts:$uphosts."
echo "Down hosts:$downhosts."
echo "IP addresses ($uphosts hosts up) scanned in $[ stop - start ] seconds"

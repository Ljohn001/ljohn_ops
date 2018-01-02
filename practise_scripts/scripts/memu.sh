#!/bin/bash
#
echo "---------menu----------"
echo "cpu) show cpu infomation"
echo "mem) show memory infomation"
echo "*) quit"
echo "-------menu------------"

read -p "Plz give your choice: " choice

if [ "$choice" == 'cpu' ]; then
    cat /proc/cpuinfo
elif [ "$choice" == 'mem' ]; then
    cat /proc/meminfo
else
    echo "Quit"
    exit 3
fi

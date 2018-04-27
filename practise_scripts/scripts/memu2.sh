#!/bin/bash
#
cat << EOF
-------menu------------
cpu) show cpu infomation
mem) show memory infomation
*) quit
-------menu------------
EOF

read -p "Plz give your choice: " choice

if [ "$choice" == 'cpu' ]; then
    cat /proc/cpuinfo
elif [ "$choice" == 'mem' ]; then
    cat /proc/meminfo
else
    echo "Quit"
    exit 3
fi

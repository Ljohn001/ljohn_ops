#!/bin/bash
#
cat << EOF
cpu) show cpu information;
mem) show memory information;
disk) show disk information;
quit) quit
============================
EOF

read -p "Enter a option: " option
while [ "$option" != 'cpu' -a "$option" != 'mem' -a "$option" != 'disk' -a "$option" != 'quit' ]; do
	read -p "Wrong option, Enter again: " option
done

if [ "$option" == 'cpu' ]; then
	lscpu
elif [ "$option" == 'mem' ]; then
	cat /proc/meminfo
elif [ "$option" == 'disk' ]; then
	fdisk -l
else
	echo "Quit"
	exit 0
fi


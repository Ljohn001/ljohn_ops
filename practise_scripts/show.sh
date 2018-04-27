#!/bin/bash
#
cat << EOF
	cpu) print cpu information;
	mem) print memory information;
	disk) print disk infomation;
	quit) quit
EOF

read -p "Enter your option: " option
option=`echo $option | tr 'A-Z' 'a-z'`

while [[ "$option" != "quit" ]]; do
	if [[ "$option" == "cpu" ]]; then
		cat /proc/cpuinfo
	elif [[ "$option" == "mem" ]]; then
		free -m
	elif [[ "$option" == "disk" ]]; then
		df -h
	else 
		echo "Wrong option..."
	fi

	read -p "Enter your option: " option
	option=`echo $option | tr 'A-Z' 'a-z'`
done

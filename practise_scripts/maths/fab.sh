#!/bin/bash
#
# 求n阶斐波那契数列
#
fab() {
	if [ $1 -eq 1 ]; then
	echo 1
	elif [ $1 -eq 2 ]; then
	echo 1
	else
	echo $[$(fab $[$1-1])+$(fab $[$1-2])]
	fi
}

fab 7	


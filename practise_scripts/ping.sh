#!/bin/bash
#
quitScript() {
    echo "Quit..."
}    

trap 'quitScript; exit 5' SIGINT

cnetPing() {
    for i in {1..5}; do
	if ping -c 1 -W 1 $1.$i &> /dev/null; then
	     echo "$1.$i is up."
 	else
	     echo "$1.$i is down."
	fi
     done
}

bnetPing() {
    for j in {0..5}; do
	cnetPing $1.$j 
    done
}

anetPing() {
    for m in {0..5}; do
	bnetPing $1.$m
    done
}

netType=`echo $1 | cut -d"." -f1`

if [ $netType -ge 1 -a $netType -le 126 ]; then
    anetPing $netType
elif [ $netType -ge 128 -a $netType -le 191 ]; then
    bnetPing $(echo $1 | cut -d'.' -f1,2)
elif [ $netType -ge 192 -a $netType -le 223 ]; then
    cnetPing $(echo $1 | cut -d'.' -f1-3)
else
    echo "Wrong"
    exit 2
fi

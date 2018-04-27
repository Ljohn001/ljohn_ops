#!/bin/bash
#
verbose=0
allInterface=0
ifflag=0
interface=0

while [ $# -ge 1 ]; do
    case $1 in
    -a)
	allInterface=1
        shift 1
	;;
     -i)
	ifflag=1
	interface="$2"
 	shift 2
	;;
     -v)
	verbose=1
	shift
	;;
     *)
	echo "wrong option"
	exit 2
	;;
     esac
done

if [ $allInterface -eq 1 ]; then
    if [ $verbose -eq 1 ]; then
	ifconfig | grep "inet addr:"
    else
	ifconfig | grep "inet addr:" | awk '{print $2}' 
    fi
fi

if [ $ifflag -eq 1 ]; then
    if [ $verbose -eq 1 ]; then
	ifconfig $interface | grep "inet addr:"
    else
	ifconfig $interface | grep "inet addr:" | awk '{print $2}' 
    fi
fi

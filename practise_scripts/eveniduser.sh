#!/bin/bash
#
while read line; do
	userID=`echo $line | cut -d: -f3`
	if [ $[$userID%2] -eq 0 ]; then
		echo -n "$userID: "
		echo $line | cut -d: -f1
	fi
done < /etc/passwd

#!/bin/bash
#
while read line; do
	charCounts=`echo $line | wc -c`
	if [ $charCounts -gt 30 ] && [[ "$line" =~ ^[^#] ]]; then
		echo -n "$charCounts: "
		echo $line
	fi
done < /etc/rc.d/rc.sysinit


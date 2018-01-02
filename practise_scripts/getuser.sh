#!/bin/bash
#
while read line; do
	[[ `echo $line | cut -d: -f7` == "/bin/bash" ]] && echo $line | cut -d: -f1
done < /etc/passwd

#!/bin/bash
#
while true; do
 	read -p "Enter a directory: " dirName
	[ "$dirName" == 'quit' ] && exit 3
 	[ -d "$dirName" ] && break || echo "Wrong directory..."
done

# echo "Correct..."

for fileName in $dirName/*; do
	if [[ "$fileName" =~ .*[[:upper:]]{1,}.* ]]; then
		echo "$fileName"
	fi
done

#!/bin/bash
#

read -p "Enter a user name: " userName

while [[ "$userName" != "quit" ]]; do
	if [ -z "$userName" ]; then
		echo "Username null." 
	elif id $userName &> /dev/null; then
		grep "^$userName\>" /etc/passwd | cut -d: -f3,7
	else
		echo "No such user."
	fi
	read -p "Enter a user name again(quit to exit): " userName
done

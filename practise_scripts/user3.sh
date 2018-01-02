#!/bin/bash
#
read -p "Enter a user name: " userName

until [ -n "$userName" ] && id $userName &> /dev/null; do
    read -p "Enter a user name again: " userName
done

until who | grep "^$userName" &> /dev/null; do
	echo "$userName is not here."
	sleep 5
done

echo "$userName is on."

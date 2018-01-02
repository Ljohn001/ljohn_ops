#!/bin/bash
#
read -p "Enter a user name: " userName

while ! id $userName &> /dev/null; do
    read -p "Enter a user name again: " userName
done

while ! who | grep "^$userName" &> /dev/null; do
	echo "$userName is not here."
	sleep 5
done

echo "$userName is on."

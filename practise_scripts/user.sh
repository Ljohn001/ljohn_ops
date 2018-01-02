#!/bin/bash
#
read -p "Enter a user name: " userName

while ! id $userName &> /dev/null; do
    read -p "Enter a user name again: " userName
done

who | grep "^$userName" &> /dev/null
retVal=$?

while [ $retVal -ne 0 ]; do
	sleep 5
	who | grep "^$userName" &> /dev/null
	retVal=$?	
done

echo "$userName is on."

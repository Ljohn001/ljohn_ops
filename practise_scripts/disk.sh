#!/bin/bash
#
while true; do
	read -p "Enter a block device file: " diskFile
	if [ "$diskFile" == 'quit' ]; then
		exit 7
	fi

	if [ -b "$diskFile" ]; then
		break
	else
		echo "Wrong device file..."
	fi
done

echo "Device is: $diskFile."

while true; do
	read -p "Y or y for continue, N or n for quiting: " option
	option=`echo $option | tr 'A-Z' 'a-z'`
	if [ "$option" == 'n' ]; then
		exit 8
	fi

	if [ "$option" == 'y' ]; then
		break
	else
		echo "Wrong input..."
	fi
done

dd if=/dev/zero of=$diskFile bs=512 count=1

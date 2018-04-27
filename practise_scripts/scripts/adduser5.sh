#!/bin/bash
#
declare -i count=0

for i in {501..510}; do
    if id tuser$i &> /dev/null; then
	echo "tuser$i exists."
    else
        useradd tuser$i
	let count++
    fi 
done

echo "Total add $count users."

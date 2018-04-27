#!/bin/bash
#
declare -i count=0

for i in {501..510}; do
    if id tuser$i &> /dev/null; then
	echo -e "\033[31mtuser$i\033[0m exists."
    else
        useradd tuser$i
        echo -e "add user \033[32mtuser$i\033[0m successfully."
	let count++
    fi 
done

echo "Total add $count users."

#!/bin/bash
#
totalUsers=`wc -l /etc/passwd | cut -d' ' -f1`

for i in `seq 2 2 $totalUsers`; do
    userName=`head -n $i /etc/passwd | tail -1 | cut -d: -f1` 
    echo $userName >> /tmp/passwd.tmp
    echo $userName
done

users=`wc -l /tmp/passwd.tmp | cut -d' ' -f1`
echo "Total users: $users."

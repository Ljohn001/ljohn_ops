#!/bin/bash
#
declare -i idsum=0

for i in {401..410}; do
    useradd tuser$i
    userID=`id -u tuser$i`
    let idsum+=$userID
done

echo "ID sum: $idsum."    

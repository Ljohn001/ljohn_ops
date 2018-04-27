#!/bin/bash
#
declare -i idsum=0

for i in `cut -d: -f3 /etc/passwd`; do
    let idsum+=$i
done

echo $idsum

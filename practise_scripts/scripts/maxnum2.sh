#!/bin/bash
#
declare -i max=0

for i in $*; do
    if [ $max -lt $i ]; then
        max=$i
    fi
done

echo "The max number is $max."

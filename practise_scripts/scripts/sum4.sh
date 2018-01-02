#!/bin/bash
#
declare -i count=1
declare -i sum=0

while [ $count -le 10 ]; do
    let sum+=$count
    let count++
done

echo $sum

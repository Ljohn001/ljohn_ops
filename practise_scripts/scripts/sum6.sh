#!/bin/bash
#
declare -i counter=1
declare -i sum=0

while [ $counter -le 100 ]; do
    [ $[$counter%2] -eq 0 ] && let sum+=$counter
    let counter++
done

echo $sum

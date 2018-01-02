#!/bin/bash
#
declare -i sum=0

for ((counter=1; $counter <= 100; counter++)); do
    let sum+=$counter
done

echo $sum

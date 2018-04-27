#!/bin/bash
#
declare -i count=1
declare -i sum=0

until [ $count -gt 100 ]; do
    let sum+=$count
    let count++
done

echo $sum

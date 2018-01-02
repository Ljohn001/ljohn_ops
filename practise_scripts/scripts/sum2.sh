#!/bin/bash
#
declare -i sum=0

for i in {1..100}; do
  sum=$[$sum+$i]
done

echo $sum


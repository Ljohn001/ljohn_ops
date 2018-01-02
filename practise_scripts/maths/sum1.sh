#!/bin/bash
#
# 求100以内所正整数之和

declare -i sum=0
for ((i=1;i<=100;i++)); do
	let sum+=$i
done
echo "Sum: $sum."

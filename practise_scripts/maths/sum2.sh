#!/bin/bash
#
# 求100以内所有偶数之和；要求循环遍历100以内的所正整数

declare -i i=0
declare -i sum=0

until [ $i -gt 100 ]; do
	let i++
	if [ $[$i%2] -eq 1 ]; then
		continue
	fi
	let sum+=$i
done

echo "Even sum: $sum"


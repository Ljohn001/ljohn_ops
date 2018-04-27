#!/bin/bash
#
# 求100以内所正整数之和

declare -i i=1
declare -i sum=0

until [ $i -gt 100 ]; do
	let sum+=$i
	let i++
done

echo "Sum: $sum"	


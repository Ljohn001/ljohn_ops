#!/bin/bash
#
# 打印九九乘法表，通过until 实现
declare -i j=1
declare -i i=1

until [ $j -gt 9 ]; do
	until [ $i -gt $j ]; do
		echo -n -e "${i}X${j}=$[$i*$j]\t"
		let i++
	done
	echo
	let i=1
	let j++
done


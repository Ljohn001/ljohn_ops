#!/bin/bash
#
#N!=N(n-1)(n-2)...1 
#n(n-1)! = n(n-1)(n-2)!
# 求N! 阶乘
fact() {
	if [ $1 -eq 0 -o $1 -eq 1 ]; then
		echo 1
	else
		echo $[$1*$(fact $[$1-1])]
	fi
}

fact 9


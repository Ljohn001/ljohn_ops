#!/bin/bash
#
# 打印九九乘法表

for((j=1;j<=9;j++));do
    for((i=1;i<=j;i++))do
        echo -e -n "${i}X${j}=$[$i*$j]\t"
    done
        echo
done


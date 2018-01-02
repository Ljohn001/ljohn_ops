#!/bin/bash
declare -a mylogs
logs=(/var/log/*.log)

echo ${logs[@]}

for i in `seq 0 ${#logs[@]}`; do
    if [ $[$i%2] -eq 0 ];then
       index=${#mylogs[@]}
       mylogs[$index]=${logs[$i]}
    fi
done 

echo ${mylogs[@]}

#!/bin/bash
#

if [ $# -eq 0 ];then
    dir=/usr/local
elif [ $# -eq 1 ];then
    dir=$1
    if [ ! -d $dir ];then
    mkdir -p $dir
    fi
else
    echo "The parameter is invalid,Please input again and rerun it！"
    exit 1
fi

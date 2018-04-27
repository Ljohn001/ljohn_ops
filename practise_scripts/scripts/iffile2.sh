#!/bin/bash
#
if [ ! -e $1 ]; then 
    echo "file not exist."
    exit 8
fi

if [ -L $1 ]; then
    echo "Symbolic file"
elif [ -d $1 ]; then
    echo "Directory"
elif [ -f $1 ]; then
    echo "regular file."
else
    echo "unknown."
fi

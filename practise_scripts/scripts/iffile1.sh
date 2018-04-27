#!/bin/bash
#
if [ -e $1 ]; then
    wc -l $1
else
    echo "no such file."
fi

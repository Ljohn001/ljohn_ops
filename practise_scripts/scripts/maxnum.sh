#!/bin/bash
#
if [ $# -lt 2 ]; then
    echo "Usage: `basename $0` number1 number2"
    exit 5
fi

if [ $1 -ge $2 ]; then
    echo "The max num is $1."
else
    echo "The max num is $2."
fi

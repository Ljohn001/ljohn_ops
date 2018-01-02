#!/bin/bash
#

addTwo() {
    if [ $# -lt 2 ]; then
	return 1
    fi

    echo "$[$1+$2]"
    return 0
}

addTwo 4 5
[ $? -eq 1 ] && echo "At least two integer."

addTwo 4 57
[ $? -eq 1 ] && echo "At least two integer."

addTwo 3
[ $? -eq 1 ] && echo "At least two integer."

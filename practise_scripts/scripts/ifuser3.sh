#!/bin/bash
#
if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` username"
    exit 1
fi

if ! id -u $1 &> /dev/null; then
    echo "Usage: `basename $0` username"
    echo "No this user $1."
    exit 2
fi

if [ $(id -u $1) -eq 0 ]; then
    echo "Admin"
elif [ $(id -u $1) -ge 500 ]; then
    echo "Common user."
else
    echo "System user."
fi

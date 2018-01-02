#!/bin/bash
#
answer='quit'

if ! [ "$answer" == 'quit' -o "$answer" == 'q' ]; then
    echo "Continue."
fi

if [ "$answer" != 'quit' -a "$answer" != 'q' ]; then
    echo "Continue."
fi

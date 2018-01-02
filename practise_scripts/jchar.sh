#!/bin/bash
#

read -p "Plz enter a char: " char

case $char in
[0-9])
    echo "a digit"
    ;;
[a-z])
    echo "a char"
    ;;
*)
    echo "a special word"
    ;;
esac

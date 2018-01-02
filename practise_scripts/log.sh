#!/bin/bash
#
read -p "Plz enter a username: " userName

while true; do
    if who | grep "\<$userName\>" &> /dev/null; then
        break
    fi
    echo "not here."
    sleep 5
done

echo "$userName is logged on."

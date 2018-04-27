#!/bin/bash
#
read -p "Plz input a username: " userName

if id $userName &> /dev/null; then
    echo "The shell of $userName is `grep "^$userName\>" /etc/passwd | cut -d: -f7`."
else
    echo "No such user. stupid."
fi

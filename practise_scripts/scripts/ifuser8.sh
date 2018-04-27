#!/bin/bash
#
read -p "Plz input a username: " userName
userInfo=`grep "^$userName\>" /etc/passwd`

if [[ "$userInfo" =~ /bin/.*sh$ ]]; then
    echo "can login"
else
    echo "cannot login"
fi

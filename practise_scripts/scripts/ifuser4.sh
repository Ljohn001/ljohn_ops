#!/bin/bash
#
if ! id $1 &> /dev/null; then
    echo "No this user."
    exit 3
fi

userShell=$(grep "^$1\>" /etc/passwd | cut -d: -f7)
userID=$(id -u $1)

if [ "$userShell" == '/bin/bash' -a $userID -ge 500 ]; then
    echo "Login user."
else
    echo "not login user."
fi

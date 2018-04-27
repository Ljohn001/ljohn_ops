#!/bin/bash
#
userShell=`grep "^$1\>" /etc/passwd | cut -d: -f7`

if [ "$userShell" == '/bin/bash' ]; then
    echo "basher"
else
    echo "not basher"
fi

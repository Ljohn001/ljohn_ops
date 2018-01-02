#!/bin/bash
#

Shell=`grep "^$1:" /etc/passwd | cut -d: -f7`

if [ -z $Shell ]; then
  echo "No shell." 
  exit 3
fi

if [[ "$Shell" =~ sh$ ]]; then
  echo "Login User."
  Ret=0
else
  echo "None Login User." 
  Ret=4
fi

exit $Ret

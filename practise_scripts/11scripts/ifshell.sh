#!/bin/bash
#

Shell=`grep "^$1:" /etc/passwd | cut -d: -f7`

if [ -z $Shell ]; then
  echo "No such user or User's shell is null."
  exit 10
fi

if [ "$Shell" == "/bin/bash" ]; then
  echo "Bash User."
  Ret=0
else
  echo "Not Bash User."
  Ret=9
fi

exit $Ret

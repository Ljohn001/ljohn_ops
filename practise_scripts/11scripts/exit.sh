#!/bin/bash
#

if id $1 &> /dev/null; then
  echo "Exists."
  Ret=0
else
  echo "Not exist."
  Ret=8
fi

echo "how are you?"
exit $Ret


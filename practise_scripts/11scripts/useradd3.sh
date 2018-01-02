#!/bin/bash
#
Count=0

for I in {1..10}; do
  if id user$I &> /dev/null; then
    echo "user$I exists."
  else
    useradd user$I
    echo "Add user$I successfully."
    Count=$[$Count+1]
  fi
done

echo "Add $Count new users."
echo "Total users: `wc -l /etc/passwd | cut -d' ' -f1`."


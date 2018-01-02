#!/bin/bash
#

UserName=user1

if id $UserName &> /dev/null; then
  echo "$UserName exists."
  grep "^$UserName:" /etc/passwd | cut -d: -f3,7
else
  useradd $UserName
  grep "^$UserName:" /etc/passwd | cut -d: -f3
fi


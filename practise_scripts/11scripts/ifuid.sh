#!/bin/bash
#
UserName=user1
if id $UserName &> /dev/null; then
  grep "^$UserName\>" /etc/passwd | cut -d: -f3,7
fi

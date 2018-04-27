#!/bin/bash
#
UserName=user1

if grep "^$UserName\>" /etc/passwd &> /dev/null; then
  echo "$UserName exists."
fi

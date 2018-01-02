#!/bin/bash
#

UserName=$1

if id $UserName &> /dev/null; then
  echo "$UserName Exists."
else
  echo "$UserName Not Exists."
fi

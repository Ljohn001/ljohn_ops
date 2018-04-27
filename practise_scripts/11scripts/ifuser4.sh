#!/bin/bash
#
UserName=daemon2

if id $UserName &> /dev/null; then 
  
  Uid=`id -u $UserName`

  if [ $Uid -gt 499 ]; then
    echo "A common user: $UserName."
  else
    echo "admin user or system user: $UserName."
  fi
else
  echo "$UserName is not exist."
fi

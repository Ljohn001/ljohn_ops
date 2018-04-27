#!/bin/bash

for Line in 1 3 6 12; do
  UserName=`head -$Line /etc/passwd | tail -1 | cut -d: -f1`
  Uid=`head -$Line /etc/passwd | tail -1 | cut -d: -f3` 
  GroupName=`id -gn $UserName`
  echo "$UserName, $Uid, $GroupName"
done 

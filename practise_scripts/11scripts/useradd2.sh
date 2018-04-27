#!/bin/bash
# Version: 0.0.2
#
for UserName in user1 user2 user3; do
  useradd $UserName
  echo $UserName | passwd --stdin $UserName
done

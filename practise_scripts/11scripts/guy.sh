#!/bin/bash
#
UserName=user1

if [ `id -u $UserName` -eq `id -g $UserName` ]; then
  echo "Good Guy."
else
  echo "Bad Guy."
fi

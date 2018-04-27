#!/bin/bash
#
if [ ! -e $1 ]; then
  echo "No such file."
  exit 7
fi

if [ -f $1 ]; then
  echo "Common file."
elif [ -d $1 ]; then
  echo "Directory."
else
  echo "Unknown file."
fi

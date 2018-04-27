#!/bin/bash
#
A=$RANDOM

if [ $[$A%2] -eq 0 ]; then
  echo "$A: Even"
else
  echo "$A: Odd"
fi

#!/bin/bash
#
A=$RANDOM
B=$RANDOM

if [ $A -ge $B ]; then
  echo "Max number is $A."
else
  echo "Max number is $B."
fi

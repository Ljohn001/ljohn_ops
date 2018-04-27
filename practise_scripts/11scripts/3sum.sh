#!/bin/bash
#
Sum=0

for I in {1..200}; do
  if [ $[$I%3] -eq 0 ]; then
    Sum=$[$Sum+$I]
  fi
done

echo "Sum: $Sum."

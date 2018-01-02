#!/bin/bash
#
Sum=0

for I in {1..100}; do
  Sum=$[$Sum+$I]
done

echo "The sum is: $Sum."

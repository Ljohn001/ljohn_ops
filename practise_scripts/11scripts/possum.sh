#!/bin/bash
#
Sum=0
for I in `seq 1 $#`; do
  Sum=$[$Sum+$1]
  shift
done

echo $Sum

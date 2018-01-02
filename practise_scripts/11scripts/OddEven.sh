#!/bin/bash
#
EvenSum=0
OddSum=0

for I in `seq 1 $1`;do
  if [ $[$I%2] -eq 1 ]; then
    OddSum=$[$OddSum+$I]
  else
    EvenSum=$[$EvenSum+$I]
  fi
done

echo "EvenSum: $EvenSum."
echo "OddSUm: $OddSum."

echo "Sum: $[$EvenSum+$OddSum]"



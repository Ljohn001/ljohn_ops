#!/bin/bash

EvenSum=0
OddSum=0

for I in `seq 1 2 100`; do
  OddSum=$[$OddSum+$I]
done

for I in `seq 2 2 100`; do
  EvenSum=$[$EvenSum+$I]
done

echo "Even Sum: $EvenSum; Odd Sum: $OddSum."

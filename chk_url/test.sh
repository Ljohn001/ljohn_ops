#!/bin/bash
#
array_name=(
value0
value1
value2
value3
)
for i in ${array_name[*]}
do
  echo $i
done

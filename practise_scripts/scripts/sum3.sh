#!/bin/bash
#
declare -i evensum=0
declare -i oddsum=0

for i in `seq 1 2 100`; do
  oddsum=$[$oddsum+$i]
done

for j in `seq 2 2 100`; do
  evensum=$[$evensum+$j]
done

echo "evensum: $evensum, oddsum: $oddsum."

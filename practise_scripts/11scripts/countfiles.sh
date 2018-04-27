#!/bin/bash
#
Count=0

for File in /var/*; do
  file $File
  Count=$[$Count+1]
done

echo "Total files: $Count."  

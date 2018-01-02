#!/bin/bash
IDSum=0

for I in `cut -d: -f3 /etc/passwd`; do
  IDSum=$[$IDSum+$I]
done

echo "ID sum is: $IDSum." 

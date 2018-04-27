#!/bin/bash
#
Vendor=`grep "vendor_id" /proc/cpuinfo  | uniq | cut -d: -f2`

if [[ "$Vendor" =~ [[:space:]]*GenuineIntel$ ]]; then
  echo "Intel"
else
  echo "AMD"
fi

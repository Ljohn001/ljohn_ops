#!/bin/bash

for File in /etc/fstab /etc/rc.d/rc.sysinit /etc/inittab; do
  echo "$File:"
  echo -e "\t#lines: `grep "^#" $File | wc -l`"
  echo -e "\tspace lines: `grep "^$" $File | wc -l`"
done

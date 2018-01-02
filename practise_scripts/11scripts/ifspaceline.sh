#!/bin/bash
#
File='/etc/rc.d/rc.sysinit'

if grep "^$" $File &> /dev/null; then
  grep "^$" $File | wc -l
fi

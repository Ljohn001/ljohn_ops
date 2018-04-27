#!/bin/bash
#
Device='/dev/sda3'

if mount | grep "^$Device" &> /dev/null; then
  mount | grep "/dev/sda3" | cut -d' ' -f3
fi

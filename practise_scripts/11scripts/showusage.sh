#!/bin/bash
#
ShowItem=`dialog --stdout --title "Show Usages" --menu "Choose the Usage you want: " 12 35 6 1 "Show disk usages" 2 "Show physical memory usage" 3 "show swap usage" 4 "quit"`

case $ShowItem in 
"1")
  df -lh
  ;;
"2")
  free -m ;;
"3")
  free -m ;;
"4")
  exit ;;
esac

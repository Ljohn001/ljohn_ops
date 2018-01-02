#!/bin/bash
#
#declare -i lines1=0
#declare -i lines2=0

for file in /etc/rc.d/rc.sysinit /etc/rc.d/init.d/functions /etc/inittab; do
    echo "The lines contain #  in $file is `grep -E "^#" $file | wc -l`." 
    echo "The space lines in $file is `grep -E "^[[:space:]]*$" $file | wc -l`." 
done

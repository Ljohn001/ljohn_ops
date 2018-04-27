#!/bin/bash
#
#moniter available disk space

SPACE=`df | sed -n '/\/$/p'| awk '{print $4}'|sed 's/%//'`

if [ $SPACE -ge 8 ]
then
    echo "Disk space on root at $SPACE% used" | mail -s "Disk warning" liujian@erichfund.com
fi

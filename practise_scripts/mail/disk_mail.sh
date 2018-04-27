#!/bin/bash
#
#sending the current disk statistics in e-mail message

date=`date +%m/%d/%Y`
MAIL=`which mail`
TEMP=`mktemp tmp.XXXXXX`

df -h > $TEMP
cat $TEMP | $MAIL -s "Disk stats for $date" $1 liujian@erichfund.com
rm -f $TEMP


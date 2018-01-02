#!/bin/bash
#
while read line; do
        userID=`echo $line | cut -d: -f3`
        groupID=`echo $line | cut -d: -f4`
        if [ $[$userID%2] -eq 0 ] && [ $[$groupID%2] -eq 0 ]; then
                echo -n "$userID, $groupID: "
                echo $line | cut -d: -f1
        fi
done < /etc/passwd

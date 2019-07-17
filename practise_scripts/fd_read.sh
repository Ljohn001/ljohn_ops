#!/bin/bash
  
function fd_read (){
exec 3<&0
#exec 0< $FILENAME
while read LINE
do
echo $LINE
done
exec 0<&3
}
fd_read


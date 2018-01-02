#!/bin/bash
LINES=`wc -l /etc/passwd | cut -d' ' -f1`

for I in `seq 1 $LINES`; do
  head -$I /etc/passwd | tail -1 | cut -d: -f1,7
done

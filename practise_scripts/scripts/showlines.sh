#!/bin/bash
#
for file in $*; do
    lines=`wc -l $file | cut -d' ' -f1`
    echo "$file has $lines lines."
done

echo "$# files."

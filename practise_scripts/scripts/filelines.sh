#!/bin/bash
#
declare -i totalLines=0
declare -i noFiles=0

for file in $*; do
    curFileLines=`wc -l $file | cut -d' ' -f1`
    echo "$file has $curFileLines."
    let noFiles++
    let totalLines+=$curFileLines
done

echo "Total Files: $noFiles."
echo "Total Lines: $totalLines."

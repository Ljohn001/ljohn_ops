#!/bin/bash
#

dstDir=/tmp/dir-$(date +%Y%m%d-%H%M%S)

mkdir $dstDir

for i in {1..10}; do
    touch $dstDir/file$i
done

#!/bin/bash
#
dstDir=/tmp/dir-$(date +%Y%m%d-%H%M%S)
mkdir $dstDir

for i in {1..9}; do
    useradd tuser$i
    touch $dstDir/file10$i
    chown tuser$i $dstDir/file10$i
done

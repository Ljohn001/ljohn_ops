#!/bin/bash
# description: testing
# version: 0.0.1 
# author: mageedu
# date: 2014-07-07
dstDir='/tmp/hellobash'

groupadd -g 8008 newgroup
useradd -u 3306 -G 8008 mageedu
mkdir $dstDir
cp /etc/rc.d/init.d/functions $dstDir

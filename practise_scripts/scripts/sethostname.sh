#!/bin/bash
#
hostName=`hostname`

if [ -z "$hostName" -o "$hostName" == 'localhost' ]; then
    hostname www.magedu.com
fi

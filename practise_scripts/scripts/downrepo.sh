#!/bin/bash
#
downURL='http://172.16.0.1/centos6.5.repo'
downloader=`which wget`

if [ -x $downloader ]; then
    $downloader $downURL
fi

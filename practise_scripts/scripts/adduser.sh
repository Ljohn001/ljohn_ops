#!/bin/bash
#
useradd $1 
echo $1 | passwd --stdin $1 &> /dev/null

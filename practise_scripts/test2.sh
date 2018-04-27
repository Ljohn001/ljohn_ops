#!/bin/bash
[ -f /etc/sysconfig/test ] && source /etc/sysconfig/test

myvar=${myvar:-www.magedu.com}

echo $myvar

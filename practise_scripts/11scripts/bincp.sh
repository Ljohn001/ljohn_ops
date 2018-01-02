#!/bin/bash
#
declare -i DebugLevel=0

Target=/mnt/sysroot
[ -d $Target ] || mkdir $Target &> /dev/null

read -p "A command: " Command

while [ $Command != 'q' -a $Command != 'Q' ]; do
Command=`which $Command | grep -v "^alias" | grep -o "[^[:space:]]*"`
[ $DebugLevel -eq 1 ] && echo $Command

ComDir=${Command%/*}
[ $DebugLevel -eq 1 ] && echo $ComDir

[ -d ${Target}${ComDir} ] || mkdir -p ${Target}${ComDir}
[ ! -f ${Target}${Command} ] && cp $Command ${Target}${Command} && echo "Copy $Command to $Target finished."

for Lib in `ldd $Command | grep -o "[^[:space:]]*/lib[^[:space:]]*"`; do
  LibDir=${Lib%/*}
  [ $DebugLevel -eq 1 ] && echo $LibDir
  
  [ -d ${Target}${LibDir} ] || mkdir -p ${Target}${LibDir}
  [ ! -f ${Target}${Lib} ] && cp $Lib ${Target}${Lib} && echo "Copy $Lib to $Target finished."
done
read -p "A command: " Command
done


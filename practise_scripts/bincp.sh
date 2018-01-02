#!/bin/bash
#
target=/mnt/sysroot/

[ -d $target ] || mkdir $target

preCommand() {
    if which $1 &> /dev/null; then
	commandPath=`which --skip-alias $1`
	return 0
    else
	echo "No such command."
	return 1
    fi
}

commandCopy() {
    commandDir=`dirname $1`
    [ -d ${target}${commandDir} ] || mkdir -p ${target}${commandDir}
    [ -f ${target}${commandPath} ] || cp $1 ${target}${commandDir}
}

libCopy() {
    for lib in `ldd $1 | egrep -o "/[^[:space:]]+"`; do
	libDir=`dirname $lib`
	[ -d ${target}${libDir} ] || mkdir -p ${target}${libDir}
	[ -f ${target}${lib} ] || cp $lib ${target}${libDir}
    done
} 

read -p "Plz enter a command: " command

until [ "$command" == 'quit' ]; do

  if preCommand $command ; then
    commandCopy $commandPath
    libCopy $commandPath
  fi

  read -p "Plz enter a command: " command
done

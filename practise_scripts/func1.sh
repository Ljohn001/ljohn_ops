#!/bin/bash
#
dirName=/tmp/test1

function createDir {
  if [ -d $dirName ]; then
    echo "$dirName exists."
    ls /etcccc &> /dev/null
  else
    mkdir $dirName
    echo "Create $dirName."
  fi 
  return 0
}

function main {
  createDir
  echo $?
  createDir
  createDir
  createDir
  createDir
}

main

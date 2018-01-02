#!/bin/bash

for DirName in /tmp/1.dir /tmp/2.dir /tmp/3.dir; do
  mkdir $DirName
  chmod 750 $DirName
done

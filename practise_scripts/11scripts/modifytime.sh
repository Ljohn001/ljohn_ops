#!/bin/bash

for Dir in /tmp/1.dir /tmp/2.dir /tmp/3.dir; do
  stat $Dir
  touch -m -t 201003030303.03 $Dir
  stat $Dir
done

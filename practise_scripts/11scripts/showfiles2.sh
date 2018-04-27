#!/bin/bash

for File in `ls /var`; do
  file /var/$File
done

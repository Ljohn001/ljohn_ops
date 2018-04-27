#!/bin/bash

for File in /proc/cpuinfo /proc/meminfo /proc/uptime; do
  tr 'a-z' 'A-Z' < $File
done

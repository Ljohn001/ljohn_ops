#!/bin/bash
#
trap 'echo "quit"; exit 1' SIGINT

for i in {1..254}; do
    ping  -c 1 -W 1 172.16.100.$i
done

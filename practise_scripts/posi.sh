#!/bin/bash
echo $#

for i in "$@"; do
    echo $i
done

for i in "$*"; do
    echo $i
done

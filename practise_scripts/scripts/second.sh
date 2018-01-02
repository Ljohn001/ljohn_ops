#!/bin/bash
#
lines=$(wc -l $1 | cut -d' ' -f1)
echo "$1 has $lines lines."

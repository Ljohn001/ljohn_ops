#!/bin/bash
#
for i in {0..9}; do
    num[$i]=$RANDOM
done

for j in ${num[@]}; do
    echo "hello: $j"
done

for j in "${num[@]}"; do
    echo "hello: $j"
done

for j in ${num[*]}; do
    echo "hello: $j"
done

for j in "${num[*]}"; do
    echo "hello: $j"
done

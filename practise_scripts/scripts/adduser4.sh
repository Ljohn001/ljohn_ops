#!/bin/bash
#
if ! id $1 &> /dev/null; then
    useradd $1
fi

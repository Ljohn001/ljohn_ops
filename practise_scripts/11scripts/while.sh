#!/bin/bash
#
read -p "A string: " String

while [ "$String" != 'quit' ]; do
  echo $String | tr 'a-z' 'A-Z'
  read -p "Next [quit for quiting]: " String
done

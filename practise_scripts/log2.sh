#!/bin/bash
#
read -p "Plz enter a username: " userName

until who | grep "\<$userName\>" &> /dev/null; do
  sleep 5
  echo "not here"
done

echo "here"

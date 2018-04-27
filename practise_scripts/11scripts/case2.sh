#!/bin/bash
#
read -p "Input a character: " Char

case $Char in
[0-9])
  echo "A digit." ;;
[a-z])
  echo "A lower." ;;
[A-Z])
  echo "An upper." ;;
[[:punct:]] )
  echo "A punction." ;;
*)
  echo "Special char." ;;
esac


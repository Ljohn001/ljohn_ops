#!/bin/bash
#

read -p "Do you agree [yes|no]?: " YesNo

case $YesNo in
y|Y|[Yy]es)
  echo "Agreed, proceed." ;;
n|N|[nN]o)
  echo "Disagreed, can't proceed." ;;
*)
  echo "Invalid input." ;;
esac


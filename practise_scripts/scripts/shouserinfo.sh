#!/bin/bash
#
			  read -p "Plz enter a username: " userName

			  while [ "$userName" != 'q' -a "$userName" != 'quit' ]; do
			  	  if id $userName &> /dev/null; then
			  	      grep "^$userName\>" /etc/passwd | cut -d: -f3,7
			  	  else
			  	  	  echo "No such user."
			  	  fi

			  	  read -p "Plz enter a username again: " userName
			  done

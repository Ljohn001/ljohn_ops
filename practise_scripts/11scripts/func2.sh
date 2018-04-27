#!/bin/bash
#
ShowUserInfo() {
  id $1 &> /dev/null && grep "^$1:" /etc/passwd | cut -d: -f3,7 && return 0 || return 3
}

read -p "A username: " UserName

ShowUserInfo $UserName
#echo $?

#!/bin/bash
#
UserName=`dialog --stdout --backtitle "Add a user." --title "UserName" --inputbox "Please input a username: " 10 25`
RETVAL=$?
clear
if [ $RETVAL -eq 0 -a -n "$UserName" ] ; then
  if ! id $UserName &> /dev/null; then
    useradd $UserName
    Pass=`dialog --colors --ok-label "Submit" --no-shadow --nocancel --stdout --backtitle "Password for $UserName" --title "Password"  --insecure --passwordbox "Please enter the password for \Z1$UserName\Zn: " 10 30`
    echo $Pass | passwd --stdin $UserName &> /dev/null
    dialog --clear --backtitle "Add a user." --title "Add a user." --msgbox "Add user $UserName finished." 10 30
  else
    echo "$UserName is already there."
  fi
fi

#!/bin/bash
#
Reboot(){
read -p "Do you want to reboot the system? {yes or no}:" command
if [ "$command" == "yes" ]; then
   echo "Reboot now!"
elif [ "$command" == "no" ]; then
   echo "Centos6 init is ok! please enjoy it!"
else
  echo "Sorry, $command not recognized. Enter yes or no."
  exit 1
fi
exit 0
}
Reboot


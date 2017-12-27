#!/bin/bash
#
Reboot(){
read -p "Do you want to reboot the system? {yes or no}:" want
if [ "$want" == "yes" ]; then
   echo "Reboot now!"
elif [ "$want" == "no" ]; then
   echo "Centos6 init is ok! please enjoy it!"
else
  echo "Sorry, $want not recognized. Enter yes or no."
  exit 1
fi
exit 0
}
Reboot $1


#!/bin/bash
#
Reboot(){
read -p "Do you want to reboot the system? {yes or no}: " command
if [ "$command" == "yes" ]; then
   echo "Reboot now!"
 #  reboot
elif [ "$command" == "no" ]; then
   echo "Centos6 init is ok! please enjoy it!"
   exit 0
else
   echo "Please input  yes or no! but,you can manual reboot it !!"
   exit 1
fi
}
Reboot

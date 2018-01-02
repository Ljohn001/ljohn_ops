#!/bin/bash
#
cat << EOF
 +--------------------------------------------------------------+  
 |                === System init Finished ===                  |  
 +--------------------------------------------------------------+  
EOF
#sleep 3
#重启系统
read -p "Do you want to reboot the system?{yes,no}: " command
case $command in
yes)
   echo "Reboot now!"  
#   reboot
;;

no)
   echo "Centos6 init is ok! please enjoy it!"  
;;

*)
   echo 'Please useage "yes" or "no"! thanks'  
;;

esac


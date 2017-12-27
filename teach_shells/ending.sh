#!/bin/bash
#
cat << EOF
 +--------------------------------------------------------------+  
 |                === System init Finished ===                  |  
 +--------------------------------------------------------------+  
EOF
sleep 3
#重启系统
read -p "Do you want to reboot the system?{yes|y,no|n}" want
case $want in
yes|y)
   echo "Reboot now!"  
   reboot
;;

no|n)
   echo "Centos6 init is ok! please enjoy it!"  
;;

*)
   echo 'Please useage "yes|y" or "no|n"! thanks'  
;;

esac


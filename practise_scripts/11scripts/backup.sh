#!/bin/bash
#
Dir=('/etc/httpd' '/etc/pam.d' '/etc/vsftpd')
Source=`dialog --stdout --title "Backup" --checklist "Choose the dir you want to backup: " 10 50 3 0 /etc/httpd 0 1 /etc/pam.d 1 2 /etc/vsftpd 0`
echo $Source
Source=`echo $Source | tr -d '"'`

for I in $Source; do
  echo ${Dir[$I]}
done

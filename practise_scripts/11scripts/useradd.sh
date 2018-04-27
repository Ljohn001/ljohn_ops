#!/bin/bash
# Author: MageEdu
# Date: 2013-07-15
# Version: 0.0.1
# Description: Add users

UserName="user4"
useradd $UserName
echo $UserName | passwd --stdin $UserName > /dev/null
echo "Add $UserName successfully."

useradd user2
echo user2 | passwd --stdin user2 > /dev/null
echo "Add user2 successfully."

useradd user3
echo user3 | passwd --stdin user3 > /dev/null


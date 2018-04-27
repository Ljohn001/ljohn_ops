#!/bin/bash
#
#===============================
# Description: Configure profile for yourself
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.11.02
# Version: 1.0
#===============================
if [ -f /etc/profile.d/ljohn.sh ];then
   echo "The file is exist"
else
   cat >> /etc/profile.d/ljohn.sh <<EOF
HISTSIZE=10000
HISTTIMEFORMAT="%F %T root "

alias l='ls -AFhlt'
alias lh='l | head'
alias vi=vim

GREP_OPTIONS="--color=auto"
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
EOF
   if [ $? -eq 0 ];then
      echo 'PS1="\[\e[32;1m\][\u@\h \W]\\$\[\e[0m\]"' >> /etc/profile.d/ljohn.sh
   else
      echo "config failure" && exit 1
   fi
   chmod 644 /etc/profile.d/ljohn.sh
   source /etc/profile.d/ljohn.sh
   [ $? -eq 0 ] && echo "ok" || echo "failure"
fi

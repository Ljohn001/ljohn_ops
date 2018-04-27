#!/bin/bash
#

ssh-keygen -t rsa -b 2048 -N "" -f $HOME/.ssh/id_rsa

cat $HOME/.ssh/id_rsa.pub >$HOME/.ssh/authorized_keys
chmod 600 $HOME/.ssh/authorized_keys

for ip in $(awk '{print $1}' install.config); do
    rsync -av -e 'ssh -o StrictHostKeyChecking=no' $HOME/.ssh/authorized_keys root@$ip:$HOME/.ssh/
done

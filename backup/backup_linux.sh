#!/bin/bash
#

sudo tar -zcvp -f /backup-$(date '+%Y-%m-%d_%H_%M_%S').tgz  \
        --exclude=/home/ljohn/.cache \
        --exclude=/home/ljohn/.gradle \
        --exclude=/home/ljohn/.m2 \
        --exclude=/home/ljohn/.mozilla \
        --exclude=/home/ljohn/.IntelliJIdea2019.1 \
        --exclude=/home/ljohn/.xsession-errors \
        --exclude=/home/ljohn/.deepinwine \
        --exclude=/home/ljohn/.local \
        --exclude=/home/ljohn/.config/google-chrome \
        --exclude=/home/ljohn/.config/oss-browser \
        --exclude=/home/ljohn/Documents \
        --exclude=/home/ljohn/Downloads \
        --exclude=/home/ljohn/Music \
        --add-file=/home/ljohn
        --add-file=/usr/local/sbin \
        --add-file=/usr/lcoal/bin \
        --add-file=/etc
        --add-file=/opt
        --add-file=/server
        --add-file=/opt

#!/bin/bash
#
[ -d /backups ] || mkdir /backups

cat << EOF
	xz) xz compress tool
	gz) gzip compress tool
	bz2) bzip2 compress tool
EOF

read -p "Plz choose an option: " choice

case $choice in
xz)
    tar -Jcf /backups/etc-`date +%F-%H-%M-%S`.tar.xz /etc/*
    ;;
gz)
    tar -zcf /backups/etc-`date +%F-%H-%M-%S`.tar.gz /etc/*
    ;;
bz2)
    tar -jcf /backups/etc-`date +%F-%H-%M-%S`.tar.bz2 /etc/*
    ;;
*)
    echo "wrong option."
    exit 1
    ;;
esac

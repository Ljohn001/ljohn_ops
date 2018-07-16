#!/bin/bash

docker ps | grep mysql
if [ $? -eq 0 ];then
docker rm -f mysql
fi

docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -v /data/mysql:/var/lib/mysql -v /etc/mysql/my.cnf:/etc/mysql/my.cnf --ulimit nofile=65536 --name mysql mysql:5.7


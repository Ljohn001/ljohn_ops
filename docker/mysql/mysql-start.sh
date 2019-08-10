#!/bin/bash

docker ps -a | grep mysql
if [ $? -eq 0 ];then
docker rm -f mysql
fi

DATADIR=`pwd`/data

#-e MYSQL_ROOT_PASSWORD=root \
docker run -d -p 3306:3306 \
-v ${DATADIR}/mysql:/var/lib/mysql \
-v $PWD/mysqld.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
-e MYSQL_ROOT_PASSWORD=root \
--ulimit nofile=65536 \
--name mysql \
mysql:5.7

#!/bin/bash

docker ps | grep mysql
if [ $? -eq 0 ];then
docker rm -f mysql
fi

DATADIR=`pwd`/data

docker run -d -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
-v ${DATADIR}/mysql:/var/lib/mysql \
-v $PWD/mysqld.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
--ulimit nofile=65536 \
--name mysql \
mysql:5.7

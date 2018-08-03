#!/bin/bash
#
docker ps | grep mongo
if [ $? -eq 0 ];then
docker rm -f mongo
fi

DATADIR=`pwd`/data
docker run -d \
--name mongo \
-p 27017:27017 \
-v $PWD/mongodb.conf:/etc/mongod.conf.orig \
-v ${DATADIR}/mongodb:/data/db \
--ulimit nofile=65536 \
dockerrepos.vphotos.cn/vphoto/mongo:v3.2

#!/bin/bash
#
docker run -d -p 27017:27017 -v /etc/mongo/mongodb.conf:/etc/mongod.conf.orig -v /dv/mongodb/fat:/data/db --ulimit nofile=65536 --name mongo-fat dockerrepos.vphotos.cn/vphoto/mongo:v3.2

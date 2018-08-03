#!/bin/bash
#
docker ps | grep postgres
if [ $? -eq 0 ];then
docker rm -f postgres
fi

DATADIR=`pwd`/data
docker run -d  \
--name=postgres \
-p 5432:5432 \
-v ${DATADIR}/pgdata:/var/lib/postgresql/data \
-e POSTGRES_PASSWORD=pgadmin \
-e POSTGRES_USER=pgadmin  \
-v "$PWD/postgres.conf":/etc/postgresql/postgresql.conf \
postgres:latest \
-c 'config_file=/etc/postgresql/postgresql.conf' \
-c 'shared_buffers=256MB' -c 'max_connections=200' \

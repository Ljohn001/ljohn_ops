#!/bin/bash

docker ps | grep rancher
if [ $? -eq 0 ];then
docker rm -f rancher
fi
 
docker run --name=rancher -v /dv/mysql/rancher:/var/lib/mysql -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/server

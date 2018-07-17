#!/bin/bash
#

docker ps | grep gitlab
if [ $? -eq 0 ];then
docker rm -f gitlab
fi

GITLAB_HOME=`pwd`/data/gitlab
docker run -d \
    --hostname gitlab \
    --publish 8443:443 --publish 80:80 --publish 2222:22 \
    --name gitlab \
    --restart always \
    --volume $GITLAB_HOME/config:/etc/gitlab \
    --volume $GITLAB_HOME/logs:/var/log/gitlab \
    --volume $GITLAB_HOME/data:/var/opt/gitlab \
    gitlab/gitlab-ce

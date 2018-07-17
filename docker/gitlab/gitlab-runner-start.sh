#!/bin/bash
#

docker ps | grep gitlab-runner
if [ $? -eq 0 ];then
docker rm -f gitlab-runner
fi
GITLAB_HOME=`pwd`/data/gitlab-runner

docker run -d --name gitlab-runner --restart always \
           -v $GITLAB_HOME/config:/etc/gitlab-runner \
           -v $GITLAB_HOME/var/run/docker.sock:/var/run/docker.sock \
           gitlab/gitlab-runner:latest


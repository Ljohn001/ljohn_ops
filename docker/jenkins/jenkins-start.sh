#!/bin/bash
#
DATADIR=`pwd`/data
docker run \
  -u root \
  --rm \
  --name=jenkins-server \
  -d \
  -p 8080:8080 \
  -p 50000:50000 \
  -v $DATADIR/jenkins-data:/var/jenkins_home \
  -v $DATADIR/var/run/docker.sock:/var/run/docker.sock \
  jenkinsci/blueocean


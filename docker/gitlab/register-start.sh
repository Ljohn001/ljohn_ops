#!/bin/bash
#
sudo docker exec -it gitlab-runner gitlab-runner register -n \
  --url http://10.3.141.17:8090/ \
  --registration-token UzWNFotxSpZeM7YHbktL \
  --executor docker \
  --description "docker-02" \
  --docker-image "docker:latest" \
  --docker-privileged

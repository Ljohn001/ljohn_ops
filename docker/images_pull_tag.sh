#!/bin/bash
#
images=(
gcr.io/google_containers/heapster-grafana-amd64:v4.4.3
gcr.io/google_containers/heapster-amd64:v1.5.3
gcr.io/google_containers/heapster-influxdb-amd64:v1.3.3)

for imageName in ${images[@]} ; do
    docker tag $images  dockerrepos.vphotos.cn/vphoto/$imageName
    docker push dockerrepos.vphotos.cn/vphoto/$imageName
    docker rmi $imageName
done

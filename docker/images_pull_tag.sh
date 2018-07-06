#!/bin/bash

images=(
#k8s.gcr.io/heapster-s390x:v1.5.3
#k8s.gcr.io/heapster-ppc64le:v1.5.3
#k8s.gcr.io/heapster-arm64:v1.5.3
#k8s.gcr.io/heapster-arm:v1.5.3
#k8s.gcr.io/heapster-amd64:v1.5.3
gcr.io/google_containers/heapster-grafana-amd64:v4.4.3
gcr.io/google_containers/heapster-amd64:v1.5.3
gcr.io/google_containers/heapster-influxdb-amd64:v1.3.3)

for imageName in ${images[@]} ; do
    docker tag $images  dockerrepos.vphotos.cn/vphoto/$imageName
    #imageName_suffix=$(echo "${imageName}"| awk -F 'heapster' '{print $2}')
    #docker tag docker.io/huwanyang168/$imageName gcr.io/spinnaker-marketplace/$imageName_suffix 
    docker push dockerrepos.vphotos.cn/vphoto/$imageName
    docker rmi $imageName
done

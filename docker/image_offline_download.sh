#!/bin/bash
# by ljohn 
# time 20210121
# 批量下载镜像。并打包
#
images=(
quay.io/prometheus/alertmanager:v0.21.0
docker.io/jimmidyson/configmap-reload:v0.3.0
quay.io/coreos/prometheus-operator:v0.38.1
squareup/ghostunnel:v1.5.2
kiwigrid/k8s-sidecar:0.1.151
grafana/grafana:7.0.3
quay.io/coreos/kube-state-metrics:v1.9.7
quay.io/prometheus/node-exporter:v1.0.0
quay.io/prometheus/prometheus:v2.18.2
quay.io/coreos/prometheus-config-reloader:v0.38.1
jettech/kube-webhook-certgen:v1.2.1
)
for i in ${images[@]}
do 
docker pull $i
done
docker save $(docker images | grep -v REPOSITORY | awk 'BEGIN{OFS=":";ORS=" "}{print $1,$2}') -o prometheus.tar

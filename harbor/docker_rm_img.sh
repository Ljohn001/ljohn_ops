#!/bin/bash

docker run -it --name gc --rm --volumes-from registry vmware/registry-photon:v2.6.2-v1.5.0-rc2 garbage-collect  /etc/registry/config.yml

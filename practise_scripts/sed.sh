#!/bin/bash
#
#1.sed中使用变量,示例:
dhcp_ip=192.168.137
sed -i 's@'192.168.1'@'"$dhcp_ip"'@g' dhcp.template

dhcp_ip=192.168.1
sed -i 's@'192.168.137'@'"$dhcp_ip"'@g'';22d;23d' dhcp.template

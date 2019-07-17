UserParameter=redis.status,/usr/bin/redis-cli -h 10.3.16.106 -p 6379 ping |grep -c PONG 
UserParameter=redis_info[*],/etc/zabbix/redis_zbx_gallery.sh $1 $2 $3 

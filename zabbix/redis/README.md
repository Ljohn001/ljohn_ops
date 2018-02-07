## redis 监控
> 使用Zabbix3.4监控工具创建 redis监控模板并实现redis监控

- 模板下载链接：
http://download.21yunwei.com/zabbix/redis/zbx_template_redis.tar.gz
- 脚本:
```
redis_zbx.sh
```
- agent客户端添加配置:
zabbixd_agent.conf
```
 #监控redis状态，我们可以根据这个参数对应的监控项创建redis状态触发器。
#redis monitor
UserParameter=redis.status,/usr/bin/redis-cli -h 127.0.0.1 -p 6379 ping |grep -c PONG 
UserParameter=redis_info[*],/home/yunwei/redis_zbx.sh $1 $2 
```
说明：
> 1，这个模板redis监控的参数比较多，具体根据自己的实际情况启用redis里边的应用集或者监控项，也可以自己再添加,。
> 2，默认aof未开启 以及slave这里都有监控，用不到的就停掉，这个模板。当前模板四个触发器，其中关于aof和主从的关了，只保留了redis存活状态和redis磁盘回写失败与否两个触发器。

> 原文地址：http://www.21yunwei.com/archives/4195

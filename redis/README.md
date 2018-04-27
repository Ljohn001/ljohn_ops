# 使用说明
1、方法一：
下载使用
```bash
# wget https://github.com/Ljohn001/ljohn_ops/raw/master/redis/redis3.x.sh
# chmod +x redis3.x.sh
# ./redis3.x.sh
# ps -ef | grep redis 
root      1391     1  0 00:34 ?        00:00:00 /usr/local/bin/redis-server 0.0.0.0:6379
```
启停redis
```bash
# service redis_6379 start
# service redis_6379 stop

##注意
requirepass 启用后，停止redis需要执行
# redis-cli -a 123456 shutdown  #123456为密码
```
2、方法二：远程执行
```bash
# curl -Lso- https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/redis/redis3.x.sh |bash
```


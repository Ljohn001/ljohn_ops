#!/bin/bash
###################################
# date author note
# function for redis montior
#
# touch /opt/zabbix/bin/redis_monitor.sh; chmod +x /opt/zabbix/bin/redis_monitor.sh
#
# redis的zabbix配置：
# UserParameter=custom.redis.discovery,/opt/zabbix/bin/redis_monitor.sh discovery
# UserParameter=custom.redis.status[*],/opt/zabbix/bin/redis_monitor.sh $1 $2 $3
###################################


############# 配置部分 ##################
export HOST="10.3.16.106"
export PORT="$1"

# redis自定义安装的目录
export BASE_DIR=/usr/bin/redis-server

# 如果无密码，置空即可。或者直接从本地配置中获取密码。该配置这儿如果不配，下面会自动偿试从本地配置中获取
# export PASSWD="pass"

############# 配置结束 ##################

# 环境变量
export
export LC_ALL=C
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

############# PROGRAM ##############

if [ "$1" == "" ] || [ "$1" == "help" ]; then
    echo "\$1 Can not be empty, error, exit."
    exit
fi


# 发现规则
REDIS=""
if [ "$1" == "discovery" ];then
    for each in `find ${BASE_DIR} -name "redis*.conf" -type f|xargs grep '^port'|cut -d' ' -f2|sort|uniq`
    do
        REDIS=${REDIS}'"{#REDISPORT}":"'${each}'",'
    done

    echo '{"data": [{'${REDIS}'}]}' | sed 's/,/},{/g' | sed 's/,{}//'
    exit
fi


# 密码判断和获取
if [ "$PASSWD" == "" ];then
    if [ "$1" == "6379" ] &amp;&amp; [ -f ${BASE_DIR}/redis.conf ];then
        PASSWD=`grep -v "^#" ${BASE_DIR}/redis.conf | sed '/^$/d' | grep requirepass | awk '{ print $2; }'`
    else
        PASSWD=`grep -v "^#" ${BASE_DIR}/redis_$1.conf | sed '/^$/d' | grep requirepass | awk '{ print $2; }'`
    fi
fi
if [ "$PASSWD" != "" ];then
    pw_parameter="-a"
else
    pw_parameter=""
fi


# 定义命令路径
export REDISCLI="${BASE_DIR}/bin/redis-cli"

if [ ! -f "$REDISCLI" ];then
    REDISCLI="${BASE_DIR}/src/redis-cli"
fi
REDISCONN="$REDISCLI -h $HOST -p $PORT $pw_parameter $PASSWD"


# 获取监控值
if [[ $# == 2 ]];then
    case $2 in
        redis_ping)
            result=`$REDISCONN ping 2&gt; /dev/null | grep -c PONG`
            echo $result
        ;;
        redis_version)
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "redis_version" | awk -F':' '{print $2}'`
            echo $result
        ;;
        uptime_in_seconds)
            # 自 Redis 服务器启动以来，经过的秒数
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "uptime_in_seconds" | awk -F':' '{print $2}'`
            echo $result
        ;;
        uptime_in_days)
            # 自 Redis 服务器启动以来，经过天数
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "uptime_in_days" | awk -F':' '{print $2}'`
            echo $result
        ;;
        connected_clients)
            # 已连接客户端的数量（不包括通过从属服务器连接的客户端）
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "connected_clients" | awk -F':' '{print $2}'`
            echo $result
        ;;
        blocked_clients)
            # 正在等待阻塞命令（BLPOP、BRPOP、BRPOPLPUSH）的客户端的数量
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "blocked_clients" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory)
            # 由 Redis分配器分配的内存总量，以字节（byte）为单位
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_memory" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_rss)
            # 从操作系统的角度，返回 Redis 已分配的内存总量（俗称常驻集大小）。这个值和 top 、 ps等命令的输出一致。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_memory_rss" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_peak)
            # Redis 的内存消耗峰值（以字节为单位）
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_memory_peak" | awk -F':' '{print $2}'`
            echo $result
        ;;
        used_memory_lua)
            # Lua 引擎所使用的内存大小（以字节为单位）
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_memory_lua" | awk -F':' '{print $2}'`
            echo $result
        ;;
        mem_fragmentation_ratio)
            # 内存碎片的比率，used_memory_rss 和 used_memory 之间的比率
            # 在理想情况下， used_memory_rss 的值应该只比 used_memory 稍微高一点儿。
            # 当 rss &gt; used ，且两者的值相差较大时，表示存在（内部或外部的）内存碎片。
            # 内存碎片的比率可以通过 mem_fragmentation_ratio 的值看出。
            # 当 used &gt; rss 时，表示 Redis 的部分内存被操作系统换出到交换空间了，在这种情况下，操作可能会产生明显的延迟。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "mem_fragmentation_ratio" | awk -F':' '{print $2}'`
            echo $result
        ;;
        aof_current_size)
            # AOF 文件目前的大小
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "aof_current_size" | awk -F':' '{print $2}'`
            echo $result
        ;;
        aof_pending_bio_fsync)
            # 后台 I/O 队列里面，等待执行的 fsync 调用数量。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "aof_pending_bio_fsync" | awk -F':' '{print $2}'`
            echo $result
        ;;
        aof_last_rewrite_time_sec)
            # 最近一次创建 AOF 文件耗费的时长。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "aof_last_rewrite_time_sec" | awk -F':' '{print $2}'`
            echo $result
        ;;
        aof_last_bgrewrite_status)
            # 一个标志值，记录了最近一次创建 AOF 文件的结果是成功还是失败。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "aof_last_bgrewrite_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        aof_last_write_status)
            # 没搞懂aof_last_bgrewrite_status和aof_last_write_status的区别
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "aof_last_write_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        rdb_changes_since_last_save)
            # 距离最近一次成功创建持久化文件之后，经过了多少秒。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "rdb_changes_since_last_save" | awk -F':' '{print $2}'`
            echo $result
        ;;
        rdb_last_save_time)
            # 最近一次成功创建 RDB 文件的 UNIX 时间戳。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "rdb_last_save_time" | awk -F':' '{print $2}'`
            echo $result
        ;;
        rdb_last_bgsave_status)
            # 一个标志值，记录了最近一次创建 RDB 文件的结果是成功还是失败。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "rdb_last_bgsave_status" | awk -F':' '{print $2}' | grep -c ok`
            echo $result
        ;;
        rdb_last_bgsave_time_sec)
            # 记录了最近一次创建 RDB 文件耗费的秒数。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "rdb_last_bgsave_time_sec" | awk -F':' '{print $2}'`
            echo $result
        ;;
        instantaneous_ops_per_sec)
            # 服务器每秒钟执行的命令数量。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "instantaneous_ops_per_sec" | awk -F':' '{print $2}'`
            echo $result
        ;;
        rejected_connections)
            # 因为最大客户端数量限制而被拒绝的连接请求数量。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "rejected_connections" | awk -F':' '{print $2}'`
            echo $result
        ;;
        expired_keys)
            # 因为过期而被自动删除的数据库键数量。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "expired_keys" | awk -F':' '{print $2}'`
            echo $result
        ;;
        evicted_keys)
            # 因为最大内存容量限制而被驱逐（evict）的键数量。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "evicted_keys" | awk -F':' '{print $2}'`
            echo $result
        ;;
        keyspace_hits_rate)
            # 键请求命中率
            i=`$REDISCONN info 2&gt; /dev/null | grep -w "keyspace_hits" | awk -F':' '{print $2}' | tr -d "\r"`
            j=`$REDISCONN info 2&gt; /dev/null | grep -w "keyspace_misses" | awk -F':' '{print $2}'| tr -d "\r"`
            result=$(($i*100/($i+$j)))
            echo $result
        ;;
        latest_fork_usec)
            # 最近一次 fork() 操作耗费的毫秒数。当 Redis 持久化数据到磁盘上时，它会进行一次 fork 操作。# 是毫秒还是微秒，应该是微秒吧
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "latest_fork_usec" | awk -F':' '{print $2}'`
            echo $result
        ;;
        master_link_down_since_seconds)
            # 主从服务器连接断开了多少秒。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "master_link_down_since_seconds" | awk -F':' '{print $2}'`
            echo $result
        ;;
        master_last_io_seconds_ago)
            # 主从服务器连接断开了多少秒。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "master_last_io_seconds_ago" | awk -F':' '{print $2}'`
            echo $result
        ;;
        master_link_status)
            # 复制连接当前的状态， up 表示连接正常， down 表示连接断开。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "master_link_status" | awk -F':' '{print $2}' | grep -c up`
            echo $result
        ;;
        used_cpu_sys)
            # Redis 服务器耗费的系统 CPU 。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_cpu_sys" | awk -F':' '{print $2}' | cut -d'.' -f 1`
            echo $result
        ;;
        used_cpu_user)
            # Redis 服务器耗费的用户 CPU 。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_cpu_user" | awk -F':' '{print $2}' | cut -d'.' -f 1`
            echo $result
        ;;
        used_cpu_sys_children)
            # 后台进程耗费的系统 CPU 。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_cpu_sys_children" | awk -F':' '{print $2}' | cut -d'.' -f 1`
            echo $result
        ;;
        used_cpu_user_children)
            # 后台进程耗费的用户 CPU 。
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "used_cpu_user_children" | awk -F':' '{print $2}' | cut -d'.' -f 1`
            echo $result
        ;;
        *)
            echo -e "\033[33mUsage: $0 PORT Parameter\033[0m" 
        ;;
    esac
elif [[ $# == 3 ]];then
    case $3 in
        keys)
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "$2" | grep -w "keys" | awk -F'=|,' '{print $2}'`
            echo $result
        ;;
        expires)
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "$2" | grep -w "keys" | awk -F'=|,' '{print $4}'`
            echo $result
        ;;
        avg_ttl)
            result=`$REDISCONN info 2&gt; /dev/null | grep -w "$2" | grep -w "avg_ttl" | awk -F'=|,' '{print $6}'`
            echo $result
        ;;
        *)
            echo -e "\033[33mUsage: $0 PORT Parameter\033[0m" 
        ;;
    esac
fi

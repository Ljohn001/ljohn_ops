#!/bin/bash
# -------------------------------------------------------------------------------
# FileName:    check_redis.sh
# Revision:    1.0
# Date:        2018/09/19
# Author:      wangxz@morningtec.cn
# Email:       
# Website:     
# Description: 
# Notes:       ~
# -------------------------------------------------------------------------------
# 用户名
REDIS_USER='dbashow'
 
# 密码解密
#PASS=`echo -n "${4:-'cxLJRSUk3e2AjoZP'}" |base64 -d |openssl enc -des-ecb -K 20190919 -nosalt  -d`
#密码
REDIS_PWD=${PASS:-'quie2Cu3'}
 
# 主机地址/IP
REDIS_HOST=${2:-'127.0.0.1'}
 
# 端口
REDIS_PORT=${3:-'6379'}

# 数据连接
REDIS_CONN="redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} -a ${REDIS_PWD}"
REDIS_INFO="${REDIS_CONN} info"

source /etc/bashrc >/dev/null 2>&1
source /etc/profile  >/dev/null 2>&1

# 参数是否正确
if [ $# -lt "1" ];then 
    echo "arg error!" 
fi 

# 获取数据
case $1 in
ping)
	result=`${REDIS_CONN} ping |grep -c PONG`
	echo $result 
;;
redis_version)
	result=`${REDIS_INFO}|grep -w redis_version |awk -F":" '{print $NF}'`
	echo $result 
;;
role)
	result=`${REDIS_INFO}|grep role|awk -F":" '{print $NF}'`
	echo $result 
;;
cluster)
	result=`${REDIS_INFO}|grep cluster|awk -F":" '{print $NF}'`
	echo $result 
;; 
uptime_in_seconds)
	result=`${REDIS_INFO}|grep uptime_in_seconds|awk -F":" '{print $NF}'`
	echo $result 
;; 
connected_clients)
	result=`${REDIS_INFO}|grep connected_clients|awk -F":" '{print $NF}'`
	echo $result 
;; 
client_longest_output_list)
	result=`${REDIS_INFO}|grep client_longest_output_list|awk -F":" '{print $NF}'`
	echo $result 
;; 
client_biggest_input_buf)
	result=`${REDIS_INFO}|grep client_biggest_input_buf|awk -F":" '{print $NF}'`
	echo $result 
;; 
blocked_clients)
	result=`${REDIS_INFO}|grep blocked_clients|awk -F":" '{print $NF}'`
	echo $result 
;; 
#内存
used_memory)
	result=`${REDIS_INFO}|grep used_memory|awk -F":" '{print $NF}'|awk 'NR==1'`
	echo $result 
;; 
used_memory_human)
	result=`${REDIS_INFO}|grep used_memory_human|awk -F":" '{print $NF}'|awk -F'K' '{print $1}'` 
	echo $result 
;; 
used_memory_rss)
	result=`${REDIS_INFO}|grep used_memory_rss|awk -F":" '{print $NF}'`
	echo $result 
;; 
used_memory_peak)
	result=`${REDIS_INFO}|grep used_memory_peak|awk -F":" '{print $NF}'|awk 'NR==1'`
	echo $result 
;; 
used_memory_peak_human)
	result=`${REDIS_INFO}|grep used_memory_peak_human|awk -F":" '{print $NF}'|awk -F'K' '{print $1}'`
	echo $result 
;; 
used_memory_lua)
	result=`${REDIS_INFO}|grep used_memory_lua|awk -F":" '{print $NF}'`
	echo $result 
;;     
mem_fragmentation_ratio)
	result=`${REDIS_INFO}|grep mem_fragmentation_ratio|awk -F":" '{print $NF}'`
	echo $result 
;;   
#rdb
rdb_changes_since_last_save)
	result=`${REDIS_INFO}|grep rdb_changes_since_last_save|awk -F":" '{print $NF}'`
	echo $result 
;;   
rdb_bgsave_in_progress)
	result=`${REDIS_INFO}|grep rdb_bgsave_in_progress|awk -F":" '{print $NF}'`
	echo $result 
;;   
rdb_last_save_time)
	result=`${REDIS_INFO}|grep rdb_last_save_time|awk -F":" '{print $NF}'`
	echo $result 
;;   
rdb_last_bgsave_status)
	result=`${REDIS_INFO}|grep -w "rdb_last_bgsave_status" | awk -F':' '{print $2}' | grep -c ok`
	echo $result 
;;   
rdb_current_bgsave_time_sec)
	result=`${REDIS_INFO}|grep -w "rdb_current_bgsave_time_sec" | awk -F':' '{print $2}'`
	echo $result 
;; 
#rdbinfo
aof_enabled)
	result=`${REDIS_INFO}|grep -w "aof_enabled" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_rewrite_scheduled)
	result=`${REDIS_INFO}|grep -w "aof_rewrite_scheduled" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_last_rewrite_time_sec)
	result=`${REDIS_INFO}|grep -w "aof_last_rewrite_time_sec" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_current_rewrite_time_sec)
	result=`${REDIS_INFO}|grep -w "aof_current_rewrite_time_sec" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_last_bgrewrite_status)
	result=`${REDIS_INFO}|grep -w "aof_last_bgrewrite_status" | awk -F':' '{print $2}' | grep -c ok`
	echo $result 
;; 
#aofinfo
aof_current_size)
	result=`${REDIS_INFO}|grep -w "aof_current_size" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_base_size)
	result=`${REDIS_INFO}|grep -w "aof_base_size" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_pending_rewrite)
	result=`${REDIS_INFO}|grep -w "aof_pending_rewrite" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_buffer_length)
	result=`${REDIS_INFO}|grep -w "aof_buffer_length" | awk -F':' '{print $2}'`
	echo $result 
;; 
aof_rewrite_buffer_length)
	result=`${REDIS_INFO}|grep -w "aof_rewrite_buffer_length" | awk -F':' '{print $2}'`
	echo $result 
;;   
aof_pending_bio_fsync)
	result=`${REDIS_INFO}|grep -w "aof_pending_bio_fsync" | awk -F':' '{print $2}'`
	echo $result 
;;
aof_delayed_fsync)
	result=`${REDIS_INFO}|grep -w "aof_delayed_fsync" | awk -F':' '{print $2}'`
	echo $result 
;;                     
#stats
total_connections_received)
	result=`${REDIS_INFO}|grep -w "total_connections_received" | awk -F':' '{print $2}'`
	echo $result 
;; 
total_commands_processed)
	result=`${REDIS_INFO}|grep -w "total_commands_processed" | awk -F':' '{print $2}'`
	echo $result 
;; 
instantaneous_ops_per_sec)
	result=`${REDIS_INFO}|grep -w "instantaneous_ops_per_sec" | awk -F':' '{print $2}'`
	echo $result 
;; 
rejected_connections)
	result=`${REDIS_INFO}|grep -w "rejected_connections" | awk -F':' '{print $2}'` 
	echo $result 
;; 
expired_keys)
	result=`${REDIS_INFO}|grep -w "expired_keys" | awk -F':' '{print $2}'`
	echo $result 
;; 
evicted_keys)
		result=`${REDIS_INFO}|grep -w "evicted_keys" | awk -F':' '{print $2}'` 
		echo $result 
;; 
keyspace_hits)
	result=`${REDIS_INFO}|grep -w "keyspace_hits" | awk -F':' '{print $2}'` 
	echo $result 
;; 
keyspace_misses)
	result=`${REDIS_INFO}|grep -w "keyspace_misses" | awk -F':' '{print $2}'`
	echo $result 
;;
pubsub_channels)
	result=`${REDIS_INFO}|grep -w "pubsub_channels" | awk -F':' '{print $2}'`
	echo $result 
;;
pubsub_channels)
	result=`${REDIS_INFO}|grep -w "pubsub_channels" | awk -F':' '{print $2}'`
	echo $result 
;;
pubsub_patterns)
	result=`${REDIS_INFO}|grep -w "pubsub_patterns" | awk -F':' '{print $2}'`
	echo $result 
;;
latest_fork_usec)
	result=`${REDIS_INFO}|grep -w "latest_fork_usec" | awk -F':' '{print $2}'`
	echo $result 
;;           
connected_slaves)
	result=`${REDIS_INFO}|grep -w "connected_slaves" | awk -F':' '{print $2}'`
	echo $result 
;;
master_link_status)
	result=`${REDIS_INFO}|grep -w "master_link_status"|awk -F':' '{print $2}'|grep -c up`
	echo $result 
;;
master_last_io_seconds_ago)
	result=`${REDIS_INFO}|grep -w "master_last_io_seconds_ago"|awk -F':' '{print $2}'`
	echo $result 
;;
master_sync_in_progress)
	result=`${REDIS_INFO}|grep -w "master_sync_in_progress"|awk -F':' '{print $2}'`
	echo $result 
;;
slave_priority)
	result=`${REDIS_INFO}|grep -w "slave_priority"|awk -F':' '{print $2}'`
	echo $result 
;;
#cpu
used_cpu_sys)
	result=`${REDIS_INFO}|grep -w "used_cpu_sys"|awk -F':' '{print $2}'`
	echo $result 
;;
used_cpu_user)
	result=`${REDIS_INFO}|grep -w "used_cpu_user"|awk -F':' '{print $2}'`
	echo $result 
;;
used_cpu_sys_children)
	result=`${REDIS_INFO}|grep -w "used_cpu_sys_children"|awk -F':' '{print $2}'`
	echo $result 
;;
used_cpu_user_children)
	result=`${REDIS_INFO}|grep -w "used_cpu_user_children"|awk -F':' '{print $2}'`
	echo $result 
;;
db0)
	case $5 in
	keys)
		result=`${REDIS_INFO}| grep -w "db0"| grep -w "$5" | grep -w "keys" | awk -F'=|,' '{print $2}'`
		echo $result 
	;;
	expires)
		result=`${REDIS_INFO}| grep -w "db0"| grep -w "$5" | grep -w "expires" | awk -F'=|,' '{print $4}'`
		echo $result 
	;;
	avg_ttl)
		result=`${REDIS_INFO}|grep -w "db0"| grep -w "$5" | grep -w "avg_ttl" | awk -F'=|,' '{print $6}'`
		echo $result 
	;;
	*)
		echo "argu error,sh redis_status.sh <db0> <HOST> <PORT> <PASS> <KEY>";exit 1
	;;
	esac
;;
*)
	echo "argu error,sh chk_redis.sh <KEY> <HOST> <PORT> <PASS>" ;exit 1
;;
esac



#!/bin/bash
REDISPATH="/usr/bin/redis-cli"
HOST="127.0.0.1"
PORT="6379"
REDIS_INFO="$REDISPATH -h $HOST -p $PORT info"
if [[ $# == 1 ]];then
case $1 in
cluster)
        result=`$REDIS_INFO|/bin/grep cluster|awk -F":" '{print $NF}'`
        echo $result 
;; 
uptime_in_seconds)
        result=`$REDIS_INFO|/bin/grep uptime_in_seconds|awk -F":" '{print $NF}'`
        echo $result 
;; 
connected_clients)
        result=`$REDIS_INFO|/bin/grep connected_clients|awk -F":" '{print $NF}'`
        echo $result 
;; 
client_longest_output_list)
        result=`$REDIS_INFO|/bin/grep client_longest_output_list|awk -F":" '{print $NF}'`
        echo $result 
;; 
client_biggest_input_buf)
        result=`$REDIS_INFO|/bin/grep client_biggest_input_buf|awk -F":" '{print $NF}'`
        echo $result 
;; 
blocked_clients)
        result=`$REDIS_INFO|/bin/grep blocked_clients|awk -F":" '{print $NF}'`
        echo $result 
;; 
#内存
used_memory)
        result=`$REDIS_INFO|/bin/grep used_memory|awk -F":" '{print $NF}'|awk 'NR==1'`
        echo $result 
;; 
used_memory_human)
        result=`$REDIS_INFO|/bin/grep used_memory_human|awk -F":" '{print $NF}'|awk -F'K' '{print $1}'` 
        echo $result 
;; 
used_memory_rss)
        result=`$REDIS_INFO|/bin/grep used_memory_rss|awk -F":" '{print $NF}'`
        echo $result 
;; 
used_memory_peak)
        result=`$REDIS_INFO|/bin/grep used_memory_peak|awk -F":" '{print $NF}'|awk 'NR==1'`
        echo $result 
;; 
used_memory_peak_human)
        result=`$REDIS_INFO|/bin/grep used_memory_peak_human|awk -F":" '{print $NF}'|awk -F'K' '{print $1}'`
        echo $result 
;; 
used_memory_lua)
        result=`$REDIS_INFO|/bin/grep used_memory_lua|awk -F":" '{print $NF}'`
        echo $result 
;;     
mem_fragmentation_ratio)
        result=`$REDIS_INFO|/bin/grep mem_fragmentation_ratio|awk -F":" '{print $NF}'`
        echo $result 
;;   
#rdb
rdb_changes_since_last_save)
        result=`$REDIS_INFO|/bin/grep rdb_changes_since_last_save|awk -F":" '{print $NF}'`
        echo $result 
;;   
rdb_bgsave_in_progress)
        result=`$REDIS_INFO|/bin/grep rdb_bgsave_in_progress|awk -F":" '{print $NF}'`
        echo $result 
;;   
rdb_last_save_time)
        result=`$REDIS_INFO|/bin/grep rdb_last_save_time|awk -F":" '{print $NF}'`
        echo $result 
;;   
rdb_last_bgsave_status)
        result=`$REDIS_INFO|/bin/grep -w "rdb_last_bgsave_status" | awk -F':' '{print $2}' | /bin/grep -c ok`
        echo $result 
;;   
rdb_current_bgsave_time_sec)
        result=`$REDIS_INFO|/bin/grep -w "rdb_current_bgsave_time_sec" | awk -F':' '{print $2}'`
        echo $result 
;; 
#rdbinfo
aof_enabled)
        result=`$REDIS_INFO|/bin/grep -w "aof_enabled" | awk -F':' '{print $2}'`
        echo $result 
;; 
aof_rewrite_scheduled)
        result=`$REDIS_INFO|/bin/grep -w "aof_rewrite_scheduled" | awk -F':' '{print $2}'`
        echo $result 
;; 
aof_last_rewrite_time_sec)
        result=`$REDIS_INFO|/bin/grep -w "aof_last_rewrite_time_sec" | awk -F':' '{print $2}'`
        echo $result 
            ;; 
aof_current_rewrite_time_sec)
        result=`$REDIS_INFO|/bin/grep -w "aof_current_rewrite_time_sec" | awk -F':' '{print $2}'`
        echo $result 
            ;; 
aof_last_bgrewrite_status)
        result=`$REDIS_INFO|/bin/grep -w "aof_last_bgrewrite_status" | awk -F':' '{print $2}' | /bin/grep -c ok`
        echo $result 
;; 
#aofinfo
aof_current_size)
        result=`$REDIS_INFO|/bin/grep -w "aof_current_size" | awk -F':' '{print $2}'`
        echo $result 
;; 
aof_base_size)
        result=`$REDIS_INFO|/bin/grep -w "aof_base_size" | awk -F':' '{print $2}'`
        echo $result 
;; 
aof_pending_rewrite)
        result=`$REDIS_INFO|/bin/grep -w "aof_pending_rewrite" | awk -F':' '{print $2}'`
        echo $result 
;; 
aof_buffer_length)
        result=`$REDIS_INFO|/bin/grep -w "aof_buffer_length" | awk -F':' '{print $2}'`
        echo $result 
;; 
aof_rewrite_buffer_length)
        result=`$REDIS_INFO|/bin/grep -w "aof_rewrite_buffer_length" | awk -F':' '{print $2}'`
        echo $result 
;;   
aof_pending_bio_fsync)
        result=`$REDIS_INFO|/bin/grep -w "aof_pending_bio_fsync" | awk -F':' '{print $2}'`
        echo $result 
;;
aof_delayed_fsync)
        result=`$REDIS_INFO|/bin/grep -w "aof_delayed_fsync" | awk -F':' '{print $2}'`
        echo $result 
;;                     
#stats
total_connections_received)
        result=`$REDIS_INFO|/bin/grep -w "total_connections_received" | awk -F':' '{print $2}'`
        echo $result 
;; 
total_commands_processed)
        result=`$REDIS_INFO|/bin/grep -w "total_commands_processed" | awk -F':' '{print $2}'`
        echo $result 
;; 
instantaneous_ops_per_sec)
        result=`$REDIS_INFO|/bin/grep -w "instantaneous_ops_per_sec" | awk -F':' '{print $2}'`
        echo $result 
;; 
rejected_connections)
        result=`$REDIS_INFO|/bin/grep -w "rejected_connections" | awk -F':' '{print $2}'` 
        echo $result 
;; 
expired_keys)
        result=`$REDIS_INFO|/bin/grep -w "expired_keys" | awk -F':' '{print $2}'`
        echo $result 
;; 
evicted_keys)
        result=`$REDIS_INFO|/bin/grep -w "evicted_keys" | awk -F':' '{print $2}'` 
        echo $result 
;; 
keyspace_hits)
        result=`$REDIS_INFO|/bin/grep -w "keyspace_hits" | awk -F':' '{print $2}'` 
        echo $result 
;; 
keyspace_misses)
        result=`$REDIS_INFO|/bin/grep -w "keyspace_misses" | awk -F':' '{print $2}'`
        echo $result 
;;
pubsub_channels)
        result=`$REDIS_INFO|/bin/grep -w "pubsub_channels" | awk -F':' '{print $2}'`
        echo $result 
;;
pubsub_channels)
        result=`$REDIS_INFO|/bin/grep -w "pubsub_channels" | awk -F':' '{print $2}'`
        echo $result 
;;
pubsub_patterns)
        result=`$REDIS_INFO|/bin/grep -w "pubsub_patterns" | awk -F':' '{print $2}'`
        echo $result 
;;
latest_fork_usec)
        result=`$REDIS_INFO|/bin/grep -w "latest_fork_usec" | awk -F':' '{print $2}'`
        echo $result 
;;           
connected_slaves)
        result=`$REDIS_INFO|/bin/grep -w "connected_slaves" | awk -F':' '{print $2}'`
        echo $result 
;;
master_link_status)
        result=`$REDIS_INFO|/bin/grep -w "master_link_status"|awk -F':' '{print $2}'|/bin/grep -c up`
        echo $result 
;;
master_last_io_seconds_ago)
        result=`$REDIS_INFO|/bin/grep -w "master_last_io_seconds_ago"|awk -F':' '{print $2}'`
        echo $result 
;;
master_sync_in_progress)
        result=`$REDIS_INFO|/bin/grep -w "master_sync_in_progress"|awk -F':' '{print $2}'`
        echo $result 
;;
slave_priority)
        result=`$REDIS_INFO|/bin/grep -w "slave_priority"|awk -F':' '{print $2}'`
        echo $result 
;;
#cpu
used_cpu_sys)
        result=`$REDIS_INFO|/bin/grep -w "used_cpu_sys"|awk -F':' '{print $2}'`
        echo $result 
;;
used_cpu_user)
        result=`$REDIS_INFO|/bin/grep -w "used_cpu_user"|awk -F':' '{print $2}'`
        echo $result 
;;
used_cpu_sys_children)
        result=`$REDIS_INFO|/bin/grep -w "used_cpu_sys_children"|awk -F':' '{print $2}'`
        echo $result 
;;
used_cpu_user_children)
        result=`$REDIS_INFO|/bin/grep -w "used_cpu_user_children"|awk -F':' '{print $2}'`
        echo $result 
;;
*)
	echo "argu error"
;;
esac
#db0:key
   elif [[ $# == 2 ]];then
case $2 in
keys)
        result=`$REDIS_INFO| /bin/grep -w "db0"| /bin/grep -w "$1" | /bin/grep -w "keys" | awk -F'=|,' '{print $2}'`
        echo $result 
;;
expires)
        result=`$REDIS_INFO| /bin/grep -w "db0"| /bin/grep -w "$1" | /bin/grep -w "expires" | awk -F'=|,' '{print $4}'`
        echo $result 
;;
avg_ttl)
        result=`$REDIS_INFO|/bin/grep -w "db0"| /bin/grep -w "$1" | /bin/grep -w "avg_ttl" | awk -F'=|,' '{print $6}'`
        echo $result 
;;
*)
     echo "argu error" ;;
esac
fi

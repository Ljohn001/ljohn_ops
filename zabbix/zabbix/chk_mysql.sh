#!/bin/bash
# -------------------------------------------------------------------------------
# FileName:    check_mysql.sh
# Revision:    1.1
# Date:        2019/02/20
# Author:      xianzheng.wang@vphotos.cn
# Email:       
# Website:     
# Description: 
# Notes:       ~
# -------------------------------------------------------------------------------
# Copyright:   2015 (c) DengYun
# License:     GPL
 
# 用户名
MYSQL_USER='dbashow'
 
# 密码
MYSQL_PWD='shoo0iZuBi8Weiqu'
 
# 主机地址/IP
MYSQL_HOST=${2:-'127.0.0.1'}
 
# 端口
MYSQL_PORT=${3:-'3306'}
 
# 数据连接
MYSQLADMIN_CONN="mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
MYSQL_CONN="mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"
source /etc/profile 2>/dev/null 
# 参数是否正确
if [ $# -lt "1" ];then 
    echo "arg error!" 
fi 
 
# 获取数据
case $1 in 
    Uptime) 
        result=`${MYSQLADMIN_CONN} status 2>/dev/null |cut -f2 -d":"|cut -f1 -d"T"` 
        echo $result 
        ;; 
    Com_update) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_update"|cut -d"|" -f3` 
        echo $result 
        ;; 
    Slow_queries) 
        result=`${MYSQLADMIN_CONN} status 2>/dev/null |cut -f5 -d":"|cut -f1 -d"O"` 
        echo $result 
        ;; 
    Com_select) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_select"|cut -d"|" -f3` 
        echo $result 
                ;; 
    Com_rollback) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_rollback"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Questions) 
        result=`${MYSQLADMIN_CONN} status 2>/dev/null |cut -f4 -d":"|cut -f1 -d"S"` 
                echo $result 
                ;; 
    Com_insert) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_insert"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_delete) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_delete"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_commit) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_commit"|cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_sent) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Bytes_sent" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Bytes_received) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Bytes_received" |cut -d"|" -f3` 
                echo $result 
                ;; 
    Com_begin) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Com_begin"|cut -d"|" -f3` 
                echo $result 
                ;; 
    connected) 
        result=`${MYSQLADMIN_CONN} extended-status 2>/dev/null |grep -w "Threads_connected"|cut -d"|" -f3` 
                echo $result 
                ;; 
    server_version)
        result=`${MYSQLADMIN_CONN} version 2>/dev/null |awk '/Server version/ {print $3}'`
                echo $result 
                ;;   
    mysql_ping)
        result=`${MYSQLADMIN_CONN} ping 2>/dev/null |grep -c alive`
                echo $result 
                ;;   
    mysql_replicate)
	Slave_IO_Running=`${MYSQL_CONN} -e 'show slave status\G' 2>/dev/null | awk -F: '{if($1~/Slave_IO_Running/) print$2}' |tr -d " "`
	Slave_SQL_Running=`${MYSQL_CONN} -e 'show slave status\G' 2>/dev/null | awk -F: '{if($1~/Slave_SQL_Running$/) print$2}'|tr -d " "`
	if [ "${Slave_IO_Running}" = "Yes" -a "${Slave_SQL_Running}" = "Yes" ];then
		result="1"
	else
		result="0"
	fi
		echo $result
        ;; 
        *) 
        echo "Usage:$0(Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin)" 
        ;; 
esac


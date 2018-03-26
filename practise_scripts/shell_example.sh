#!/bin/bash
#
#===============================
# Description:标准的shell脚本编写格式，脚本头部，脚本日志格式，脚本锁
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2018.03.01
# Version: 1.0
#===============================
#
# Shell Env
SHELL_NAME="shell_example.sh"
SHELL_DIR="/server/scripts"
SHELL_LOG="${SHELL_DIR}/${SHELL_NAME}.log"

# Write Log
shell_log() {
    LOG_INFO=$1
    echo "$(date "+%Y-%m-%d") $(date "+%H-%M-%S") : ${SHELL_NAME} : ${LOG_INFO}" >> ${SHELL_LOG}
}

# Shell Usage
shell_usage(){
    echo $"Usage: $0 {backup}"
}

# Backup MySQL ALL Datebase with mysqldump or innobackupex
mysql_backup(){
    shell_log "mysql backup start"
    sehll_log "mysql backup stop"
}

# Main Function
main(){
   case $1 in 
	backup)
  	   mysql_backup
	   ;;
	*)
	   shell_usage;
   esac
}

#!/bin/sh


# 注意此脚本不适合按天做增量备份
# --no-timestamp:
# 这个选项不创建一个时间戳的目录来存储备份
# --use-memory:
# 通过使用更多的内存，准备过程可以加快速度。它依赖于您的系统上的免费或可用RAM，默认为100MB。
# 一般来说，进程的内存越多越好。进程中使用的内存的数量可以由多个字节来指定:
# --compress:
# 压缩选项
# --compress-threads:
# 压缩线程
# --incremental-basedir:
# 增量备份的基础路径(上次备份路径)
# --incremental:
# 增量备份选项


BAK_PATH=/data/database_backup
CURRENT_DATE=$(date +%Y%m%d)
LOG_FILE="mysql_back_info_${CURRENT_DATE}.log"
LOG_DIR='/var/log/mysql_back'
USER='root'
PASS='root'
CONF_FILE='/etc/my.cnf'
#SOCK_FILE='/data/db/mysql/var/mysql.sock'
SOCK_FILE='/var/lib/mysql/mysql.sock'
#DATA_DIR='/data/db/mysql/var'
DATA_DIR='/var/lib/mysql'
BASE_DIR=${BAK_PATH}/${CURRENT_DATE}
SCRIPT_DIR='/root/scripts'
BINLOG_DIR='/data/db/mysql_binlog'
# BINLOG_BIN='/usr/local/lnmp/mysql/bin/mysqlbinlog'


if [ "$UID" -ne 0 ];then
    echo "You must run as root"
    exit
fi

if [ ! -d ${LOG_DIR} ];then
    mkdir -p ${LOG_DIR}
else
    :
fi

do_install(){
    yum install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm -y
    yum install percona-xtrabackup-24 -y
}


do_full_backup() {
    if [ ! -d ${BASE_DIR} ];then
        mkdir -p ${BASE_DIR}
    fi
    innobackupex \
    --defaults-file=${CONF_FILE} \
    --user=${USER} \
    --password=${PASS} \
    --use-memory=4G \
    --compress \
    --compress-threads=4 \
    -S ${SOCK_FILE} \
    ${BASE_DIR} >> ${LOG_DIR}/${LOG_FILE} 2>&1

    num=$?
    if [ "$num" -eq 0 ];then
        echo "full backup OK."
    else
        echo "full backup FAIL"
        exit ${num}
    fi

    do_write_file
}

do_write_file(){
    if [ ! -d ${SCRIPT_DIR}/${CURRENT_DATE} ];then
        mkdir -p ${SCRIPT_DIR}/${CURRENT_DATE}
    fi

    ls -rt1 ${BASE_DIR} | tail -n 1 > ${SCRIPT_DIR}/${CURRENT_DATE}/back.lock
}


do_read_file() {
    echo $(cat ${SCRIPT_DIR}/${CURRENT_DATE}/back.lock)
}

do_inc_backup(){
    LAST_BACKUP_DIR=`do_read_file`
    if [ -z ${LAST_BACKUP_DIR} ];then
        echo "Not found last_backup_dir.data file"
        exit 1
    else
        innobackupex \
        --defaults-file=${CONF_FILE} \
        --user=${USER} \
        --password=${PASS} \
        -S ${SOCK_FILE} \
        --use-memory=4G \
        --compress \
        --compress-threads=4 \
        --incremental-basedir=${BASE_DIR}/${LAST_BACKUP_DIR} \
        --incremental \
        ${BASE_DIR} >> ${LOG_DIR}/${LOG_FILE} 2>&1

        num="$?"
        if [ "${num}" -eq 0 ];then
            echo "INC backup Success."
            do_write_file
        else
            echo "INC backup Failed."
            exit ${num}
        fi
    fi
}


do_write_list(){
    if [ -d ${BAK_PATH}/$1 ]; then
        if test -f ${SCRIPT_DIR}/list.lock;then
            echo "list.lock存在" >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
            exit 1
        fi

        ls -tr1  ${BAK_PATH}/$1 > ${SCRIPT_DIR}/list.lock
    else
        exit 1
    fi
}

do_merge_backup(){
    RECOVERY_INC_DIR=$1
    SUB_BACKUP_DIR=$2
    END_NR_NUM=$(grep -n "$RECOVERY_INC_DIR" ${SCRIPT_DIR}/list.lock | awk -F':' '{print $1}')
    if [ -f ${SCRIPT_DIR}/list.lock ];then
        for ((counter=1; counter<=${END_NR_NUM}; ++counter))
        do
            DIR_NAME=$(cat ${SCRIPT_DIR}/list.lock | awk 'NR=="'${counter}'"{print}')
            if [ ${counter} -eq 1 ];then
            # 取回全量备份
                innobackupex \
                --decompress \
                --parallel=4 \
                ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
                find  ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} -name "*.qp" -delete
                innobackupex \
                --apply-log \
                --redo-only \
                --use-memory=4G \
                ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
                # 定义全量备份目录变量
                FULL_BACKUP_DIR=${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME}
            elif [ ${counter} -eq ${END_NR_NUM} ];then
            # 合并最后一个增量，不需要--redo-only参数
                innobackupex \
                --decompress \
                --parallel=4 \
                ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
                find ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} -name "*.qp" -delete
                innobackupex \
                --apply-log \
                --use-memory=4G \
                ${FULL_BACKUP_DIR} \
                --incremental-dir=${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
            else
            # 合并非全量备份和非最后一次的增量备份
                innobackupex \
                --decompress \
                --parallel=4 \
                ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
                find ${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} -name "*.qp" -delete
                innobackupex \
                --apply-log \
                --use-memory=4G \
                --redo-only \
                ${FULL_BACKUP_DIR} \
                --incremental-dir=${BAK_PATH}/${SUB_BACKUP_DIR}/${DIR_NAME} \
                >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
            fi
        done
    fi
}

do_packaging_backup(){
    innobackupex \
    --defaults-file=${CONF_FILE} \
    --user=${USER} \
    --password=${PASS} \
    -S ${SOCK_FILE} \
    --stream=tar ./ | gzip -> ${BAK_PATH}/${CURRENT_DATE}_all.tar.gz
}

do_recovery(){
    SUB_BACKUP_DIR=$1
    RECOVERY_INC_DIR=$2
    do_merge_backup ${RECOVERY_INC_DIR} ${SUB_BACKUP_DIR}
    if [ "$?" -eq 0 ];then
        echo "Merge SUCC"
    else
        echo "Merge FAIL"
        exit 1
    fi
    # 关闭mysql服务
    service mysqld stop
    # 获取全量备份目录
    FULL_BACKUP_DIR=$(cat ${SCRIPT_DIR}/list.lock | awk 'NR==1{print}')
    # 回滚所有未提交的事务
    innobackupex \
    --apply-log \
    ${BAK_PATH}/${SUB_BACKUP_DIR}/${FULL_BACKUP_DIR} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1

    if [ $? -eq 0 ];then
        echo "开始回滚所有未提交的事务" >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
    else
        echo -e "开始回滚所有未提交的事务失败，请尝试手动执行命令: \ninnobackupex --apply-log ${BAK_PATH}/${SUB_BACKUP_DIR}/${FULL_BACKUP_DIR}" >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
        exit 1
    fi

    if test -d ${DATA_DIR}; then
        echo -e "${DATA_DIR}目录存在, 在回写时会失败，这里先退出，请手动删除数据目录并手动执行: \ninnobackupex --copy-back ${BAK_PATH}/${SUB_BACKUP_DIR}/${FULL_BACKUP_DIR}" >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
        exit 1
    fi
    # 拷回数据至数据目录
    innobackupex \
    --copy-back \
    ${BAK_PATH}/${SUB_BACKUP_DIR}/${FULL_BACKUP_DIR} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1

    if [ $? -eq 0 ];then
        chown -R mysql.mysql ${DATA_DIR}
        service mysqld start
    else
        exit 1
    fi
}

do_replay_binlog(){
    SUB_BACKUP_DIR=$1
    STOP_TIME=$2
    RECOVERY_INC_DIR=$3
    RECOVERY_NEX_DIR=$4
    RECOVERY_DAY=$5
    STOP_DATETIME="${RECOVERY_DAY} ${STOP_TIME}"

    if test -f ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_INC_DIR}/xtrabackup_binlog_info; then
         begin_file=$(cat ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_INC_DIR}/xtrabackup_binlog_info | awk '{print $1}')
         begin_position=$(cat ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_INC_DIR}/xtrabackup_binlog_info | awk '{print $2}')
     else
         exit 1
     fi

    if [ ! -z ${RECOVERY_NEX_DIR} ];then
        if test -f  ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_NEX_DIR}/xtrabackup_binlog_info.qp;then
            innobackupex \
            --decompress \
            --parallel=4 \
            ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_NEX_DIR} >> ${LOG_DIR}/recovery_info_${CURRENT_DATE}.log 2>&1
            find ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_NEX_DIR} -name "*.qp" -delete
        fi
        end_file=$(cat ${BAK_PATH}/${SUB_BACKUP_DIR}/${RECOVERY_NEX_DIR}/xtrabackup_binlog_info | awk '{print $1}')
    else
        end_file=${begin_file}
    fi
    mysqlbinlog ${BINLOG_DIR}/${begin_file} \
                ${BINLOG_DIR}/${end_file} \
                --start-position=${begin_position} \
                --stop-datetime="${STOP_DATETIME}"| mysql -uroot -p

    if [ "$?" -eq 0 ];then
        echo "recovery Success"
    else
        echo "recovery Failed."
        exit 1
    fi
}

do_recovery_main(){
    read -p "请准备好数据库管理员密码，后面要用到，这里请输入时间[2018-02-23 17-10-10]: " RECOVERY_DAY RECOVERY_TIME
    STOP_TIME=$(echo ${RECOVERY_TIME} | awk '{gsub("-", ":");print $1$2$3}')
    SUB_BACKUP_DIR=$(echo ${RECOVERY_DAY} | awk -F '-' '{print $1$2$3}')
    RECOVERY_H=$(echo ${RECOVERY_TIME} | awk -F'-' '{print $1}')
    RECOVERY_M=$(echo ${RECOVERY_TIME} | awk -F'-' '{print $2}')
    # 这里需要注意一下，这里方便测试备份时间间隔精确至分钟，如果增量按时备份，请在此处作相应修改, 比如按小时备份:
    # REGEX_STRING=${RECOVERY_DAY}_${RECOVERY_H}-[0-5][0-9]-[0-5][0-9]
    REGEX_STRING=${RECOVERY_DAY}_${RECOVERY_H}-${RECOVERY_M:0:1}[0-9]
    do_write_list ${SUB_BACKUP_DIR}
    RECOVERY_INC_DIR=$(cat ${SCRIPT_DIR}/list.lock | awk '/'${REGEX_STRING}'/ {print}')
    RECOVERY_NEX_DIR=$(cat ${SCRIPT_DIR}/list.lock | awk '/'${REGEX_STRING}'/ {nr[NR+1]; next};NR in nr')
    do_recovery ${SUB_BACKUP_DIR} ${RECOVERY_INC_DIR}
    while :
    do
        checkPidExists
        num=$?
        if [ ${num} -eq 0 ];then
            break
        fi
    done

    do_replay_binlog ${SUB_BACKUP_DIR} ${STOP_TIME} ${RECOVERY_INC_DIR} ${RECOVERY_NEX_DIR} ${RECOVERY_DAY}
    if [ $? -eq 0 ];then
        rm -rf ${SCRIPT_DIR}/list.lock
    fi
}

checkPidExists() {
    if [ -z `pidof mysqld` ];then
        return 1
    else
        return 0
    fi
}

case $1 in
    full)
    do_full_backup
    ;;
    inc)
    do_inc_backup
    ;;
    install)
    do_install
    ;;
    packaging)
    do_packaging_backup
    ;;
    recovery)
    do_recovery_main
    ;;
    *)
    echo "Usage: $0 <params: [full|inc|recovery|packaging]>"
    echo
    echo "full: 全量备份"
    echo "inc: 增量备份"
    echo "recovery: 恢复备份"
    echo "packaging: 打包备份"
    echo
    ;;
esac


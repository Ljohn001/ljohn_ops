#!/usr/bin/env bash


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
BAK_DAY=$(date +%Y%m%d)
LOG_FILE="mysql_back_info_${BAK_DAY}.log"
LOG_DIR='/var/log/mysql_back'
USER='bkpuser'
PASS='OLidp2L5fOW2I1sm'
CONF_FILE='/etc/my.cnf'
SOCK_FILE='/data/db/mysql/var/mysql.sock'
DATA_DIR='/data/db/mysql/var'
BASE_DIR=${BAK_PATH}/${BAK_DAY}
SCRIPT_DIR='/root/scripts'


if [ "$UID" -ne 0 ];then
	echo "You must run as root"
	exit
fi

if [ ! -d ${LOG_DIR} ];then
    mkdir -p ${LOG_DIR}
else
    :
fi

if [ ! -d ${BASE_DIR} ];then
    mkdir -p ${BASE_DIR}
fi

do_install_repo(){
    yum install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm -y
    yum install percona-xtrabackup-24 -y
}


do_full_backup() {
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
    if [ ! -d ${SCRIPT_DIR}/${BAK_DAY} ];then
        mkdir -p ${SCRIPT_DIR}/${BAK_DAY}
    fi

    ls -rt1 ${BASE_DIR} | tail -n 1 > ${SCRIPT_DIR}/${BAK_DAY}/back.lock
}


do_read_file() {
    echo $(cat ${SCRIPT_DIR}/${BAK_DAY}/back.lock)
}

do_inc_backup(){
    LAST_BACKUP_DIR=`do_read_file`
    echo ${LAST_BACKUP_DIR}
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
        ls -tr1  ${BAK_PATH}/$1 > ${SCRIPT_DIR}/list.lock
    else
        exit 1
    fi
}

do_merge_backup(){
    recovery_time=$1
    recovery_date=$2
    end_line_number=$(grep -n "$recovery_time" list.lock | awk -F':' '{print $1}')
    echo ${end_line_number}
    if [ -f ${SCRIPT_DIR}/list.lock ];then
        for ((counter=1; counter<=${end_line_number}; ++counter))
        do
            dir_name=$(cat ./list.lock | awk 'NR=="'${counter}'"{print}')
            if [ ${counter} -eq 1 ];then
                innobackupex \
                --decompress \
                --parallel=4 \
                ${BAK_PATH}/${recovery_date}/${dir_name}
                find  ${BAK_PATH}/${recovery_date}/${dir_name} -name "*.qp" -delete
                innobackupex \
                --apply-log \
                --redo-only \
                --use-memory=4G \
                ${BAK_PATH}/${recovery_date}/${dir_name}
                full_backup_dir=${BAK_PATH}/${recovery_date}/${dir_name}
                echo ${full_backup_dir}
            elif [ ${counter} -eq ${end_line_number} ];then
                innobackupex \
                --decompress \
                --parallel=4 \
                ${BAK_PATH}/${recovery_date}/${dir_name}
                find ${BAK_PATH}/${recovery_date}/${dir_name} -name "*.qp" -delete
                innobackupex \
                --apply-log \
                --use-memory=4G \
                ${full_backup_dir} \
                --incremental-dir=${BAK_PATH}/${recovery_date}/${dir_name}
            else
                innobackupex \
                --decompress \
                --parallel=4 \
                ${BAK_PATH}/${recovery_date}/${dir_name}
                find ${BAK_PATH}/${recovery_date}/${dir_name} -name "*.qp" -delete
                innobackupex \
                --apply-log \
                --use-memory=4G \
                --redo-only \
                ${full_backup_dir} \
                --incremental-dir=${BAK_PATH}/${recovery_date}/${dir_name}
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
    --stream=tar ./ | gzip -> ${BAK_PATH}/${BAK_DAY}_all.tar.gz
}

do_recovery(){
    read -p "输入日期[2018-02-23 17-00-00]: "
    recovery_time=$REPLY
    recovery_date=$(echo ${recovery_time} | awk -F '[-," "]' '{print $1$2$3}')
    recovery_datetime=$(echo ${recovery_time} | awk '{gsub(" ","_"); print $1$2}')
    # echo ${recovery_date}
    # echo ${recovery_datetime}
    do_write_list ${recovery_date}
    do_merge_backup ${recovery_datetime} ${recovery_date}
    service mysqld stop
    dir_name=$(cat ${SCRIPT_DIR}/list.lock | awk 'NR==1{print}')
    innobackupex \
    --copy-back \
    ${BAK_PATH}/${recovery_date}/${dir_name}
    if [ $? -eq 0 ];then
        chown -R mysql.mysql ${DATA_DIR}
        service mysqld start
    else
        exit 1
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
    do_install_repo
    ;;
    # merge)
    # do_merge_backup
    # ;;
    # list)
    # do_write_list
    # ;;
    packaging)
    do_packaging_backup
    ;;
    recovery)
    do_recovery
    ;;
    *)
    echo "Usage: $0 <params: [full, incremental, zip]>"
    echo
    echo "参数: full, inc, recovery, packaging"
    echo "full: 全量备份"
    echo "inc: 增量备份"
    echo "recovery: 恢复备份"
    echo "packaging: 打包备份"
    echo
    ;;
esac

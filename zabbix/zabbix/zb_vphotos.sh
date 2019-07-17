#!/bin/bash
#check os
#check network
#check app
#check srv


if [ $# -lt 1 ];then
	echo "error!"
	exit 1
fi


#check nginx status
ngxstatus(){
	curl -s -x 127.0.0.1:80  http://ngxstatus.vphotos.cn/ngx_status|tr '\n' ' '
}

#report free disk
freedisk(){
	[ -d $1 ]&&exit 1
	df ${1:-/} |tail -n 1|awk '{print $4}'
	}

#检查sshfs进程是否在执行
sshfs(){
        N=$(pgrep -f /opt/sshfs/lib/file.jar |wc -l)
        if [ $N -eq 1 ];then
                echo 0
        else
                echo 1
        fi

}

#返回进程数量
numberofprocess(){
	pgrep -a -f "${1:-vphotos}"|grep -v -e zb_vphotos|wc -l
}

#获取rsync列表

getrsynclist(){
	if [ $# -eq 0 ];then
		echo 255
		exit 1
	fi

	ping -c 3 -i 0.2 $1 >/dev/null 2>&1
	if [ $? -ne 0 ];then
		echo 254
		exit 1
	fi
	rsync ${1}:: >/dev/null 2>&1
	echo $?
}

getfreedisk(){
	if [ !  -d $1 ];then
		echo -1
		exit 1
	fi

	df $1 |tail -n 1|awk '{print $4}'
}
$@
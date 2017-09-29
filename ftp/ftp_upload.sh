#!/bin/bash
#
## 从linux服务器批量上传/var/log/polling文件夹里面文件到FTP(192.168.1.99)里面/jishu/liujian/polling目录

updir=/var/log/polling
todir=/jishu/liujian/polling
ip=192.168.1.99
user=ljohn1
password=ljohn
sss=`find $updir -type d -printf $todir/'%P\n'| awk '{if ($0 == "")next;print "mkdir " $0}'`
aaa=`find $updir -type f -printf 'put %p %P \n'`
ftp -nv $ip <<EOF 
user $user $password
type binary 
passive
prompt 
$sss 
cd $todir 
$aaa 
quit 
EOF

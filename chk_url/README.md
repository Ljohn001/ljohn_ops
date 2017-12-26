#### 应用场景：
>在企业运维工作中，每一步操作完毕后都应该进行快速有效的检查，这是一名合格运维人员的良好习惯。在我们变更，nginx配置重启（包含reload），要会通过调用脚本获取header信息或模拟用户访问URL来自动检查Nginx的启动是否正常。最大限度的保证服务重启后，能够偶快速确定网站情况，而无需手工敲命令查看。这样如果有问题，快速回退上一版本的配置文件（配置前已做备份）。

#### 脚本内容：

```
cat chk_curl.sh
#!/bin/bash
#
#===============================
# Description:  check url status
# Author: Ljohn
# Mail: ljohnmail@foxmail.com
# Last Update: 2017.12.26
# Version: 1.0
#===============================

[ -f /etc/init.d/functions ] && . /etc/init.d/functions

#chek url status
array=(
http://baidu.com
http://qq.com
http://taobao.com
)

curl_ip() {
  CURL=$(curl -o /dev/null -s --connect-timeout 5 -w '%{http_code}' $1|egrep "200|302"|wc -l)
  return $CURL
}

main() {
   for n in ${array[*]}
   do 
      curl_ip $n
      if [ $? -eq 1 ];then
         action "curl $n" /bin/true
      else
         action "curl $n" /bin/false
           CURL=$(curl_ip $n|egrep "200|302"|wc -l)
           if [ $CURL -eq 1 ];then
              action "Retry curl $n again" /bin/true
           else
              action "Retry curl $n again" /bin/false
          fi 
      fi
   done
} 
main
```

#### 运行脚本：
在使用前，将需要检查的URL贴到array 数组中来。

```
例如：将百度腾讯阿里网站URL，放置到属组array
array=(
http://baidu.com
http://qq.com
http://taobao.com
)
# chmod +x chk_curl.sh
# sh chk_curl.sh
```

```
执行结果如下：
[root@localhost scripts]# sh chk_curl.sh
curl http://baidu.com                                      [  OK  ]
curl http://qq.com                                         [  OK  ]
curl http://taobao.com                                     [  OK  ]

```


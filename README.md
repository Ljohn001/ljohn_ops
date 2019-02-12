## ljohn_ops
### 常用的脚本集合
集合中包含各种服务的创建，性能测试，日常巡检等；脚本大部分是自己工作中编写使用(经过严格测试)，还包含一些运维大鸟写的脚本修改而来。
#### 脚本列表

更新内容 |描述| 最后更新时间
---|---|---|
docker 	|  docker
ssh       | configure_ssh_without_pass 免秘钥处理	 | 2018.04.26
win_bash  | win批处理oracle备份脚本       |2018.03.26
logrotate | 日志切割,nginx,php等模板,nohup_split 等脚本   | 2018.02.24
zabbix  | redis 监控       |2018.02.01
backup  |文件目录备份，日志备份 | 2018.01.09
mysql  |mysql备份及重设root用户密码,innobackupex_scripts| 2018.02.24
chk_url  |网站url 检查脚本         | 2017.12.26
process-monitor | 进程监控脚本    | 2018.02.01
cobbler  |Cobbler无人值守，自动化部署系统 | 2017.11.28
polling  |轮询巡检脚本          |  2018.02.07
shells   |常用小脚本集合          |  2017.10.28
chkhosts |主机ping 检测脚本         | 2017.09.28
disk     |自动磁盘分区scripts          | 2017.09.28
ftp      |FTP Upload/Download          | 2017.09.28
linux-init|linux 最小化安装初始化及服务器SysV Init scripts        | 2017.09.28
lnmp     |lnmp scripts          |  2017.10.28
network  |网络配置,centos7 返回eth0 接口名，双网卡绑定        |  2018.1.10
redis    |redis 部署脚本          |  2017.09.28
vpn      |openvpn/pptp scripts          |  2017.9.25|
#### 使用场景
如何在运维重复的劳动中解脱出来？如何才能提高运维的效率？如何实现喝个茶时间，服务就能上线？
##### 举个栗子：
A(开发Dev)：帮我部署个服务nginx,apache,redis....

B（运维Ops）: 好的，然后登陆机器，不停的敲打键盘，10分钟甚至30分钟部署完。

C(运维Ops)：
只要登陆机器，一条命令执行：
```
curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/redis/redis3.x.sh|sh -
```
出去泡个茶，回来服务部署好了。


#### 下载使用
1、项目Git 下载：

git clone https://github.com/Ljohn001/ljohn_ops.git

2、单独下载某一个脚本。

wget  URL
curl -O URL

##### 示例：
```
# wget http://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/redis/redis3.x.sh
# curl -O  https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/redis/redis3.x.sh
```

#### curl 远程执行脚本：
```
curl -sSL https://XXXXXXX.sh |sh -
-s, --silent
              Silent or quiet mode. Don't show progress meter or error messages.  Makes Curl mute.
S, --show-error	
When used with -s it makes curl show an error message if it fails.
-L, --location
```
##### 示例：
系统:CentOS5/6/7/RHEL5/6/7

1.查看Linux系统基本信息（CPU，内存，磁盘，网络）
```
# curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/shells/system_info_colour.sh|sh -
```

2.自动安装redis3.x
```
# curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/redis/redis3.x.sh|sh -
```

3.自动磁盘分区（添加磁盘后执行如下命令）
```
# curl -sSL  https://github.com/Ljohn001/ljohn_ops/blob/master/disk/auto_disk.sh|sh -
```

4.一键测试（服务器性能[IO/Disk/Network/CPU]）

原项目github地址：
https://github.com/teddysun/across/blob/master/bench.sh

使用方法：https://teddysun.com/444.html
```
# curl -Lso- https://raw.githubusercontent.com/Ljohn001/across/master/bench.sh |bash

或者

# curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/shells/system_chk.sh|sh

```

5.安装YUM源

```
#支持CentOS5/6/7
# curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/shells/repo.sh|sh -
```

6.配置环境变量
```
# curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/shells/ljohn.sh |sh -
```

7.简单磁盘IO测试
```
#IO 测试三次，并显示平均值。
#curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/shells/io_test.sh |sh
```

8.Linux 最小化安装初始化系统
```
#CentOS6.x下执行：
#curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/centos6_init.sh|sh -

#CentOS7.x下执行：
#curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/centos7_init.sh|sh -

```

欢迎大家来批评指正，联系方式

QQ：184694637

Mail: ljohnmail@foxmail.com

Blog：http://blog.51cto.com/ljohn

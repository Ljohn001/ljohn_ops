## 1.centos6 init shell 
> 该脚本对CentOS6.x 最小化安装后进行的一些优化处理，作为Linux运维人员必备的技能。

***脚本初始化设置如下：***
```
#0.set_hostname # 主机名设置
#1.add_users_config
#2.sudoer_config
#3.limits_config
#4.sysctl_config
#5.history_config
#6.pass_length
#7.disable_selinux_config
#8.ntp_config
#9.maxlogins_config
#10.disbled_ipv6_config
#11.character_config 
#12.disable_service_config
#13.DNS config
#14.sshd_config 
#15.yum resource config
```


***使用说明:***
```bash
方式一：远程执行
curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/centos6_init.sh|sh -

方式二：下载并执行
curl -O https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/centos6_init.sh
或 wget https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/centos6_init.sh
chmod +x centos6_init_shell.sh
./centos6_init_shell.sh node1
node1 为所设置的主机名,也可以留空保持默认

执行完重启系统“reboot”
当前目录生成一个脚本执行后的日志"system_init_2017_07_12:01_49_25.log"
根据日志可以看到脚本各个部分执行完成情况
enjoy it !
```

## 2.centos7 init shell
***使用说明：***
```
#远程执行
curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/centos7_init.sh|sh -
```

## 3.ubuntu16.04 init shell
***使用说明：***
```
#远程执行
curl -sSL https://raw.githubusercontent.com/Ljohn001/ljohn_ops/master/linux-init/ubuntu16.04_init.sh|sh -


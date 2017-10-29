# CentOS6.x_Init_Shell
# 该脚本对CentOS6.x 最小化安装后进行的一些优化处理
***用说明:***
```bash
chmod +x centos6_init_shell.sh
./centos6_init_shell.sh
执行完重启系统“reboot”
当前目录生成一个脚本执行后的日志"system_init_2017_07_12:01_49_25.log"，内容如下：
2017_07_12:01_49_25 [1.del_user_group_config] is [success]
2017_07_12:01_49_25 [2.add_users_config] Ljohn is added [success]
2017_07_12:01_49_25 [3.sudoer_config] is [success]
2017_07_12:01_49_25 [4.limits_config] is [success]
2017_07_12:01_49_25 [5.sysctl_config] is [success]
2017_07_12:01_49_25 [6.history_config] is [success]
2017_07_12:01_49_25 [7.pass_length and login count limit] is [success]
2017_07_12:01_49_25 [8.disable_selinux_config] is [success]
2017_07_12:01_49_25 [9.ntp_config] is [success]
2017_07_12:01_49_25 [10.maxlogins_config] is [success]
2017_07_12:01_49_25 [11.disble_ipv6_config] is [success]
2017_07_12:01_49_25 [12.character_config] is [sucess]
2017_07_12:01_49_25 [13.disable_service_config] is [success]
2017_07_12:01_49_25 [14.DNS config] is [success]
2017_07_12:01_49_25 [15.sshd_config] is [success]
2017_07_12:01_49_25 [16.yum resource config] is [success]
2017_07_12:01_49_25 [17.small function] is [success] 

```

# 根据日志可以看到脚本各个部分执行完成情况

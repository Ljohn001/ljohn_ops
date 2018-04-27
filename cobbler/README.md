## 一键部署Cobbler服务器
### 简介
Cobbler是红帽（RedHat）2008年发布的一款自动化操作系统部署的实现工具，由Python语言开发，是对PXE的二次封装。融合多种特性，提供了CLI和Web的管理形式。同时，Cobbler也提供了API接口，方便二次开发使用。它不仅可以安装物理机，同时也支持kvm、xen虚拟化、的安装。另外，它还能结合Puppet等集中化管理软件，实现自动化管理，同时还可以管理DHCP，DNS，以及yum包镜像。
### 下载项目

参照方法：https://github.com/Ljohn001/Ansible-roles/blob/master/README.md
### Cobbler安装部署
1. 修改服务端IP，和DHCP IP
```
vim cobbler.sh
server_ip=192.168.137.38
dhcp_ip=192.168.137

根据自己的服务端IP修改。
```
2. 执行安装
```
chmod +x cobbler.sh
./cobbler.sh

这里坐等安装成功即可，网络够好20分钟即可

```
3、检查服务并同步cobbler配置
```
#重启服务
#/etc/init.d/cobbler restart 
Stopping httpd:                                            [  OK  ]
Starting httpd:                                            [  OK  ]
Stopping xinetd:                                           [  OK  ]
Starting xinetd:                                           [  OK  ]
Shutting down dhcpd:                                       [  OK  ]
Starting dhcpd:                                            [  OK  ]
Stopping cobbler daemon:                                   [  OK  ]
Starting cobbler daemon:                                   [  OK  ]
# 检查cobbler 并同步配置到dhcp pxe和数据目录
#cobbler sync && cobbler check
#cobbler sync && cobbler check
task started: 2017-11-28_002627_sync
task started (id=Sync, time=Tue Nov 28 00:26:27 2017)
running pre-sync triggers
cleaning trees
removing: /var/www/cobbler/images/CentOS-6.8-x86_64
removing: /var/lib/tftpboot/pxelinux.cfg/default
removing: /var/lib/tftpboot/grub/grub-x86.efi
removing: /var/lib/tftpboot/grub/images
removing: /var/lib/tftpboot/grub/efidefault
removing: /var/lib/tftpboot/grub/grub-x86_64.efi
removing: /var/lib/tftpboot/images/CentOS-6.8-x86_64
removing: /var/lib/tftpboot/s390x/profile_list
copying bootloaders
trying hardlink /var/lib/cobbler/loaders/grub-x86.efi -> /var/lib/tftpboot/grub/grub-x86.efi
trying hardlink /var/lib/cobbler/loaders/grub-x86_64.efi -> /var/lib/tftpboot/grub/grub-x86_64.efi
copying distros to tftpboot
copying files for distro: CentOS-6.8-x86_64
trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.8-x86_64/images/pxeboot/vmlinuz -> /var/lib/tftpboot/images/CentOS-6.8-x86_64/vmlinuz
trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.8-x86_64/images/pxeboot/initrd.img -> /var/lib/tftpboot/images/CentOS-6.8-x86_64/initrd.img
copying images
generating PXE configuration files
generating PXE menu structure
copying files for distro: CentOS-6.8-x86_64
trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.8-x86_64/images/pxeboot/vmlinuz -> /var/www/cobbler/images/CentOS-6.8-x86_64/vmlinuz
trying hardlink /var/www/cobbler/ks_mirror/CentOS-6.8-x86_64/images/pxeboot/initrd.img -> /var/www/cobbler/images/CentOS-6.8-x86_64/initrd.img
Writing template files for CentOS-6.8-x86_64
rendering DHCP files
generating /etc/dhcp/dhcpd.conf
rendering TFTPD files
generating /etc/xinetd.d/tftp
processing boot_files for distro: CentOS-6.8-x86_64
cleaning link caches
rendering Rsync files
running post-sync triggers
running python triggers from /var/lib/cobbler/triggers/sync/post/*
running python trigger cobbler.modules.sync_post_restart_services
running: dhcpd -t -q
received on stdout: 
received on stderr: 
running: service dhcpd restart
received on stdout: Shutting down dhcpd: [  OK  ]
Starting dhcpd: [  OK  ]

received on stderr: 
running shell triggers from /var/lib/cobbler/triggers/sync/post/*
running python triggers from /var/lib/cobbler/triggers/change/*
running python trigger cobbler.modules.scm_track
running shell triggers from /var/lib/cobbler/triggers/change/*
*** TASK COMPLETE ***
The following are potential configuration items that you may want to fix:

1 : file /etc/xinetd.d/rsync does not exist

Restart cobblerd and then run 'cobbler sync' to apply changes.

###错误1：file /etc/xinetd.d/rsync does not exist
可以忽略

```

#### 详细配置配置说明见我个人博客
http://blog.51cto.com/ljohn/2045011




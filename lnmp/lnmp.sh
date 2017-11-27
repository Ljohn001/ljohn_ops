!/bin/bash
#
nginx() {
echo "安装前环境准备..."
sleep 3
yum remove nginx mysql mariadb php -y
rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum groupinstall "Development Tools" "Development Libraries" -y
yum install openssl-devel \
ncurses-devel \
cmake \
pcre-devel \
libxml2-devel \
bzip2-devel \
libcurl-devel \
libmcrypt-devel -y

iptables -F
systemctl stop firewalld.service
systemctl disable firewalld.service
setenforce 0
sed -i '/^SELINUX\>/d' /etc/selinux/config
echo "SELINUX=disabled" >>/etc/selinux/config

echo "Install nginx..."
sleep 3

#编译安装nginx
id nginx &>/dev/null && userdel -r nginx
groupdel nginx
groupadd -r nginx
useradd -r -g nginx nginx
tar xf $PWD/nginx-1.10.3.tar.gz
cd nginx-1.10.3
./configure \
--prefix=$dir/nginx \
--sbin-path=$dir/nginx/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx/nginx.pid  \
--lock-path=/var/lock/nginx.lock \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_flv_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--http-client-body-temp-path=/var/tmp/nginx/client/ \
--http-proxy-temp-path=/var/tmp/nginx/proxy/ \
--http-fastcgi-temp-path=/var/tmp/nginx/fcgi/ \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/tmp/nginx/scgi \
--with-pcre
make && make install

mkdir -p /var/tmp/nginx/client

#添加对php的支持
sed -i '65,71s/^[[:space:]]\+#//g' /etc/nginx/nginx.conf
sed -i '45s/index.html/index.php index.html/g' /etc/nginx/nginx.conf
echo "fastcgi_param  SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;" >> /etc/nginx/fastcgi_params

#添加环境变量
echo "export PATH=$dir/nginx/sbin:$PATH" >/etc/profile.d/nginx.sh
source /etc/profile

nginx

#Nginx测试
if curl 127.0.0.1 &>/dev/null;then
    echo "Nginx is SUCCESS!"
else
    echo "Nginx is Failure!"
fi
}

mysql () {
echo "Install MySQL..."
sleep 3
#编译安装MySQL
id mysql &>/dev/null && userdel -r mysql
groupadd -r mysql
useradd -g mysql -r -s /sbin/nologin -M -d /mydata/data mysql
tar xf $PWD/mysql-5.5.58.tar.gz
cd $PWD/mysql-5.5.58
cmake \
-DCMAKE_INSTALL_PREFIX=$dir/mysql \
-DMYSQL_DATADIR=/mydata/data \
-DSYSCONFDIR=/etc \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DMYSQL_USER=mysql \
-DWITH_DEBUG=0 \
-DWITH_SSL=system
make && make install

#初始化数据库
cd $dir/mysql
chown -R root.mysql ./*
[ ! -d /mydata/data ] && mkdir -p /mydata/data
scripts/mysql_install_db --user=mysql --datadir=/mydata/data/

#修改MySQL参数文件
/usr/bin/cp support-files/my-large.cnf /etc/my.cnf
sed -i '/\[mysqld\]/a datadir= /mydata/data\ninnodb_file_per_table= ON\nskip_name_resolve= ON' /etc/my.cnf

#生成MySQL启动文件
/usr/bin/cp support-files/mysql.server /etc/rc.d/init.d/mysqld

ln -s $dir/mysql/include/ /usr/include/mysql
echo "$dir/mysql/lib/" >/etc/ld.so.conf.d/mysql.conf
ldconfig

#添加MySQL环境变量
echo "export PATH=$dir/mysql/bin:$PATH" >/etc/profile.d/mysql.sh
source /etc/profile

#启动MySQL
/etc/init.d/mysqld start

}

php () {
echo "Install PHP..."
sleep 3
tar xf $PWD/php-5.6.32.tar.bz2
cd $PWD/php-5.6.32
#打补丁，解决编译安装过程中的报错
curl -o php-5.x.x.patch https://mail.gnome.org/archives/xml/2012-August/txtbgxGXAvz4N.txt
patch -p0 -b < ./php-5.x.x.patch
./configure --prefix=$dir/php \
--with-mysql=$dir/mysql \
--with-openssl \
--enable-fpm \
--enable-sockets \
--enable-sysvshm \
--with-mysqli=$dir/mysql/bin/mysql_config \
--enable-mbstring \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib-dir \
--with-libxml-dir=/usr/include/libxml2/libxml \
--enable-xml \
--with-mhash \
--with-mcrypt \
--with-config-file-path=/etc \
--with-config-file-scan-dir=/etc/php.d \
--with-bz2 \
--with-curl 
make && make install

#生成php-fpm启动文件
/usr/bin/cp sapi/fpm/init.d.php-fpm /etc/rc.d/init.d/php-fpm 
chmod +x /etc/rc.d/init.d/php-fpm

#修改php参数文件
/usr/bin/cp $dir/php/etc/php-fpm.conf.default $dir/php/etc/php-fpm.conf
sed -i -e '/pm.max_children/d' -e \
'/\<pm.start_servers\>/d' -e \
'/\<pm.min_spare_servers\>/d' -e \
'/\<pm.max_spare_servers\>/d' -e \
'/pid = run\/php-fpm.pid/s/^;//g' $dir/php/etc/php-fpm.conf
cat >>$dir/php/etc/php-fpm.conf <<EOF
pm.max_children = 150
pm.start_servers = 8
pm.min_spare_servers = 5
pm.max_spare_servers = 10
EOF

/etc/init.d/php-fpm start
echo "php install SUCCESS！"
}

#主程序
main () {
PWD=$(pwd)
if [ ! -f $PWD/mysql-5.5.58.tar.gz ] || [ ! -f $PWD/nginx-1.10.3.tar.gz ] || [ ! -f $PWD/php-5.6.32.tar.bz2 ];then
    echo "请将安装文件与脚本放在同一目录下！"
    exit 1
fi

if [ $# -eq 0 ];then
    dir=/usr/local
elif [ $# -eq 1 ];then
    dir=$1
    if [ ! -d $dir ];then 
    mkdir -p $dir
    fi
else
    echo "The parameter is invalid,Please input again and rerun it！"
    exit 1
fi

nginx
mysql
php
}
main

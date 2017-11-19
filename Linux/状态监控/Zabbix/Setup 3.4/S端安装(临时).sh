#本脚本执行前需前安装：Nginx，Mysql，PHP-fpm

WEB_BASE_PATH="/var/www/html"

MYSQL_USERNAME="root"
MYSQL_PASSWORD="123456"

#基于之前的编译
yum -y install net-snmp net-snmp-devel perl-DBI php-gd php-xml php-bcmath fping OpenIPMI-devel php-mbstring php-fpm httpd
yum -y install httpd-devel mysql mysql-devel php-common php-devel php-xml net-snmp net-snmp-devel \
curl curl-devel libxml2 libxml2-devel ncurses-devel unixODBC* libssh2-devel libevent-devel java-1.7.0-openjdk-devel mariadb-server  

groupadd zabbix
useradd -g zabbix zabbix -s /sbin/nologin

systemctl enable mariadb
systemctl start  mariadb

mysql -e "grant all on *.* to ${MYSQL_USERNAME}@localhost identified by \"${MYSQL_PASSWORD}\"" 
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} -e "grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by 'zbpass';"
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} -e "grant all privileges on zabbix.* to 'zabbix'@'127.0.0.1' identified by 'zbpass';"
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} -e "flush privileges;"
        
#导入数据
tar -xf zabbix-3.4.4.tar.gz
cd zabbix-3.4.4 && zabbix_install_p=$(pwd)
cd database/mysql/
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} zabbix < ./schema.sql
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} zabbix < ./images.sql
mysql -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} zabbix < ./data.sql

#安装zabbix
cd $zabbix_install_p
./configure \
--prefix=/usr/local/zabbix_3.4 \
--enable-server \
--enable-proxy \
--enable-agent \
--with-libcurl \
--with-ssh2 \
--enable-java \
--with-net-snmp \
--with-mysql \
--enable-ipv6 \
--with-net-snmp \
--with-libcurl \
--with-libxml2 \
--with-unixodbc
make install

mkdir -p /usr/local/zabbix_3.4/AlertScripts
chown zabbix.zabbix -R /usr/local/zabbix_3.4/AlertScripts
cd /usr/local/zabbix_3.4/etc
#server
sed -i 's/# DBHost=.*/DBHost=localhost/g' zabbix_server.conf 
sed -i 's/^DBName=.*/DBName=zabbix/g' zabbix_server.conf
sed -i 's/^DBUser=.*/DBUser=zabbix/g' zabbix_server.conf
sed -i 's/# DBPassword=.*/DBPassword=zbpass/g' zabbix_server.conf
sed -i 's|# AlertScriptsPath=.*|AlertScriptsPath=/usr/local/zabbix_3.4/AlertScripts|g' zabbix_server.conf

#agent
sed -i "s/^Server=.*/Server=127.0.0.1/g" zabbix_agentd.conf
sed -i "s/^ServerActive=.*/Server=127.0.0.1/g" zabbix_agentd.conf
sed -i 's/^Hostname=.*/Hostname=Zabbix server/g' zabbix_agentd.conf

#php
sed -i 's/post_max_size = .*/post_max_size = 64M/g' /etc/php.ini  
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 50M/g' /etc/php.ini
sed -i 's|date.timezone = .*|date.timezone = Asia/Shanghai|g' /etc/php.ini
sed -i 's/max_execution_time = .*/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php.ini
sed -i 's/memory_limit = .*/memory_limit = 256M/g' /etc/php.ini
sed -i 's|;always_populate_raw_post_data = .*|always_populate_raw_post_data = -1|g' /etc/php.ini 

cd ${zabbix_install_p}/
cp misc/init.d/tru64/zabbix_server /etc/init.d/
cp misc/init.d/tru64/zabbix_agentd /etc/init.d/
chmod a+x /etc/init.d/zabbix_*

cp /usr/local/zabbix_3.4/sbin/{zabbix_agentd,zabbix_server} /usr/local/sbin

#启动
/etc/init.d/zabbix_server start
/etc/init.d/zabbix_agentd start

netstat -atupnl | grep "zabbix*"

x=`mktemp`
cat > $x <<'eof'
        index index.html index.htm;
        location ~ \.php$ {
            root /usr/local/nginx/html;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
eof
sed -i "/proxy the PHP scripts/r $x" /etc/nginx/nginx.conf
sed -i 's/index\.html/& index\.php/g' /etc/nginx/nginx.conf

#拷贝Web程序到Web根目录下
cp -rf frontends/php/* ${WEB_BASE_PATH}
chmod a+x  /usr/local/nginx/html/*.php

#reload
nginx -s reload

exit 0




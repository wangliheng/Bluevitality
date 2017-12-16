yum -y install epel-release gcc gcc-c++ cmake openssl openssl-devel net-tools vim


p=$(pwd)
tar -zxf tcl8.6.1-src.tar.gz 
cd tcl8.6.1/unix
./configure  --prefix=/usr/local/tcl-8.6.1
NUM=$( awk '/processor/{N++};END{print N}' /proc/cpuinfo )
if [ $NUM -gt 1 ];then
    make -j $NUM
else
    make
fi
make install



cd $p
tar -zxf redis-3.2.11.tar.gz  
cd redis-3.2.11
NUM=$( awk '/processor/{N++};END{print N}' /proc/cpuinfo )
if [ $NUM -gt 1 ];then
    make -j $NUM
else
    make
fi
make install








isExists=`grep 'vm.overcommit_memory' /etc/sysctl.conf | wc -l`
if [ "$isExists" != "1" ]; then
	echo "vm.overcommit_memory = 1">>/etc/sysctl.conf
	sysctl -p
fi

if [ ! -d /var/run/redis ]; then
	mkdir -m 0777 -p /var/run/redis
	chown -R redis:redis /var/run/redis
fi


# 修改配置文件
cp $redis/redis.conf .
sed -i 's/daemonize no/daemonize yes/' redis.conf
sed -i 's/pidfile .*/pidfile .\/redis.pid/' redis.conf

# 创建启动和停止文件
cat > start.sh << EOF
#!/bin/bash
./$redis/src/redis-server ./redis.conf
EOF
chmod +x start.sh


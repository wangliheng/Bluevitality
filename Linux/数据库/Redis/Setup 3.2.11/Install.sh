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

make PREFIX=/usr/local/redis install
#redis目录下会出现编译后的redis服务程序 redis-server 用于测试的客户端 redis-cli。位于安装目录：src

cd /usr/local/redis

mkdir /usr/local/redis/etc/ -p
cp redis.conf /usr/local/redis/etc/ 
cp /usr/local/redis/bin/{redis-benchmark,redis-cli,redis-server} /usr/bin/


#修改配置
sed -i 's/daemonize no/daemonize yes/' /usr/local/redis/etc/redis.conf
sed -i 's/pidfile .*/pidfile .\/redis.pid/' /usr/local/redis/etc/redis.conf

isExists=`grep 'vm.overcommit_memory' /etc/sysctl.conf | wc -l`
if [ "$isExists" != "1" ]; then
	echo "vm.overcommit_memory = 1">>/etc/sysctl.conf
	sysctl -p
fi

#启动
redis-server /usr/local/redis/etc/redis.conf

$ ./redis-server /etc/myredis.conf --loglevel verbose --port 7777   


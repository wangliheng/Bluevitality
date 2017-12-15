#### 特点
```txt
编译Redis时不需要configure，直接Make即可（将在当前的make目录生成可使用的src子目录）...
支持两种数据持久化，可将内存中数据保持在磁盘，重启的时可再次加载
不仅支持简单的key-value类型数据，同时还提供list，set，zset，hash等数据结构的存储...
支持数据的备份，即Master-Slave模式
一般读速度110000/s,写速度81000/s
Redis的所有操作都是原子性的，还支持对几个操作全并后的原子性执行
还支持 publish/subscribe, 通知, key过期等特性
```
#### 数据的两种持久化方式
```txt
1. Snapshotting ( 半持久化模式 )
    利用了快照的原理，使得数据以异步方式从内存中传输到磁盘中去，默认是个二进制文件："dump.rdb"
    在conf中格式是：save N M 表示在N秒之内至少发生M次修改则抓快照到磁盘。当然也可手动执行save或bgsave (异步)做快照
    
    例：
    save 900 1      #900秒内如果超过1个key被修改，则发起快照保存
    save 300 10     #300秒内容如超过10个key被修改，则发起快照保存

2. AOF ( 全持久化模式：append only file )
    把每次的写操作都直接附加在磁盘的现有文件后面
    Snapshotting方式在redis异常死掉时最近的数据会丢失（丢失数据的多少视save策略的配置）所以这是它最大的缺点
    当业务量很大时Snapshotting丢失的数据很多
    Append-only方法可以做到全部数据不丢失，但redis的性能就要差些（默认情况下AOF是关闭的）
    当redis重启时会读取AOF文件进行重放以恢复到关闭前的最后时刻
    
    AOF的文件刷新三种方式：
        appendfsync always      #每次提交都调用fsync刷新到AOF文件，非常慢但是非常安全
        appendfsync everysec    #每秒都调用fsync刷新到AOF文件，很快但可能会丢失一秒内的数据
        appendfsync no          #依靠OS进行刷新，redis不主动刷新AOF，这样最快但安全性最差
    
```
#### check
```txt
redis-check-dump    检测RDB备份文件
redis-check-aof     检测AOF备份文件
```
#### 部署
```bash
$ wget http://download.redis.io/releases/redis-2.8.17.tar.gz
$ tar xzf redis-2.8.17.tar.gz
$ cd redis-2.8.17
$ make   #redis-2.8.17目录下会出现编译后的redis服务程序redis-server 用于测试的客户端程序redis-cli。位于安装目录src下
#启动服务：
$ cd src
$ ./redis-server /etc/myredis.conf --loglevel verbose --port 7777    
#指定主服务器：--slaveof 127.0.0.1 8888     默认S端服务端口：6379

#isExists=`grep 'vm.overcommit_memory' /etc/sysctl.conf | wc -l`
#if [ "$isExists" != "1" ]; then
#	echo "vm.overcommit_memory = 1">>/etc/sysctl.conf
#	sysctl -p
#fi
```

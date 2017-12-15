#### 数据的两种持久化
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

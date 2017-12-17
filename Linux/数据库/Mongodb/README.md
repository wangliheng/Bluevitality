#### 备忘
```txt
在高负载的情况下添加更多的节点，可保证服务器性能，旨在为WEB应用提供可扩展的高性能数据存储解决方案
MongoDB将数据存储为一个文档，数据结构由键值 key:value 组成。MongoDB的文档类似于JSON对象。字段值可以包含其他文档
单个实例可容纳多个独立数据库，每个都有自己的集合和权限，不同的数据库也放置在不同的文件中
mongodb的默认数据库为"db"（存在data目录）单个实例可容纳多个独立数据库，每个都有自己的集合和权限，不同的库可放置在不同文件
mongodb使用js语法操作，在其集合中的每个文档都可有自己独特的结构，是树形结构数据库，而传统数据库关联复杂
其没有结构的限制，甚至可嵌套

保留库：
    admin：  从权限角度看是"root"。将用户添加到此库则其继承所有库权限。特定服务端命令只能从此库运行，如列所有库或关闭服务
    local：  存储仅限于本地单台服务器的任意集合 （永不被复制）
    config： 当用于分片设置时此库在内部使用（保存分片相关信息 ）

添加用户：	 db.addUser('name','pass','true/false'); #帐号密码以及是否只读（若要生效需启动时加入--auth选项）
删除用户：	 use dbname ; db.removeUser('username'); #若在adimin库中添加用户则是超级管理员权限
修改密码：	 use dbname ; db.changeUserPassword('username','passowrd');
入库认证：	 use dbname ; db.auth('username','passowrd');
```
#### mongoexport & mongoimport / 导出与导入
```txt
#导入/导出可以是本地也可以是远程服务器
#在本地执行导出远程mongodb服务器的数据：
    mongoexport：    mongoimport：
    -d	  库         -type [csv/json] #默认json
    -c	  集合       -file            #文件路径
    -f	  列名       -f	  	      #导入的数据存于哪些列
    -q	  条件       --headrline      #跳过第一行
    -o    导出名				
    --csv EXCEl

导出：mongoexport -d 库名 -c 集合 -f 列1，列2 -q '{name:{$lte:1000}}' -o ./dump.json
导入：mongoimport -d 库名 -c 集合 --type csv --headrline -f 列1，列2 --file ./dump.csv

二进制导出：mongodump -d 库 [-c 表] -f 列1,列2  #默认导出到mongo的dump目录（包括数据及索引信息）
二进制导入：mondorestore -d 库 --directoryperdb dump/库  #--directoryperdb指定备份的二进制文件所在路径
```
#### mongotop 命令
```bash
#可查看MongoDB实例花销在读或写上的时间，它提供集合级别的统计数据，而mongostat提供数据库级别的统计数据。默认每秒刷新/次

--help          显示帮助信息
--verbose,-v    详细模式，多个v越详细，如-vvv
--version       显示版本信息
--host          指定主机名
--port          指定端口
--username,-u   指定用户名
--password,-p   指定用户密码
--authenticationDatabase    指定用户凭证的库名
--authenticationMechanism   指定认证机制
--locks         根据每个库显示，而不是根据集合显示
<sleeptime>     刷新间隔时间

[root@localhost ~]# mongotop --port 28018  15       #ns即namespace，由库名和集合名构成  
connected to: 127.0.0.1:28018
                                           ns       total        read       write      2014-10-08T06:43:38
               game_server_jd23.player_message       198ms       138ms        60ms
              game_server_jd33.player_instance       173ms       125ms        48ms
              game_server_jd02.player_backpack       132ms       126ms        6ms
              game_server_jd03.player_backpack       117ms       115ms        2ms
                                local.oplog.rs       112ms       112ms        0ms
               game_server_jd02.player_message       103ms       103ms        0ms
              game_server_jd12.player_backpack        82ms        63ms        19ms
           game_server_jd678new.player_message        80ms        80ms        0ms
              game_server_jd22.player_backpack        68ms        66ms        2ms
```
#### mongostat 命令
```bash
#mongostat是mongdb自带的状态检测工具，其间隔固定时间获取mongodb当前运行状态。
#若发现数据库突然变慢或者有其他问题的话第一手操作就考虑采用mongostat来查看状态

inserts/s   每秒插入次数
query/s     每秒查询次数
update/s    每秒更新次数
delete/s    每秒删除次数
getmore/s   每秒执行getmore次数
command/s   每秒的命令数，比以上插入、查找、更新、删除的综合还多，还统计了别的命令
flushs/s    每秒执行fsync将数据写入硬盘的次数。
mapped/s    所有的被mmap的数据量，单位是MB，
vsize       虚拟内存使用量，单位MB
res         物理内存使用量，单位MB
faults/s    每秒访问失败数（只有Linux有），数据被交换出物理内存，放到swap。
            不要超过100，否则就是机器内存太小，造成频繁swap写入。此时要升级内存或者扩展
locked %    被锁的时间百分比，尽量控制在50%以下吧
idx miss %  索引不命中所占百分比。如果太高的话就要考虑索引是不是少了
q t|r|w     当Mongodb接收到太多的命令而数据库被锁住无法执行完成，它会将命令加入队列。
            这一栏显示了总共、读、写3个队列的长度，都为0的话表示mongo毫无压力。高并发时一般队列值会升高
conn        当前连接数
time        时间戳
```

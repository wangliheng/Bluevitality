#### 三个配置文件
```txt
haresources   定义集群资源，v1版使用，v2版兼容(v2版使用CRM)，v3版使用Pacemake...
ha.cf         集群成员之间的高可用及心跳设置
authkeys      成员认证
```
主备节点都需要安装Heartbeat软件...
依次安装libnet和heartbeat源码包，服务安装完毕后在备份节点使用`scp`把主节点配置文件传输到备份节点

[root@node2 ~]# `scp -r node1:/etc/ha.d/*  /etc/ha.d/`  
[root@node1 ~]# `/etc/init.d/heartbeat`  
Usage: /etc/init.d/heartbeat {start|stop|status|restart|reload|force-reload}   

#### 设置主备份节点的 NTP 同步
```
在双机高可用集群中，主/备节点的系统时间非常重要，因为节点间的状态监控都是通过设定时间实现的
主备节点间的系统时间相差在10s内是正常的，如果节点之间时间相差太大就有可能造成 HA 环境的故障
解决时间同步的办法有两个：
  一个办法是找一个时间服务器，两个节点通过 ntpdate 命令定时与时间服务器进行时间校准
  另一个办法是让集群中的主节点作为ntp时间服务器，让备份节点定时去主节点进行时间校验
```

#### Notice
- 所有的集群成员都需要 NTP 的时间同步
- 修改各集群成员主机名  
  /etc/sysconfig/network  
  hostnamectl set-hostname <HOST_NAME>  
- 修改各集群成员间的 /etc/hosts 将成员的主机名与地址做映射 eg: ~]# uname -n
- 必要时进行集群间 SSH 的公钥互信...

#### initiator 与 Target 间的交互
```txt
语法格式：
iscsiadm -m discovery [ -d debug_level ] [ -P printlevel ] [ -I iface -t type -p ip:port [ -l ] ]

在initiator端寻找target提供的信息：
iscsiadm -m discovery -t sendtargets -p 192.168.10.1:3260

在initiator端显示发现的target主机：   
iscsiadm -m node

在initiator端显示建立的target连接：  
iscsiadm -m session

在initiator端断开指定target的连接：   
iscsiadm -m node iqn.2013-09.com.inter.10.1:test-target  -u

在initiator端连接指定的target主机：   
iscsiadm -m node iqn.2013-09.com.inter.10.1:test-target  [-l/--login]

在initiator端退出所有登录的连接：     
iscsiadm -m node --logoutall=all
```
#### 关于验证（单向）
```txt
tgtadm常用于管理3类对象：
  target:    创建new，删除，查看
  lun：      创建，查看，删除
  account：  创建，绑定，解绑，删除，查看
  
在target端创建账号：                 
tgtadm --lld iscsi -m account -o new --user <username> --password <password>

在target端将账号绑定到指定的target：  
tgtadm --lld iscsi -m account -o bind --tid 1 --user <username>

在target端删除一个账号：             
tgtadm --lld iscsi -m account -o delete --user <username>
  
在target端创建一个target：
tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2013-05.com.xxxxx:tsan.disk1

显示所有target：
tgtadm --lld iscsi --op show --mode target

在initiator端命令方式连接/登录：       
iscsiadm -m node -T <target-name> -p <ip-address>:<port> --login

在initiator端命令方式验证登录：
iscsiadm -m node -T LUN_NAME -o update --name node.session.auth.authmethod --value=CHAP
iscsiadm -m node -T LUN_NAME -o update --name node.session.auth.username --value=<user>
iscsiadm -m node -T LUN_NAME -o update --name node.session.auth.password --value=<passwd>
  
```

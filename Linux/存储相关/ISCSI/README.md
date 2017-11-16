#### initiator 与 Target 间的交互
```txt
在initiator端显示发现的target主机： 	iscsiadm -m node
在initiator端显示已经建立的target连接： iscsiadm -m session
在initiator端断开与指定target的连接：	iscsiadm -m node iqn.2013-09.com.inter.10.1:test-target  -u
在initiator端连接指定target： 			iscsiadm -m node iqn.2013-09.com.inter.10.1:test-target  [-l/--login]
在initiator端退出所有登录的连接：		iscsiadm -m node --logoutall=all
```
####
```txt

```
####
```txt

```
####
```txt

```
####
```txt

```

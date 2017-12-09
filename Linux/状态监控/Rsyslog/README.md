#### 备忘
```txt
格式：		          服务名称[.=!]信息等级	日志位置
    .		        从指定等级开始
    =		        指定等级
    !		        排除等级
    
等级：
    info			基本信息
    notice		    除info外需注意信息
    warning(warn)	警告信息，可能有问题但还不至于影响到服务
    err(error)		错误信息
    crit			严重错误
    alert			严重警告
    emerg(panic)	崩溃状态
    *			    所有级别
```
#### 远程服务器接收日志
```bash
[root@localhost ~]# cat /etc/sysconfig/rsyslog    
# Options for rsyslogd
# Syslogd options are deprecated since rsyslog v3.
# If you want to use them, switch to compatibility mode 2 by "-c 2"
# See rsyslogd(8) for more details
SYSLOGD_OPTIONS="-m 0 -r"     #-r
```

#### 在主库上创建归档目录
```bash
mkdir -p /oradata/dg
#(若以root身份进行创建需要，修改归档目录的属主属组，让oracle:oinstall，拥有访问的权限)
chown oracle:oinstall /oradata/dg

su oracle
source /home/oracle/.bash_profile;
sqlplus / as sysdba
startup mount
#alter system set log_archive_Dest='/oradata/dg';
alter database archivelog

archive log list;

```
***
#### 从库只需要安装数据库软件，数据从主库传输后完成
```
备注：（若采用主库的克隆，则无需关心该步骤）
```
***
#### ADG备注说明
备注：所谓的ADG,只不过就是在备库，应用redo log 的同事，避免资源的浪费，（10g之前的dg备库必须处于Mount状态，才可以接收应用redo log）,11g增加的ＡＤＧ的功能支持，备库处于open状态（默认为read only模式），同时可以接收并应用redo log
***
#### 主从库硬件最好一致。oracle数据库版本需要一致
```bash
<1> 内存检查项：

 #grep MemTotal /proc/meminfo      

交换分区检查项：如果内存在1-2G,swap是1.5倍；2-16G,1倍；超过16G，设置为16G即可。     

# grep SwapTotal /proc/meminfo    

查看共享内存大小：    

 # df -h /dev/shm

 <2> 查看系统处理器架构，与oracle安装包一致     

# uname -m

 <3> 空间空间 /tmp必须大于1G     

# df -h /tmp

备注：本次操作过程中对于该目录并未有严格的要求

```
***
#### 配置环境数据库用户必须有sysdba权限 
***
#### 后面的环境：
主库 172.18.44.147 数据库实例名：orcl db_unique_name:dbprimary  
从库 172.18.44.26 数据库实例名：orcl db_unique_name:dbstandby
***
### 配置
#### 判断DG是否已经安装
```bash
sql>select * from v$option where parameter='Oracle Data Guard';   
#如果是true表示已经安装可以配置，否则需要安装相应组件。
```
#### 设置主库为强制记录日志 
```bash
<1> 强制记录日志：
   sql>alter database force logging;    

<2> 检查状态(YES为强制)：
   sql>select name,force_logging from v$database;  

<3> 如果需要在主库添加或者删除数据文件时，这些文件也会在备库添加或删除，使用如下：       
#默认此参数是manual手工方式
sql>alter system set standby_file_management='AUTO';      
sql>show parameter standby  
```
#### 创建standby log files(备用日志文件）
```bash
alter database add standby logfile group 4 ('/oradata/dg/redo_dg_021.log') size 50M;
alter database add standby logfile group 5 ('/oradata/dg/redo_dg_022.log') size 50M;
alter database add standby logfile group 6 ('/oradata/dg/redo_dg_023.log') size 50M;
alter database add standby logfile group 7 ('/oradata/dg/redo_dg_024.log') size 50M;
```
#### 参数设置
```bash
alter system set db_unique_name='dbprimary' scope=spfile;
alter system set log_archive_config='DG_CONFIG=(dbprimary,dbstandby)';
alter system set log_archive_dest_1='LOCATION=/oradata/dg/ db_unique_name=dbstandby valid_for=(ALL_LOGFILES,ALL_ROLES)' scope=spfile;
alter system set log_archive_dest_2='SERVICE=dbprimary LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=dbprimary' scope=spfile;
alter system set log_archive_dest_state_1=enable;
alter system set log_archive_dest_state_2=enable;
alter system set log_archive_max_processes=5 scope=spfile;
alter system set remote_login_passwordfile='EXCLUSIVE' scope=spfile;
alter system set FAL_CLIENT='dbstandby' scope=spfile;   
alter system set fal_server='dbprimary' scope=spfile;
alter system set log_archive_format='%t_%s_%r.arc'  scope=spfile;
alter system set standby_file_management='AUTO' scope=spfile;
```

#### 密码文件和控制文件的创建传输
```bash
#一般数据库默认就有密码文件，存放在$ORACLE_HOME/dbs/orapw$ORACLE_SID, 如果没有,执行如下操作即可
 sql>ho orapwd file=$ORACLE_HOME/dbs/orapw$ORACLE_SID password=oracle;
#REMOTE_LOGIN_PASSWORDFILE值是否为 EXCLUSIVE
 sql>alter system set remote_login_passwordfile=exclusive scope=spfile;   
 
#密码文件需要scp到从库        
scp $ORACLE_HOME/dbs/orapw$ORACLE_SID oracle@172.18.44.26:$ORACLE_HOME/dbs 

#创建备份库需要的控制文件并传输到备库
#shutdown immediate
#startup mount
alter database create standby controlfile as '/tmp/standby_control01.ctl';
alter database open;

#拷贝到$ORACLE_BASE/oradata/$ORACLE_SID下和$ORACLE_BASE/fast_recovery_area/$ORACLE_SID下
[oracle@primary admin]scp /tmp/standby_control01.ctl  oracle@172.18.44.26:/u01/app/oracle/oradata/$ORACLE_SID/control01.ctl

```
#### 主库上配置listener.ora 和tnsnames.ora
```bash
#主库上的listener.ora ：
[oracle@primary admin]$ cat listener.ora 
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = xap.pku-hit.com)(PORT = 1521))
    )
  )
  
ADR_BASE_LISTENER = /u01/app/oracle
  
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = orcl)
      (ORACLE_HOME = /u01/app/oracle/product/11.2.0/dbhome_1)
      (GLOBAL_DBNAME = orcl)
    )
  )

#主库上的tnsnames.ora：
[oracle@primary admin]$ cat tnsnames.ora 
DBPRIMARY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = xap.pku-hit.com)(PORT = 1521))
    (CONNECT_DATA =
	    (SERVER = DEDICATED)
      (SERVICE_NAME = dbprimary)
    )
  )

DBSTANDBY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = wlhtest)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = dbstandby)
    )
  )
```
#### 传输到备库
```bash
#copy监听文件
[oracle@primary admin]cd $ORACLE_HOME/network/admin/
[oracle@primary admin]scp -r ./* oracle@172.18.44.26:$ORACLE_HOME/network/admin/
```

## 备库执行
```bash
su oracle;
source /home/oracle/.bash_profile;
#拷贝到$ORACLE_BASE/fast_recovery_area/$ORACLE_SID下
[oracle@primary admin]cp /u01/app/oracle/oradata/$ORACLE_SID/control01.ctl /u01/app/oracle/fast_recovery_area/$ORACLE_SID/control02.ctl
```
#### 备库上配置listener.ora 和tnsnames.ora
```bash
#备库上的listener.ora 
LISTENER =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = wlhtest)(PORT = 1521))
    )
  )

ADR_BASE_LISTENER = /u01/app/oracle

SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = orcl)
      (ORACLE_HOME = /u01/app/oracle/product/11.2.0/dbhome_1)
      (GLOBAL_DBNAME = orcl_st)
    )
  )

#修改/u01/app/oracle/product/11.2.0/network/admin/tnsnames.ora  SERVICE_NAME为db_unique_name
DBPRIMARY =
  (DESCRIPTION =
	(ADDRESS = (PROTOCOL = TCP)(HOST = xap.pku-hit.com)(PORT = 1521))
    (CONNECT_DATA =
	  (SERVER = DEDICATED)
      (SERVICE_NAME = dbprimary)
    )
  )	  

DBSTANDBY =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = wlhtest)(PORT = 1521))
    (CONNECT_DATA =
	  (SERVER = DEDICATED)
      (SERVICE_NAME = dbstandby)
    )
  )
```


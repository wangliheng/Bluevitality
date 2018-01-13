#### 在主库上创建归档目录
```bash
mkdir /oradata/dg
#(以Oracle身份进行的创建，若以root身份进行创建需要，修改归档目录的属主属组，让oracle:oinstall，拥有访问的权限)
sqlplus / as sysdba
startup mount
alter system set log_archive_Dest=’/oradata/dg’;
alter database archivelog
archive log list;
#(此时若主库的归档设置成功，则将出现automatic archival enabled;archive destination /oradata/dg 提示信息)


```

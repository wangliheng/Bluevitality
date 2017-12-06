#### 参数及常用模块
```txt
Ansible：
    -f 线程数（任务并发量）
    -i Inventory文件路径（Host List），默认：/etc/ansible/hosts
    -u 以哪个用户身份运行
    -m 指定模块名（默认"command"）
    -a 模块相关的参数、命令
    -v 详细模式
    -k 提示输入对端密码（使用密码登陆）
    -K 提示输入对端sudo密码
    -t 将输出放在指定目录，命名为每个主机名称
    -T 超时时长
    -B 在后台运行并在num秒后kill该任务
    --check 仅检测而不执行
    
常用模块： 
    copy、file、cron、group、user、yum、service、script、ping、command、raw、get_url、synchronize

Demo：
检查被控端：     ansible ab* -m ping -f 100 -k
执行命令：       ansible all -a "echo hello"
传输文件：       ansible all -m copy -a "src=/run.sh dest=/"
更改权限：       ansible all -m file -a "dest=/run.sh mode=777 owner=root group=root
执行脚本：       ansible all -m script -a "/run.sh"
安装软件：       ansible zabbix -m yum -a "name=vim state=installed"
启用服务：       ansible apache -m service -a "name=iptables state=running"
创建用户：       ansible mysql -m user -a 'name=linux groups=linux password=foo state=present' --sudo -K
开机自启：       ansible PHP -m service -a 'name=puppet state=restarted enabled=yes'
重启服务：       ansible all -m service -a "name=httpd state=restarted
在v1但不在v2中： ansible v1:!v2
指定Host内的组： ansible -i /etc/ansible/hosts apache -u root -k -m shell -a "ls -l"

内置变量：（ansible在每个主机上执行task时将自动收集目标主机的一些元信息赋给内置变量，查看：ansible <host> -m setup）
    ansible_shell_type
    ansible_python_interpreter #python解释器路径
    ansible_ssh_host
    ansible_ssh_port
    ansible_ssh_user
    ansible_ssh_pass
    ansible_sudo_pass
    ansible_connection
    ansible_ssh_private_key_file

```
#### 查看模块信息
```bash
[root@test ~]# ansible-doc -l             #查看所有内置模块
a10_server                                Manage A10 Networks AX/SoftAX/Thunder/vThunder devices'  .... 
a10_server_axapi3                         Manage A10 Networks AX/SoftAX/Thunder/vThunder devices             
a10_service_group                         Manage A10 Networks AX/SoftAX/Thunder/vThunder devices' service ....
a10_virtual_server                        Manage A10 Networks AX/SoftAX/Thunder/vThunder devices' virtu ....
accelerate                                Enable accelerated mode on remote node          
aci_aep                                   Manage attachable Access Entity Profile (AEP) on Cisco ACI fabric ....
......（略）
[root@test ~]# ansible-doc -s user        #查看特定模块的说明信息
- name: Manage user accounts
  user:
      append:                # If `yes', will only add groups, not set them to just the ....
      comment:               # Optionally sets the description (aka `GECOS') of user acc....
      createhome:            # Unless set to `no', a home directory will be made for the....
      expires:               # An expiry time for the user in epoch, it will be ignored .... 
      force:                 # When used with `state=absent', behavior is as with `userd....
      generate_ssh_key:      # Whether to generate a SSH key for the user in question. T....
      group:                 # Optionally sets the user's primary group (takes a group n....
      groups:                # Puts the user in  list of groups. When set to the empty s....
      home:                  # Optionally set the user's home directory.
      local:                 # Forces the use of "local" comm
```
#### 在c/s间使用密钥认证
```bash
[root@test ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
3a:69:c8:3e:25:22:0e:85:b2:9f:0b:eb:ad:ca:2c:c3 root@test
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
| .               |
|o .              |
|.o      S        |
|+ .....o         |
|=o ooo=          |
|=E+... .         |
|**oo..           |
+-----------------+
[root@test ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.0.3
The authenticity of host '192.168.0.3 (192.168.0.3)' can't be established.
ECDSA key fingerprint is 02:c2:94:a0:8d:08:bd:b6:03:a1:1e:24:d6:be:e1:3f.
Are you sure you want to continue connecting (yes/no)? yes
......（略）
root@192.168.0.3's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '192.168.0.3'"
and check to make sure that only the key(s) you wanted were added.
```

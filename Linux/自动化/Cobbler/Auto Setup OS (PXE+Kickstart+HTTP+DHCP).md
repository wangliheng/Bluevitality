#### 配置 DHCP 提供 PXE 引导文件地址...
```bash
# PXE：预引导执行环境（允许客户端启动后通过网络对DHCP指定的TFTP地址进行引导文件的加载）

[root@localhost ~]# setenforce  0
[root@localhost ~]# yum -y install dhcp
[root@localhost ~]# vim /etc/dhcp/dhcpd.conf
option domain-name              "danlab.local";
option domain-name-servers      127.0.0.1;
default-lease-time 86400;
max-lease-time 86400;

filename="pxelinux.0";              #引导文件（它由syslinux提供：yum install syslinux）
next-server 192.168.0.2;            #引导文件所在服务器地址

subnet 0.0.0.0 netmask 0.0.0.0 {
        range 192.168.0.3 192.168.0.254;
        option broadcast-address 192.168.0.255;
        option routers 192.168.0.1;
}
[root@localhost ~]# systemctl start dhcpd
[root@localhost ~]# netstat -atupnl | grep dhcp
udp        0      0 0.0.0.0:67              0.0.0.0:*                           1563/dhcpd          
udp        0      0 0.0.0.0:19992           0.0.0.0:*                           1563/dhcpd          
udp6       0      0 :::36907                :::*                                1563/dhcpd
```
#### Server端设置
```bash
[root@localhost ~]# yum -y install xinetd tftp-server syslinux system-config-kickstart httpd
[root@localhost html]# cat /etc/xinetd.d/tftp
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /var/lib/tftpboot          #TFTP的默认根路径：/var/lib/tftpboot
        disable                 = no                            #改为no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
[root@localhost ~]# chmod  777 /var/lib/tftpboot
[root@localhost ~]# systemctl start tftp.socket
[root@localhost ~]# systemctl start tftp.service
[root@localhost ~]# systemctl start httpd
[root@localhost ~]# cp /mnt/cdrom/images/pxeboot/{vmlinuz,initrd.img} /var/lib/tftpboot
[root@localhost ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot
#CentOS6 （centos6与centos7的PXE的方式稍有不同!）
# [root@localhost ~]# cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
# [root@localhost ~]# cp /mnt/cdrom/images/pxeboot/vmlinuz /var/lib/tftpboot/
# [root@localhost ~]# cp /mnt/cdrom/images/pxeboot/initrd.img /var/lib/tftpboot/
# [root@localhost ~]# cp /mnt/cdrom/isolinux/splash.png /var/lib/tftpboot/
# [root@localhost ~]# cp /mnt/cdrom/isolinux/vesamenu.c32 /var/lib/tftpboot/

#CentOS7
[root@localhost ~]# cp /usr/share/syslinux/{chain.c32,mboot.c32,menu.c32,memdisk} /var/lib/tftpboot/
[root@localhost ~]# ll /var/lib/tftpboot/
总用量 53212
-rw-r--r--. 1 root root    20704 12月  9 01:54 chain.c32
-rw-r--r--. 1 root root 48434768 12月  9 01:59 initrd.img
-rw-r--r--. 1 root root    33628 12月  9 01:54 mboot.c32
-rw-r--r--. 1 root root    26140 12月  9 01:54 memdisk
-rw-r--r--. 1 root root    55012 12月  9 01:54 menu.c32
-rw-r--r--. 1 root root    26764 12月  9 02:01 pxelinux.0
drwxr-xr-x. 2 root root       19 12月  9 01:58 pxelinux.cfg
-rwxr-xr-x. 1 root root  5877760 12月  9 01:59 vmlinuz
#上传Linux_ISO文件
sftp> put CentOS-7-x86_64-Minimal-1708.iso
Uploading CentOS-7-x86_64-Minimal-1708.iso to /root/CentOS-7-x86_64-Minimal-1708.iso
  100% 811008KB  57929KB/s 00:00:14
[root@localhost ~]# cd /var/www/html/
[root@localhost html]# ll
总用量 811008
-rw-r--r--. 1 root root 830472192 11月 21 23:44 CentOS-7-x86_64-Minimal-1708.iso
[root@localhost ~]# mkdir -p /var/lib/tftpboot/pxelinux.cfg
#centos6:	
#[root@localhost ~]# cp /mnt/isolinux/isolinux.cfg /mnt/isolinux/pxelinux.cfg/default
#centos7:	
[root@localhost ~]# vim /var/lib/tftpboot/pxelinux.cfg/defult
default menu.c32
    prompt 0
    timeout 30
    MENU TITLE CentOS7 PXE Menu
    
    LABLE CentOS7
    MENU LABLE Install CentOS7 x86_64
    KERNEL vmlinuz
    APPEND initrd=initrd.img ks=http:/Host:Port/Path/ks.cfg  ksdevice=eth0 ip=dhcp quiet
[root@localhost ~]# chmod 644 /var/lib/tftpboot/pxelinux.cfg/defult

#验证ks文件正确性
[root@localhost ~]# ksvalidator /Path/ks.cfg

#注：
#http:/Host:Port/Path/ks.cfg 中要有 'url --url="http://192.168.0.1/os/"' 使其从网络进行安装
```
#### Client端
`开启网卡的PXE功能....`

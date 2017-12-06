#### 内核源码：/usr/src/kernels/\<kernel-version\>/
```bash
# 若此目录为空，则需安装包：yum -y install kernel-headers kernel-devel
[root@localhost ~]# ll -l /usr/src/kernels/3.10.0-693.5.2.el7.x86_64/
total 4304
drwxr-xr-x.  32 root root    4096 Nov 21 02:53 arch
drwxr-xr-x.   3 root root      74 Nov 21 02:53 block
drwxr-xr-x.   4 root root      72 Nov 21 02:53 crypto
drwxr-xr-x. 117 root root    4096 Nov 21 02:54 drivers
drwxr-xr-x.   2 root root      21 Nov 21 02:54 firmware
drwxr-xr-x.  75 root root    4096 Nov 21 02:54 fs
drwxr-xr-x.  28 root root    4096 Nov 21 02:54 include
drwxr-xr-x.   2 root root      35 Nov 21 02:54 init
drwxr-xr-x.   2 root root      21 Nov 21 02:54 ipc
-rw-r--r--.   1 root root     505 Oct 21 04:59 Kconfig
drwxr-xr-x.  11 root root    4096 Nov 21 02:54 kernel
drwxr-xr-x.  10 root root    4096 Nov 21 02:54 lib
-rw-r--r--.   1 root root   50960 Oct 21 04:59 Makefile
-rw-r--r--.   1 root root    2305 Oct 21 04:59 Makefile.qlock
drwxr-xr-x.   2 root root      55 Nov 21 02:54 mm
-rw-r--r--.   1 root root 1052863 Oct 21 04:59 Module.symvers
drwxr-xr-x.  58 root root    4096 Nov 21 02:54 net
drwxr-xr-x.  13 root root    4096 Nov 21 02:54 samples
drwxr-xr-x.  13 root root    4096 Nov 21 02:54 scripts
drwxr-xr-x.   9 root root    4096 Nov 21 02:54 security
drwxr-xr-x.  23 root root    4096 Nov 21 02:54 sound
-rw-r--r--.   1 root root 3228852 Oct 21 04:59 System.map
drwxr-xr-x.  17 root root    4096 Nov 21 02:54 tools
drwxr-xr-x.   2 root root      35 Nov 21 02:54 usr
drwxr-xr-x.   4 root root      41 Nov 21 02:54 virt
-rw-r-
```
#### Linux Kernel：/boot/vmlinuz-\<kernel-version\>.el7.x86_64 
```bash
#"vm"代表 "Virtual Memory" Linux能够使用硬盘空间作为虚拟内存，因此得名"vm"
#vmlinuz是可执行的Linux内核，位于/boot/vmlinuz，它一般是一个软链接... 
#vmlinux是未压缩的内核，vmlinuz是vmlinux的压缩文件。
[root@localhost ~]# ll /boot/vmlinuz-3.10.0-327.el7.x86_64 
-rwxr-xr-x. 1 root root 5156528 Nov 20  2015 /boot/vmlinuz-3.10.0-327.el7.x86_64
```
#### 内核模块：/lib/modules/\<kernel-version\>/
```bash
#Linux内的设备驱动程序可以方便地以模块化（modularize）形式设置，并在系统运行期间可直接装载或卸载。
[root@localhost ~]# ls -l /lib/modules/3.10.0-327.el7.x86_64/
total 2704
lrwxrwxrwx.  1 root root     38 Nov 20 06:33 build -> /usr/src/kernels/3.10.0-327.el7.x86_64
drwxr-xr-x.  2 root root      6 Nov 20  2015 extra
drwxr-xr-x. 11 root root   4096 Nov 20 06:33 kernel
-rw-r--r--.  1 root root 705037 Nov 20 06:36 modules.alias
-rw-r--r--.  1 root root 681768 Nov 20 06:36 modules.alias.bin
-rw-r--r--.  1 root root   1288 Nov 20  2015 modules.block
-rw-r--r--.  1 root root   5995 Nov 20  2015 modules.builtin
-rw-r--r--.  1 root root   7744 Nov 20 06:36 modules.builtin.bin
-rw-r--r--.  1 root root 218218 Nov 20 06:36 modules.dep
-rw-r--r--.  1 root root 316220 Nov 20 06:36 modules.dep.bin
-rw-r--r--.  1 root root    339 Nov 20 06:36 modules.devname
-rw-r--r--.  1 root root    108 Nov 20  2015 modules.drm
-rw-r--r--.  1 root root    100 Nov 20  2015 modules.modesetting
-rw-r--r--.  1 root root   1522 Nov 20  2015 modules.networking
-rw-r--r--.  1 root root  84666 Nov 20  2015 modules.order
-rw-r--r--.  1 root root     89 Nov 20 06:36 modules.softdep
-rw-r--r--.  1 root root 311845 Nov 20 06:36 modules.symbols
-rw-r--r--.  1 root root 387028 Nov 20 06:36 modules.symbols.bin
lrwxrwxrwx.  1 root root      5 Nov 20 06:33 source -> build
drwxr-xr-x.  2 root root      6 Nov 20  2015 updates
drwxr-xr-x.  2 root root     91 Nov 20 06:33 vdso
drwxr-xr-x.  2 root root      6 Nov 20  2015 weak-updates
```
#### 引导文件：/boot/grub2/grub.cfg
```bash
#grub.conf是grub的主配置文件，通过它grub才能正确的找到kernel，因此系统才能正常启动...
#grub2采用模块化设计，主配置文件是/boot/grub2/grub.cfg，默认不允许修改它而是修改其他配置最后通过grub-mkconfig重新生成
#旧版本的grub命名为GRUB Legacy...
[root@localhost ~]# ll /etc/grub2.cfg 
lrwxrwxrwx. 1 root root 22 Nov 20 06:33 /etc/grub2.cfg -> ../boot/grub2/grub.cfg

[root@localhost ~]# cat  /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet"
GRUB_DISABLE_RECOVERY="true
[root@localhost ~]# ll /etc/grub.d/
total 72
-rwxr-xr-x. 1 root root  8702 Nov 24  2015 00_header
-rwxr-xr-x. 1 root root   992 May  4  2015 00_tuned
-rwxr-xr-x. 1 root root   230 Nov 24  2015 01_users
-rwxr-xr-x. 1 root root 10232 Nov 24  2015 10_linux
-rwxr-xr-x. 1 root root 10275 Nov 24  2015 20_linux_xen
-rwxr-xr-x. 1 root root  2559 Nov 24  2015 20_ppc_terminfo
-rwxr-xr-x. 1 root root 11169 Nov 24  2015 30_os-prober
-rwxr-xr-x. 1 root root   214 Nov 24  2015 40_custom
-rwxr-xr-x. 1 root root   216 Nov 24  2015 41_custom
-rw-r--r--. 1 root root   483 Nov 24  2015 README

#若上述文件经过修改，则需要重新下发到/boot/grub2/grub.cfg
[root@localhost ~]# grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-327.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-327.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-a0d4da63906a4a5f97671a27a749c0e3
Found initrd image: /boot/initramfs-0-rescue-a0d4da63906a4a5f97671a27a749c0e3.img
done
```

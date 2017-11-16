#!/bin/bash
#Tutorial.....

#定义...
VARIABLE="VALUE"

set -e
set -x

# source /etc/init.d/functions
# echo_success,echo_failure,echo_passed,echo_warning

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#目录
mkdir -p $..../etc

#依赖
yum -y install epel-release gcc gcc-c++ cmake kernel-devel openssl openssl-devel rpm-build

#删除旧数据
rm -rf {配置目录,安装目录,解压目录,启动文件目录,其他目录...}

#创建用户
if ! id nginx &> /dev/null ; then
    groupadd nginx
    useradd -M -g nginx  nginx -s /sbin/nologin
fi

#判断是否有源码包
[ -s stunel-4.33.tar.gz ] || exit 1
......
......
......
#依内核数量并行
NUM=$( awk '/processor/{NUM++};END{print NUM}' /proc/cpuinfo )
if [ $NUM -gt 1 ] ;then
    make -j $NUM
else
    make
fi
make install


#关闭SELINUX与防火墙
function disable_sec() {
    setenforce 0 ; sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
    systemctl disable firewalld #or firewall-cmd--permanent --add-port=XXX/tcp && firewall-cmd-reload
    systemctl stop firewalld
}

disable_sec

echo 'xxxxxxxxxxxxxx' >> /etc/rc.local
chmod a+x /etc/rc.local

echo -e "\nScript Execution Time： $SECONDS"

exit 0

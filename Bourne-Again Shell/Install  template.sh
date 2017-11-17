#!/bin/bash
# Environment CentOS 7.3
# Author: inmoonlight@163.com

#source /etc/init.d/functions   # echo_success,echo_failure,echo_passed,echo_warning

#定义...
USERNAME="XXX"          #@27-31

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"  echo_failure
    exit;
fi

#目录
mkdir -p $..../etc

#depend
yum -y install epel-release gcc gcc-c++ cmake kernel-devel openssl openssl-devel

#erase old file and config ...
rm -rf {配置目录,安装目录,解压目录,启动文件目录,其他目录...}

#add user
if ! id ${USERNAME} &> /dev/null ; then
    groupadd ${USERNAME}
    useradd -M -g ${USERNAME} ${USERNAME:?'Undefined ...'} -s /sbin/nologin
fi

#using local
[ -s stunel-4.33.tar.gz ] || exit 1
......
......

#并行编译
NUM=$( awk '/processor/{N++};END{print N}' /proc/cpuinfo )
if [ $NUM -gt 1 ];then
    make -j $NUM
else
    make
fi
make install

#关闭SELINUX与防火墙
function disable_sec() {
    if [ -x /usr/bin/systemctl ] ; then
        #CentOS 7.X
        setenforce 0 ; sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
        systemctl disable firewalld #or firewall-cmd--permanent --add-port=XXX/tcp && firewall-cmd-reload
        systemctl stop firewalld
    else
        #CentOS 6.X
        chkconfig iptables off --level 235
        service iptables stop
    fi
} 2> /dev/null

disable_sec

echo 'xxxxxxxxxxxxxx' >> /etc/rc.local
chmod a+x /etc/rc.local

echo -e "\033[32m\n\nScript Execution Time： ${SECONDS}s\033[0m"

exit 0

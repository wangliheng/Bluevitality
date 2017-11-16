#!/bin/bash
#Tutorial.....

#定义...
STORAGE_DEVICE_01="/dev/sd..."

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#目录
mkdir -p $..../etc

#删除旧数据
rm -rf  $( rpm -ql scsi-target-utils | grep 'etc' )

#依赖
yum -y install epel-release gcc gcc-c++ cmake kernel-devel openssl openssl-devel rpm-build
yum -y install scsi-target-utils        #服务端（客户端：yum -y install iscsi-initiator-utils）
yum -y install targetcli                #管理工具（交互式）

#关闭SELINUX及防火墙
function disable_sec() {
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
    systemctl disable firewalld #or firewall-cmd--permanent --add-port=3260/tcp && firewall-cmd-reload
    systemctl stop firewalld
} 

disable_sec || :









echo "Script Execution Time： $SECONDS"

exit 0
#!/bin/bash
#Tutorial.....

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#删除旧数据
rm -rf  $( rpm -ql scsi-target-utils | grep 'etc' )

#依赖
yum -y install epel-release gcc gcc-c++ cmake kernel-devel openssl openssl-devel
yum -y install scsi-target-utils        #服务端（客户端：yum -y install iscsi-initiator-utils）
yum -y install targetcli                #管理工具（交互式）

# 说明：
# /etc/sysconfig/tgtd                   #
# /etc/tgt/conf.d/sample.conf           #模板
# /etc/tgt/targets.conf                 #主配置文件
# /etc/tgt/tgtd.conf                    #
# /usr/sbin/tgtd                        #Daemon

#关闭SELINUX及防火墙
function disable_sec() {
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
    systemctl disable firewalld #or firewall-cmd --add-service=iscsi-target --permanent && firewall-cmd-reload
    systemctl stop firewalld
} 

function start_serv() {
    systemctl enable tgtd.service
    systemctl start tgtd.service
    systemctl status tgtd.service
}


disable_sec || :
start_serv

#echo "/usr/sbin/tgtd start" >> /etc/rc.local
#chmod a+x /etc/rc.local

echo -e "\nScript Execution Time： $SECONDS"

exit 0
#!/bin/bash
#Tutorial.....

#定义...
SERVER_ADDRESS="192.168.139.137"
SERVER_PORT="3260"

USE_AUTH=1                      #是否启用认证? 0 or 1
INITIATOR_USERNAME="yanfa"      #账号密码
INITIATOR_PASSWORD="123456"     #

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#删除旧数据
yum -y remove iscsi-initiator-utils

#依赖
yum -y install epel-release gcc gcc-c++ cmake kernel-devel openssl openssl-devel
yum -y install iscsi-initiator-utils    #客户端（服务端：yum -y install scsi-target-utils）

#说明：
# /etc/iscsi/iscsid.conf：	主配置文件 
# /usr/sbin/iscsid： 		initiator服务程序 
# /usr/sbin/iscsiadm： 		initiator管理程序 
# /usr/sbin/iscsid： 	    主服务进程 
#
# /usr/lib/systemd/system/iscsi.service： 		
# 该脚本可使发现的iscsi target生效，一般直接使用其即可
# initiator未执行的话会调用/etc/init.d/iscsid启动initiator

#关闭SELINUX及防火墙
function disable_sec() {
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
    systemctl disable firewalld #or firewall-cmd--permanent --add-port=3260/tcp && firewall-cmd-reload
    systemctl stop firewalld
} 

disable_sec || :

#若启用认证则写入验证信息
[ ${USE_AUTH} -eq 1 ] && {
    [[ -f /etc/iscsi/iscsid.conf ]] || exit 1
    cp /etc/iscsi/iscsid.conf /etc/iscsi/iscsid.conf.$(date '+%Y-%m').${RANDOM}.bak
    cat >> /etc/iscsi/iscsid.conf <<eof
#针对discovery
discovery.sendtargets.auth.authmethod = CHAP	
discovery.sendtargets.auth.username = ${INITIATOR_USERNAME}
discovery.sendtargets.auth.password = ${INITIATOR_PASSWORD}

#针对login（S端的检查设置在指定的target上）
node.startup = automatic
node.session.auth.authmethod = CHAP				
node.session.auth.username = ${INITIATOR_USERNAME}
node.session.auth.password = ${INITIATOR_PASSWORD}
node.session.timeo.replacement_timeout = 20     #超时时间
eof
}

#输出target端提供的设备：（会自动保存记录）
iscsiadm -m discovery -t sendtargets -p ${SERVER_ADDRESS}:${SERVER_PORT} --discover

#启动服务，依discovery模块发现的信息进行挂载
function start_serv() {
    systemctl enable iscsi.service
    systemctl start iscsi.service
    systemctl status iscsi.service
}

start_serv

echo "Script Execution Time： $SECONDS"

exit 0

# ---------------------------------------------------------------------------------------
#其它常用命令：
#在initiator端显示发现的target主机： 	iscsiadm -m node
#在initiator端显示已经建立的target连接：iscsiadm -m session
#在initiator端断开与指定target的连接：	iscsiadm -m node iqn.2013-09.com.inter.10.1:test-target  -u
#在initiator端连接指定target： 			iscsiadm -m node iqn.2013-09.com.inter.10.1:test-target  [-l/--login]
#在initiator端退出所有登录的连接：		iscsiadm -m node --logoutall=all
#在initiator端命令方式连接/登录：		iscsiadm -m node -T <target-name> -p <ip-address>:<port> --login
#在initiator端命令方式验证登录：		iscsiadm -m node -T LUN_NAME -o update --name node.session.auth.authmethod --value=CHAP
#                                       iscsiadm -m node -T LUN_NAME -o update --name node.session.auth.username --value=<user>
#                                       iscsiadm -m node -T LUN_NAME -o update --name node.session.auth.password --value=<passwd>
#
#在target端创建账号：				    tgtadm --lld iscsi -m account -o new --user <username> --password <password>
#在target端将账号绑定到指定的target：	tgtadm --lld iscsi -m account -o bind --tid 1 --user <username>
#在target端删除一个账号：			    tgtadm --lld iscsi -m account -o delete --user <username>
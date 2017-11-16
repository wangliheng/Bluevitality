#!/bin/bash
#Tutorial.....

#This target ...
#iqn.yyyy-mm.<reversed domain name>:identifier
TARGET_NAME="yanfa"
REVERSE_DOMAIN="com.yunwei"
TARGET_LUN_NAME="iqn.$(date '+%Y-%m').${REVERSE_DOMAIN}:server.${TARGET_NAME}"   
BACKING_STORE_FULLPATH="/dev/sdb"            #设备地址

INITIATOR_USERNAME="yanfa"                  #C端账号密码
INITIATOR_PASSWORD="123456"                 #
INITIATOR_ADDRESS_SRC="192.168.0.0/16"      #允许访问的的C端网段

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#检查tgtd守护进程是否存在并启动
[[ -x /usr/sbin/tgtd ]]  && {
    systemctl start tgtd && systemctl status tgtd || exit 1
}

#写入配置
cp /etc/tgt/targets.conf /etc/tgt/targets.conf.$(date '+%Y-%m').${RANDOM}.bak
cat >> /etc/tgt/targets.conf <<eof
<target ${TARGET_LUN_NAME}>
    backing-store  ${BACKING_STORE_FULLPATH}    #设备地址(使用 backing-store 时报错..故障原因该不清楚)
    write-cache on					            #默认开启缓存加速，在特殊情况有丢失数据的可能
    IncomingUser ${INITIATOR_USERNAME} ${INITIATOR_PASSWORD}
    initiator-address ${INITIATOR_ADDRESS_SRC}
</target>
eof

#重读配置
function reload_serv() {
    systemctl restart tgtd && systemctl status tgtd || exit 1
}

reload_serv

#注意！在ISCSI不使用gfs时：
#1个target对多个initiator使用时iscsi不保证写操作一致
#所以在1对多情况下1个initiator可rw其他initiator可r是可行方案

echo -e "\nScript Execution Time： $SECONDS"

exit 0
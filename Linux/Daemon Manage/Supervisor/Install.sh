#!/bin/bash

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#依赖
[ -x /usr/bin/pip ] || exit 1

#更新pip
pip install --upgrade pip

#防止链接超时
while true
do
    pip install supervisor
    [[ "$?" == "0" ]] && {
        #输出默认配置项到配置文件
        echo_supervisord_conf > /etc/supervisord.conf
        #从/etc/supervisord/*.conf载入配置
        sed -i "s#^;files = relative/directory/\*\.ini#files = /etc/supervisord/*.conf#g" /etc/supervisord.conf
        break
    } 
done


#启动
supervisord -c /etc/supervisord.conf

echo "Script Execution Time： $SECONDS"

exit 0
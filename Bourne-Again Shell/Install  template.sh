#!/bin/bash


#定义...
var1=value
var2=value
var3=value

set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#目录
mkdir -p $..../etc

#依赖
yum -y install gcc gcc-c++ ncurses-devel cmake openssl openssl-devel


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


exit 0

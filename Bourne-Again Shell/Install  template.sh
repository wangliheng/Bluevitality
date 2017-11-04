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
mkdir -p $....

#依赖
yum -y install gcc gcc-c++ ncurses-devel cmake .......

#创建用户
if ! id nginx &> /dev/null ; then
    groupadd nginx
    useradd -M -g nginx  nginx -s /sbin/nologin
fi


......
......
......




exit 0

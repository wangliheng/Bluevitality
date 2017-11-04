#!/bin/bash

# Demo: ---------------------------------------------------
#
#                                           |
#        121.207.22.1          111.2.33.28  |
#        +---------+  Public   +---------+  | Private
#        | ServerA +-----------+ ServerB +--+
#        +---------+  Network  +---------+  | Network
#                                           |
#                                           | 10.10.10.2/24 
#----------------------------------------------------------

TUNNEL_NAME="GRE1"
HOST_A_PUBLIC_ADDRESS=192.168.139.132
HOST_A_PRIVATA_ADDRESS=192.168.20.1
HOST_B_PUBLIC_ADDRESS=192.168.139.134
HOST_B_PRIVATE_ADDRESS=192.168.20.2


set -e
set -x

#身份检查
if [ $(id -u) != "0" ]; then
    echo "error: user must be an administrator"
    exit;
fi

#HOST_A
function A() {

    ip tunnel add ${TUNNEL_NAME} mode gre remote ${HOST_B_PUBLIC_ADDRESS} local ${HOST_A_PUBLIC_ADDRESS} ttl 255
    ip link set ${TUNNEL_NAME} up
    ip address add ${HOST_A_PRIVATA_ADDRESS} peer ${HOST_B_PRIVATE_ADDRESS} dev ${TUNNEL_NAME}
    sysctl -w net.ipv4.ip_forward=1
    sysctl -p
    
}

#HOST_B
function B() {

    ip tunnel add ${TUNNEL_NAME} mode gre remote ${HOST_A_PUBLIC_ADDRESS} local ${HOST_B_PUBLIC_ADDRESS} ttl 255
    ip link set ${TUNNEL_NAME} up
    ip address add ${HOST_B_PRIVATE_ADDRESS} peer ${HOST_A_PRIVATA_ADDRESS} dev ${TUNNEL_NAME}
    sysctl -w net.ipv4.ip_forward=1
    sysctl -p
    
}


case $1 in
    "a"|"A")
        A
        ;;
    "b"|"B")
        B
        ;;
    *)
        echo -e "this is HOST(A) or HOST(B) ?"
        echo -e "remove:\n ip link set ${TUNNEL_NAME} down && ip tunnel del ${TUNNEL_NAME}"
        ;;
esac

exit 0

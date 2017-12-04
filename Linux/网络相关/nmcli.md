#### 备忘
```txt
Network Manager command line tool ===> nmcli

是一个非常丰富和灵活的命令行工具。nmcli使用的情况有：
  设备 – 正在使用的网络接口
  连接 – 一组配置设置，对于一个单一的设备可以有多个连接，可以在连接之间切换

nmcli：
  device  网络接口，是物理设备，类似于：ip link
        nmcli dev参数：status | show | connect | disconnect | delete | wifi 
  connection  连接，偏重于逻辑设置，类似于：ip address
        nmcli connection参数： show | up | down | add | modify | edit | delete | reload | load
```

#### Example
```bash
[root@localhost rules.d]# tracepath www.baidu.com         #输出像traceroute但其更加完整
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.0.2                                           0.122ms 
 1:  192.168.0.2                                           0.200ms 
 2:  no reply
 3:  no reply
 4:  no reply
[root@localhost rules.d]# nmcli general status                  #查看对应的状态信息的显示
状态    CONNECTIVITY  WIFI-HW  WIFI    WWAN-HW  WWAN        
连接的  全部          已启用   已启用  已启用   已启用     
[root@localhost rules.d]# nmcli device status                   #得到网络设备状态
设备         类型      状态    CONNECTION  
eno16777736  ethernet  连接的  eno16777736 
lo           loopback  未管理  --
[root@localhost rules.d]# nmcli device show                     #得到设备信息
GENERAL.设备:                           eno16777736
GENERAL.类型:                           ethernet
GENERAL.硬盘:                           00:0C:29:AD:AB:AE
GENERAL.MTU:                            1500
GENERAL.状态:                           100 (连接的)
GENERAL.CONNECTION:                     eno16777736
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/0
WIRED-PROPERTIES.容器:                  开
IP4.地址[1]:                            192.168.0.3/24
IP4.网关:                               192.168.0.2
IP4.DNS[1]:                             192.168.0.2
IP4.域[1]:                              localdomain
IP6.地址[1]:                            fe80::20c:29ff:fead:abae/64
IP6.网关:                               

GENERAL.设备:                           lo
GENERAL.类型:                           loopback
GENERAL.硬盘:                           00:00:00:00:00:00
GENERAL.MTU:                            65536
GENERAL.状态:                           10 (未管理)
GENERAL.CONNECTION:                     --
GENERAL.CON-PATH:                       --
IP4.地址[1]:                            127.0.0.1/8
IP4.网关:                               
IP6.地址[1]:                            ::1/128
IP6.网关:                      
[root@localhost rules.d]# nmcli device show eno16777736         #得到特定设备的详情
GENERAL.设备:                           eno16777736
GENERAL.类型:                           ethernet
GENERAL.硬盘:                           00:0C:29:AD:AB:AE
GENERAL.MTU:                            1500
GENERAL.状态:                           100 (连接的)
GENERAL.CONNECTION:                     eno16777736
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/0
WIRED-PROPERTIES.容器:                  开
IP4.地址[1]:                            192.168.0.3/24
IP4.网关:                               192.168.0.2
IP4.DNS[1]:                             192.168.0.2
IP4.域[1]:                              localdomain
IP6.地址[1]:                            fe80::20c:29ff:fead:abae/64
IP6.网关: 
[root@localhost rules.d]# nmcli connection show                 #找出有多少连接服务于多少设备
名称         UUID                                  类型            设备        
eno16777736  5630b9e3-7cd4-4488-8a42-d0c2c817f2ba  802-3-ethernet  eno16777736 
eno16777736  91fc2077-5bfe-445e-8b5e-8d939a966189  802-3-ethernet  -- 
[root@localhost rules.d]# nmcli connection show eno16777736     #得到特定连接的详情
connection.id:                          eno16777736
connection.uuid:                        5630b9e3-7cd4-4488-8a42-d0c2c817f2ba
connection.interface-name:              eno16777736
connection.type:                        802-3-ethernet
connection.autoconnect:                 no
connection.autoconnect-priority:        0
connection.timestamp:                   1512426780
connection.read-only:                   no
connection.permissions:                 
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 
connection.gateway-ping-timeout:        0
connection.metered:                     未知
802-3-ethernet.port:                    --
802-3-ethernet.speed:                   0
802-3-ethernet.duplex:                  --
802-3-ethernet.auto-negotiate:          yes
802-3-ethernet.mac-address:             00:0C:29:AD:AB:AE
802-3-ethernet.cloned-mac-address:      --
802-3-ethernet.mac-address-blacklist:   
802-3-ethernet.mtu:                     自动
802-3-ethernet.s390-subchannels:        
802-3-ethernet.s390-nettype:            --
802-3-ethernet.s390-options:            
802-3-ethernet.wake-on-lan:             1 (default)
802-3-ethernet.wake-on-lan-password:    --
ipv4.method:                            auto
ipv4.dns:                               192.168.0.2
ipv4.dns-search:                        
ipv4.addresses:                         
ipv4.gateway:                           --
ipv4.routes:                            
ipv4.route-metric:                      0
ipv4.ignore-auto-routes:                no
ipv4.ignore-auto-dns:                   no
ipv4.dhcp-client-id:                    --
ipv4.dhcp-send-hostname:                yes
ipv4.dhcp-hostname:                     --
ipv4.never-default:                     no
ipv4.may-fail:                          yes
ipv6.method:                            link-local
ipv6.dns:                               
ipv6.dns-search:                        
ipv6.addresses:                         
ipv6.gateway:                           --
ipv6.routes:                            
ipv6.route-metric:                      -1
ipv6.ignore-auto-routes:                no
ipv6.ignore-auto-dns:                   no
ipv6.never-default:                     no
ipv6.may-fail:                          yes
ipv6.ip6-privacy:                       -1 (未知)
ipv6.dhcp-send-hostname:                yes
ipv6.dhcp-hostname:                     --
GENERAL.名称:                           eno16777736
GENERAL.UUID:                           5630b9e3-7cd4-4488-8a42-d0c2c817f2ba
GENERAL.设备:                           eno16777736
GENERAL.状态:                           已激活
GENERAL.默认:                           是
GENERAL.DEFAULT6:                       否
GENERAL.VPN:                            否
GENERAL.ZONE:                           --
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/0
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/1
GENERAL.SPEC 对象:                      /
GENERAL.MASTER-PATH:                    --
IP4.地址[1]:                            192.168.0.3/24
IP4.网关:                               192.168.0.2
IP4.DNS[1]:                             192.168.0.2
IP4.域[1]:                              localdomain
DHCP4.选项[1]:                          requested_domain_search = 1
DHCP4.选项[2]:                          requested_nis_domain = 1
DHCP4.选项[3]:                          requested_time_offset = 1
DHCP4.选项[4]:                          requested_broadcast_address = 1
DHCP4.选项[5]:                          requested_rfc3442_classless_static_routes = 1
DHCP4.选项[6]:                          requested_classless_static_routes = 1
DHCP4.选项[7]:                          requested_domain_name = 1
DHCP4.选项[8]:                          expiry = 1514572087
DHCP4.选项[9]:                          domain_name = localdomain
DHCP4.选项[10]:                         next_server = 192.168.0.254
DHCP4.选项[11]:                         broadcast_address = 192.168.0.255
DHCP4.选项[12]:                         dhcp_message_type = 5
DHCP4.选项[13]:                         requested_subnet_mask = 1
DHCP4.选项[14]:                         dhcp_lease_time = 2161800
DHCP4.选项[15]:                         routers = 192.168.0.2
DHCP4.选项[16]:                         ip_address = 192.168.0.3
DHCP4.选项[17]:                         requested_static_routes = 1
DHCP4.选项[18]:                         requested_interface_mtu = 1
DHCP4.选项[19]:                         requested_nis_servers = 1
DHCP4.选项[20]:                         requested_wpad = 1
DHCP4.选项[21]:                         requested_ntp_servers = 1
DHCP4.选项[22]:                         requested_domain_name_servers = 1
DHCP4.选项[23]:                         domain_name_servers = 192.168.0.2
DHCP4.选项[24]:                         requested_ms_classless_static_routes = 1
DHCP4.选项[25]:                         requested_routers = 1
DHCP4.选项[26]:                         subnet_mask = 255.255.255.0
DHCP4.选项[27]:                         network_number = 192.168.0.0
DHCP4.选项[28]:                         requested_host_name = 1
DHCP4.选项[29]:                         dhcp_server_identifier = 192.168.0.254
IP6.地址[1]:                            fe80::20c:29ff:fead:abae/64
IP6.网关:                               

connection.id:                          eno16777736
connection.uuid:                        91fc2077-5bfe-445e-8b5e-8d939a966189
connection.interface-name:              eno16777736
connection.type:                        802-3-ethernet
connection.autoconnect:                 no
connection.autoconnect-priority:        0
connection.timestamp:                   0
connection.read-only:                   no
connection.permissions:                 
connection.zone:                        --
connection.master:                      --
connection.slave-type:                  --
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 
connection.gateway-ping-timeout:        0
connection.metered:                     未知
802-3-ethernet.port:                    --
802-3-ethernet.speed:                   0
802-3-ethernet.duplex:                  --
802-3-ethernet.auto-negotiate:          yes
802-3-ethernet.mac-address:             --
802-3-ethernet.cloned-mac-address:      --
802-3-ethernet.mac-address-blacklist:   
802-3-ethernet.mtu:                     自动
802-3-ethernet.s390-subchannels:        
802-3-ethernet.s390-nettype:            --
802-3-ethernet.s390-options:            
802-3-ethernet.wake-on-lan:             1 (default)
802-3-ethernet.wake-on-lan-password:    --
ipv4.method:                            auto
ipv4.dns:                               
ipv4.dns-search:                        
ipv4.addresses:                         
ipv4.gateway:                           --
ipv4.routes:                            
ipv4.route-metric:                      -1
ipv4.ignore-auto-routes:                no
ipv4.ignore-auto-dns:                   no
ipv4.dhcp-client-id:                    --
ipv4.dhcp-send-hostname:                yes
ipv4.dhcp-hostname:                     --
ipv4.never-default:                     no
ipv4.may-fail:                          yes
ipv6.method:                            auto
ipv6.dns:                               
ipv6.dns-search:                        
ipv6.addresses:                         
ipv6.gateway:                           --
ipv6.routes:                            
ipv6.route-metric:                      -1
ipv6.ignore-auto-routes:                no
ipv6.ignore-auto-dns:                   no
ipv6.never-default:                     no
ipv6.may-fail:                          yes
ipv6.ip6-privacy:                       -1 (未知)
ipv6.dhcp-send-hostname:                yes
ipv6.dhcp-hostname:                     --
```

#### 备忘
```txt

```

#### Link
```bash
[root@localhost ~]# ip link set dev eno16777736 up                      #up/down特定链路接口
[root@localhost ~]# ip link show eno16777736                            #查看指定链路接口信息
2: eno16777736: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 00:0c:29:ad:ab:ae brd ff:ff:ff:ff:ff:ff
[root@localhost ~]# ip link set dev eno16777736 txqueuelen 1000         #改变传输队列长度
[root@localhost ~]# ip link help                                        #ip link set dev 参数汇总 ...
Usage: ip link add [link DEV] [ name ] NAME
                   [ txqueuelen PACKETS ]
                   [ address LLADDR ]
                   [ broadcast LLADDR ]
                   [ mtu MTU ]
                   [ numtxqueues QUEUE_COUNT ]
                   [ numrxqueues QUEUE_COUNT ]
                   type TYPE [ ARGS ]
       ip link delete DEV type TYPE [ ARGS ]

       ip link set { dev DEVICE | group DEVGROUP } [ { up | down } ]
                          [ arp { on | off } ]
                          [ dynamic { on | off } ]
                          [ multicast { on | off } ]
                          [ allmulticast { on | off } ]
                          [ promisc { on | off } ]
                          [ trailers { on | off } ]
                          [ txqueuelen PACKETS ]
                          [ name NEWNAME ]
                          [ address LLADDR ]
                          [ broadcast LLADDR ]
                          [ mtu MTU ]
                          [ netns PID ]
                          [ netns NAME ]
                          [ link-netnsid ID ]
                          [ alias NAME ]
                          [ vf NUM [ mac LLADDR ]
                                   [ vlan VLANID [ qos VLAN-QOS ] ]
                                   [ rate TXRATE ] ] 
                                   [ spoofchk { on | off} ] ] 
                                   [ query_rss { on | off} ] ] 
                                   [ state { auto | enable | disable} ] ]
                          [ master DEVICE ]
                          [ nomaster ]
                          [ addrgenmode { eui64 | none } ]
       ip link show [ DEVICE | group GROUP ] [up]

TYPE := { vlan | veth | vcan | dummy | ifb | macvlan | can |
          bridge | ipoib | ip6tnl | ipip | sit | vxlan |
          gre | gretap | ip6gre | ip6gretap }
```
#### address
```bash
[root@localhost ~]# ip address help
Usage: ip addr {add|change|replace} IFADDR dev STRING [ LIFETIME ]
                                                      [ CONFFLAG-LIST ]
       ip addr del IFADDR dev STRING [mngtmpaddr]
       ip addr {show|save|flush} [ dev STRING ] [ scope SCOPE-ID ]
                            [ to PREFIX ] [ FLAG-LIST ] [ label PATTERN ] [up]
       ip addr {showdump|restore}
IFADDR := PREFIX | ADDR peer PREFIX
          [ broadcast ADDR ] [ anycast ADDR ]
          [ label STRING ] [ scope SCOPE-ID ]
SCOPE-ID := [ host | link | global | NUMBER ]
FLAG-LIST := [ FLAG-LIST ] FLAG
FLAG  := [ permanent | dynamic | secondary | primary |
           tentative | deprecated | dadfailed | temporary |
           CONFFLAG-LIST ]
CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG
CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute ]
LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]
LFT := forever | SECONDS
```
#### route
```bash
```
#### neighbor
```bash
```

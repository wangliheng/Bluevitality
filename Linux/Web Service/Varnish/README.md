#### 备忘
```txt
varnish：
    高性能且开源的反向代理服务器和 HTTP 加速器，其采用全新的软件体系机构与现在的硬件体系紧密配合。
    
VCL：
    全称："Varnish Configuration Language"
    是varnish配置缓存策略的工具,它是基于"域" (domain specific) 的简单编程语言
    支持有限的算术运算和逻辑运算操作、允许使用正则表达式进行字符串匹配、允许用户使用set自定义变量、支持if判断
    有内置的函数与变量等... 使用VCL编写的缓存策略通常保存至"xxx.vcl"文件并且需编译成二进制格式后才能由varnish调用

程序环境：
    /etc/varnish/varnish.params： 
        配置varnish服务进程的工作特性，如监听的地址和端口，缓存机制等...
    /etc/varnish/default.vcl：
        配置各由Management管理下的各Child/Cache线程的缓存策略...
    /usr/sbin/varnishd：
        主程序
    /usr/sbin/varnish_reload_vcl：
        VCL配置文件重载程序
    /usr/bin/varnishadm：
        CLI interface
    Shared Memory Log 交互工具：
        /usr/bin/varnishhist
        /usr/bin/varnishlog
        /usr/bin/varnishncsa
        /usr/bin/varnishstat
        /usr/bin/varnishtop
    Systemd Unit File：
        /usr/lib/systemd/system/varnish.service         服务 daemon
        /usr/lib/systemd/system/varnishlog.service      日志服务
        /usr/lib/systemd/system/varnishncsa.service     日志持久的服务
```
#### varnish.params
```txt
RELOAD_VCL=1                                    #自动重新装载缓存策略，1表示自动装载
VARNISH_VCL_CONF=/etc/varnish/default.vcl       #缓存策略文件路径 （默认的VCL配置文件路径）

VARNISH_LISTEN_ADDRESS=172.16.0.10              #服务监听地址与端口
VARNISH_LISTEN_PORT=80                          #

VARNISH_TTL=120                                 #与后端服务器连接的超时时间

VARNISH_ADMIN_LISTEN_ADDRESS=127.0.0.1          #管理员登录使用的主机与端口
VARNISH_ADMIN_LISTEN_PORT=6082
VARNISH_SECRET_FILE=/etc/varnish/secret         #管理员登录时使用的密钥文件

VARNISH_STORAGE="file,/etc/varnish/cachedir,1G" #缓存类型及对应大小（3种类型：malloc，file，...）
                                                #使用file类型缓存文件时属主/组应为：varnish（malloc类型使用内存）

#VARNISH_STORAGE="malloc,1G"                    #使用内存存储（注：VARNISH_STORAGE仅能定义一次）

VARNISH_USER=varnish                            #运行时的用户与组
VARNISH_GROUP=varnish

#运行时参数，线程池数量，每个线程池的线程数及最大请求处理数量（-p 可指定添加运行参数及对应值）
DAEMON_OPTS="-p thread_pools=3 -p thread_pool_min=50 -p thread_pool_max=2000"
```
#### Varnish 处理 HTTP 请求的过程描述
```txt
1，Receive 状态（vcl_recv）：
    即请求处理的入口状态，依 VCL 规则判断该请求应 pass（vcl_pass） 或 pipe（vcl_pipe），还是进入 lookup（本地查询） 
2，Lookup 状态：
    进入该状态后会在 hash 表中查找数据，若找到则进入 hit（vcl_hit）状态否则进入 miss（vcl_miss）状态 
3，Pass（vcl_pass）状态：
    在此状态下会直接进入后端请求，即进入 fetch（vcl_fetch）状态 
4，Fetch（vcl_fetch）状态：
    在 fetch 状态下对请求进行后端获取，发送请求，获得数据，并根据设置是否进行本地存储... 
5，Deliver（vcl_deliver）状态：
    将获取到的数据发给客户端，而后完成本次请求
```
#### VCL 内置的公共变量
```txt

```

VCL文件：

vcl 4.0;                          #版本兼容性

backend default { 
    
    .host = "172.16.252.205";     #定义后端主机
    .port = "80";
    
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .probe = check;
}




增加varnishncsa的demo(日志形式输出共享内存中的log)

增加varnishtop,varnishstat

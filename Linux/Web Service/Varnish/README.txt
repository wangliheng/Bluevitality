

监听的本机地址与端口
VARNISH_LISTEN_ADDRESS=172.16.253.190
VARNISH_LISTEN_PORT=80

使用内存存储
VARNISH_STORAGE="malloc,1G"

与后端服务器连接的超时时间
VARNISH_TTL=120



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

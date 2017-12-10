vcl 4.0;                                                    #版本兼容性

backend default {                                           #定义后端主机
    
    .host = "172.16.252.205";                               #Host:port
    .port = "80";
    
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .probe = check;
}


vcl 4.0;
import directors; 导入模块
probe check { 健康检查参数
    .url = "/"; 检查的路径
    .window = 8; 检查次数
    .threshold = 4; 最小健康次数
    .interval = 2s; 检查频率2秒一次
    .timeout = 1s; 超时时长
}
backend default { 定义后端主机
       .host = "172.16.252.205";
       .port = "80";
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .max_connections = 50;
    .probe = check;
}
backend pic {
    .host = "172.16.253.145";
    .port = "80";
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .max_connections = 50;
    .probe = check;
}
sub vcl_init {
    new grouphost = directors.round_robin();
    grouphost.add_backend(default);
    grouphost.add_backend(pic);
}
sub vcl_recv {
    set req.backend_hint = grouphost.backend();
｝




vcl 4.0;
import directors; 导入模块
probe check { 健康检查参数
    .url = "/"; 检查的路径
    .window = 8; 检查次数
    .threshold = 4; 最小健康次数
    .interval = 2s; 检查频率2秒一次
    .timeout = 1s; 超时时长
}
backend default { 定义后端主机
       .host = "172.16.252.205";
       .port = "80";
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .max_connections = 50;
    .probe = check;
}
backend pic {
    .host = "172.16.253.145";
    .port = "80";
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .max_connections = 50;
    .probe = check;
}
sub vcl_init {
    new grouphost = directors.hash();
    grouphost.add_backend(default，1);
    grouphost.add_backend(pic，1);
}
sub vcl_recv {
    set req.backend_hint = grouphost.backend(req.http.cookie);
｝

# configure
vcl 4.0;
import directors;
probe check {
    .url = "/";
    .window = 8;
    .threshold = 4;
    .interval = 2s;
    .timeout = 1s;
}
backend default {
    .host = "172.16.252.205";
    .port = "80";
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .max_connections = 50;
    .probe = check;
}
backend pic {
    .host = "172.16.253.145";
    .port = "80";
    .connect_timeout = 0.5s;
    .first_byte_timeout = 20s;
    .between_bytes_timeout = 5s;
    .max_connections = 50;
    .probe = check;
}
sub vcl_init {
    new grouphost = directors.round_robin();
    grouphost.add_backend(default);
    grouphost.add_backend(pic);
}
acl purgers {
    "localhost";
    "127.0.0.1";
    "172.16.253.190";
}
sub vcl_recv {
    set req.backend_hint = grouphost.backend();
    if (req.url ~ "(?i)^/admin") {
        return(pass);
    }
    if (req.method == "PURGE"){
        if (client.ip !~ purgers) {
            return (synth(444,"Not enough authority to " + client.ip));
        }
        return(purge);
    }

    if (req.method == "BAN") {
        if (client.ip !~ purgers) {
            return (synth(444,"Not enough authority to " + client.ip));
        }
        ban("req.http.host == " + req.http.host + " && req.url == " + req.url);
        return(synth(200,"Ban Added"));
    }
/*  if (req.http.User-Agent ~ "(?i)curl") {
        return (synth(405,"No good"));
    }
*/
    if (req.restarts ==0) {
        if (req.http.X-Forwarded-For) {
            set req.http.X-Forwarded-For = req.http.X-Forwarded-For + "," + client.ip;
        } else {
            set req.http.X-Forwarded-For = client.ip;
        }
    }
}
sub vcl_backend_response {
    if (beresp.http.cache-control !~ "s-maxage") {
        if (bereq.url ~ "(?i)\.(jpg|jpeg|gif|png|css|js)$") {
            unset beresp.http.Set_Cookie;
            set beresp.ttl = 7200s;
        }
    }
}

sub vcl_deliver {
    if (obj.hits>0) {
        set resp.http.X-Cache = "HIT from " + server.ip;
    } else {
        set resp.http.X-Cache = "MISS from " + server.ip;
    }
}

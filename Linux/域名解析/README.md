#### named.zwtzwt.com
```
$TTL    600
@ IN SOA linux.yft.com. root.linux( 
                    2006102001  ;解析库的版本号
                    28800       ;主丛服务器周期性同步的时间间隔；time默认单位秒，也可使用1D，1H等代替
                    14400       ;主服务器为响应丛服务器后丛服务器的重试时间间隔
                    720000      ;主服务器一直未响应；丛服务器解析库失效时长
                    86400       ;无效主机名否定答案的统一缓存时长
)
@	IN		NS			www.zwtzwt.com.
www	IN		A			172.16.10.76
	IN		mx 19	    mail.zwtzwt.com.
pop3	IN		CNAME	    mail.zwtzwt.com.
mail	IN		A			172.16.10.77
ftp     IN		CNAME		www
forum   IN		CNAME		www
winxp   IN		A			172.16.10.48
```

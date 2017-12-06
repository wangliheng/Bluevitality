#### 备忘
```bash
#ansible在c/s间免密钥认证
[root@test ~]# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
3a:69:c8:3e:25:22:0e:85:b2:9f:0b:eb:ad:ca:2c:c3 root@test
The key's randomart image is:
+--[ RSA 2048]----+
|                 |
|                 |
| .               |
|o .              |
|.o      S        |
|+ .....o         |
|=o ooo=          |
|=E+... .         |
|**oo..           |
+-----------------+
[root@test ~]# ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.0.3
The authenticity of host '192.168.0.3 (192.168.0.3)' can't be established.
ECDSA key fingerprint is 02:c2:94:a0:8d:08:bd:b6:03:a1:1e:24:d6:be:e1:3f.
Are you sure you want to continue connecting (yes/no)? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@192.168.0.3's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh '192.168.0.3'"
and check to make sure that only the key(s) you wanted were added.

```

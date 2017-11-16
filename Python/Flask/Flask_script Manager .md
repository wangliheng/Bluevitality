这个Manager说简单些就是在python xxxxx.py 后面可指定其代码内定义的函数名及一些参数来运行（提供SHELL）
### Demo1
```python
#!/usr/bin/env python
#coding=utf-8

from flask import Flask
from flask_script import Manager  
from flask_script import Command 

app=Flask(__name__)
 
manager = Manager(app)  

@manager.command  
def hello():  
    'This is help info'  
    print 'Hello ~'  
  
if __name__ == '__main__':  
    manager.run()  
    
# OR：
#class Hello(Command):  
#    'hello world'  
#    def run(self):  
#        print 'hello world'  
#  
#manager.add_command('hello', Hello())  
  
if __name__ == '__main__':  
    manager.run()  
```
```bash
#执行如下命令：
[root@localhost /]# python py 
usage: py [-?] {hello,shell,runserver} ...

positional arguments:
  {hello,shell,runserver}
    hello               This is help info
    shell               Runs a Python shell inside Flask application context.
    runserver           Runs the Flask development server i.e. app.run()

optional arguments:
  -?, --help            show this help message and exit
[root@localhost /]# python py hello
Hello ~
```

#### Demo2
```python
#-*-coding:utf8-*-  
from flask_script import Manager  
from debug import app  
  
manager = Manager(app)  
 
@manager.option('-n', '--name', dest='name', help='Your name', default='world')  
@manager.option('-u', '--url', dest='url', default='www.csdn.com')  
def hello(name, url):  
    'hello world or hello <setting name>'  
    print 'hello', name  
    print url  
  
if __name__ == '__main__':  
    manager.run()  
```
```bash
#运行方式如下：
root@localhost ~]# python manager.py hello
> hello world
> www.csdn.com
root@localhost ~]# python manager.py hello -n sissiy -u www.sissiy.com
> hello sissiy
> www.sissiy.com
```

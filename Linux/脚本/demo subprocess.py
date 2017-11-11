#!/usr/bin/env python

"""
subprocess模块是从2.4版本开始引入的。主要用来取代一些旧的模块如 os.system、os.spawn*、os.popen*、commands.* 等...
subprocess通过子进程来执行外部指令并通过 input/output/error 管道，获取子进程的执行的返回信息
"""

# demo1
import subprocess
"""
在一些复杂场景中，我们需要将一个进程的执行输出作为另一个进程的输入。
在另一些场景中，我们需要先进入到某个输入环境，然后再执行一系列的指令等。这个时候就要用到Popen()
参数：
args：                 shell命令，可以是字符串，或者序列类型，如list,tuple。
bufsize：              缓冲区大小，可不用关心
stdin,stdout,stderr：  分别表示程序的标准输入，标准输出及标准错误
shell：                与上面方法中用法相同
cwd：                  设置子进程的当前目录
env：                  指定子进程的环境变量。若 env=None 则默认从父进程继承环境变量
universal_newlines：   不同OS的换行符不同，当该参数为true时表示使用\n作换行符
"""
s=subprocess.Popen('ls', shell=True, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
s.stdin.write('print 1 \n')
s.stdin.write('print 2 \n')
s.stdin.write('print 3 \n')
print s.stdout.read()
print s.stderr.read()
print s.wait()         # 等待子进程结束。并返回执行状态 shell 0为正确
s.stdout.close()
s.stderr.close()


# demo2
import subprocess
"""
subprocess.call()：执行命令，并返回执行状态，其中shell参数为False时，命令需要通过列表的方式传入，当shell为True时，可直接传入命令
"""
>>> a = subprocess.call(['df','-hT'],shell=False)
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda2     ext4     94G   64G   26G  72% /
tmpfs        tmpfs    2.8G     0  2.8G   0% /dev/shm
/dev/sda1     ext4    976M   56M  853M   7% /boot

>>> a = subprocess.call('df -hT',shell=True)
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda2     ext4     94G   64G   26G  72% /
tmpfs        tmpfs    2.8G     0  2.8G   0% /dev/shm
/dev/sda1     ext4    976M   56M  853M   7% /boot

>>> print a
0

# demo3
import subprocess
"""
subprocess.check_call()：用法与subprocess.call()类似，区别是，当返回值不为0时，直接抛出异常
"""
>>> a = subprocess.check_call('df -hT',shell=True)
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda2     ext4     94G   64G   26G  72% /
tmpfs        tmpfs    2.8G     0  2.8G   0% /dev/shm
/dev/sda1     ext4    976M   56M  853M   7% /boot
>>> print a
0
>>> a = subprocess.check_call('dfdsf',shell=True)
/bin/sh: dfdsf: command not found
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/lib64/python2.6/subprocess.py", line 502, in check_call
    raise CalledProcessError(retcode, cmd)
subprocess.CalledProcessError: Command 'dfdsf' returned non-zero exit status 127
  
  
#注：
# subprocess.check_output() 与上面两个方法类似，区别是如果当返回值为0时，直接返回输出结果，若返回值不为0则抛出异常
# 需要说明的是该方法在python3.x中才有

# demo4
#将一个子进程的输出，作为另一个子进程的输入
import subprocess
child1 = subprocess.Popen(["cat","/etc/passwd"], stdout=subprocess.PIPE)
child2 = subprocess.Popen(["grep","0:0"],stdin=child1.stdout, stdout=subprocess.PIPE)
out = child2.communicate()

# Other
import subprocess
child = subprocess.Popen('sleep 60',shell=True,stdout=subprocess.PIPE)
child.poll()          #检查子进程状态
child.kill()          #终止子进程
child.send_signal()   #向子进程发送信号
child.terminate()     #终止子进程



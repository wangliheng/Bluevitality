> 表达式可使用单引号引用，但若表达式内部包含变量字符串，则需使用双引号( 单引号内的变量不可以被替换 )  
> 通常来说一行被读进模式空间，并且用脚本中的每个命令(一个接一个的)应用于该行  
> 当到达脚本底部时输出此行并清空模式空间。然后新行被读入，并且控制被转移回脚本的顶端  

### 选项与参数
```bash
命令格式：
sed [options] 'command' file(s)
sed [options] -f scriptfile file(s)
选项：
-n 默认不输出模式空间中未被改变的内容
-i 直接对源文件进行修改（默认仅修改其读入的数据）
-e 允许在同一行里执行多条命令 eg： sed -i -e 's/1/2/g' -e 's/a/b/g'
-f 调用sed脚本文件

参数汇总：
a 在当前行下面插入文本
i 在当前行上面插入文本
c 修改当前行的文本
r 从其指定的文件中读行（r filename）
w 将模式空间内容追加到文件（w filename）
W 将模式空间第一行内容追加到文件（W filename）
d 删除当前行
D 删除模式空间内的第一行内容并且重头执行sed脚本顶端的命令
s 替换指定字符 注：代码块“{}” 表示即将要在定位执行的命令组，命令之间用"；"分割
l 列表不能打印字符的清单
h （hold）拷贝模式空间内容到保持空间
H （hold）追加模式空间内容到保持空间  eg：sed -e '/test/H' -e '$G' --->  将含test的行全部追加到文件末尾
g （get）取得保持空间内容，并替代当前模式空间 eg： sed 'G' ---> 在每行后面加入空行
G （get）取得保持空间内容，并在当前模式空间追加一行
x （Exchange）将模式空间与保持空间的内容相互转换 eg：sed -e '/A/h' -e '/B/x' --->将A与B关键字所在行互换
n 读取下一行输入，用其后的命令处理新的行而非从头开始执行命令 eg：sed -n 'p;n' file ---> 打印奇数行
N 追加下一行输入到当前模式空间并在二者间嵌入换行符且改变当前行号码
p 输出模式空间内容 eg： sed -n '1~2p' ---> 输出奇数行（从第1行算起每2行输出1次）
P (大写) 输出模式空间内第一行内容
= 打印当前行号 eg： sed -n '/root/=' ---> 输出root关键字所在行的行号（相当于：grep -n 'root'）
b lable 分支到脚本中带有标记的地方，若分支不存在则分支到脚本末尾
t label if分支，从末行开始，若满足或T/t将导致分支到带有标号的命令处，或到脚本的末尾
T label 错误分支，从末行开始，若发生错误或者T/t将导致分支到带有标号的命令处，或到脚本的末尾
! 排除，即对未被选定的部分执行后面的操作
# 把注释扩展到下一个换行符以前
q 退出  eg：sed '10q' file ---> 打印完第10行后退出
g 全部替换  eg：sed 's/A/B/g' ---> 将所有A改为B， sed 's/A/B/2' ---> 将所有A改为B并且仅替换2次
p 打印当前模式内容 
y 将单个字符转为其他字符（不用于正则）  eg：sed 'y/123/abc/g' ---> 将1替换为a，2替换为b，3替换为...
\1 此处数字即匹配模式中分组的下标  eg：sed -E 's/(123).*(789)/\2\1/' ---> 将789与123的位置互换
& 被匹配模式匹配住的所有内容  eg：sed 's/123/"&"/g' ---> 将123替换为"123"
```
### 界定符号
```bash
's'命令将其右边紧挨着的任意一个字符作为界定符使用，因此以下操作是一样的：
sed -n 's:test:TEXT:g'
sed -n 's|test|TEXT|g'
sed -n 's!test!TEST!g'

定界符出现在模式中时需转义：
sed 's/\/bin/\/usr\/local\/bin/g'
```

### example
```bash
sed '2,$d'          删除文件的第2行到末尾所有行
sed '/ccc/{x;p;x;}' 在匹配行前加入一个空行  
sed '{N;s/\n/\t/;}' 将偶数行与其上面的奇数行合并为一行（N将第2行追加到模式空间，此时模式空间2行，然后替换换行符）
sed 10q             显示前10行
sed '{$!N;$!d;}'    输出最后两行
sed '{1!G;h;$!d;}'  模拟tac命令进行逆序输出
sed '{n;d;}'    删除偶数行
sed '{n;G;}'    在偶数行后添加一个新行
sed '{n;n;G;}'  在第 3,6,9,12,… 行后插入一个空行
sed '2,$d'      删除文件的第2行到末尾所有行
sed '$d' file   删除文件最后一行
sed '$!N;$!D'   显示后两行，模拟tail -2
sed '/^$/d'     删除空白行
sed '表达式;表达式'	        等价于：sed '表达式' | sed '表达式'
sed -n '/test/,/check/p' 	输出含test的行到check的行之间的数据
sed -n '5,/^test/p' 		输出第5行到以test开头的行之间的数据
sed '$!N;s/\n/ /'           将2行链接生成一行，模拟paste
sed -n '/regexp/{g;1!p;};h' 查找"regexp"并仅将匹配行的上一行输出
sed -n '/regexp/{n;p;}'     查找找"regexp"并仅将匹配行的下一行输出
sed -n '/^.\{65\}/p'        显示包含65个或以上字符的行
sed '/baz/!s/foo/bar/g'     将“foo”替换成“bar”，且只在行未出现字串“baz”时替换
sed -e :a -e '$d;N;2,10ba' -e 'P;D'             删除最后10行
sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//'   模拟rev命令倒置行字串输出
sed -n '3~7p'   从第3行开始，每7行显示一次（或：sed -n '3,${p;n;n;n;n;n;n;}'）
gsed '0~8d'     删除8的倍数行
sed -n '$='     模拟wc -l
```
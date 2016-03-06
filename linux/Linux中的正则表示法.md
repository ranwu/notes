|特殊符号|代表意义|
|----|----|
|[:alnum:]|代表英文大小写字符以及数字|
|[:alpha:]|代表英文大小写字符|
|[:blank:]|代表空格键与[Tab]按键两者|
|[:cntrl:]|代表键盘上面的控制按键，也包括CR,LF,Tab,Del等|
|[:digit:]|代表数字|
|[:graph:]|除了空格符外的其他所有按键|
|[:lower:]|代表小写字符|
|[:print:]|可以被打印出来的字符|
|[:punct:]|代表标点符号（punctuation symbol）, 亦即："'?!;:#$...|
|[:upper:]|大写字符|
|[:space:]|任何会产生空白的字符|
|[:xdigit:]|16进制数字类型|

用dmesg列出核心信息，再以grep找出eth那行

```
dmesg | grep 'eth'
```

承上， 给上面的结果加上行号和颜色

```
dmesg | grep -n --color=auto 'eth'
```

承上，显示出关键行所在前三行和后三行

```
dmesg | grep -n -A3 -B2 --color=auto 'eth'
```

反向选择

```
grep -vn 'the' regular_express.txt
```

取得不论大小写的the这个字符串则：

```
grep -in 'the' regular_express.txt
```

```
grep -n 't[ae]st' regular_express.txt
```
[ae]这里面的内容表示只能匹配一个，可以是`a`，或`e`。

如果我不想oo前面有g的话呢？此时可以利用反向选择

```
grep -n '[^g]oo' regular_express.txt
```

不要小写字母的另一种写法

```
grep -n '[^[:lower:]]oo' regular_express.txt
```

只显示带有数字的行

```
grep -n '[[:digit:]]' regular_express.txt
```

想开头不是字母

```
grep  -n '^[^[:alpha:]]' regular_express.txt
grep -n '^[^a-zA-Z]' regular_express.txt
```

tail 是从文件的后面开始取，比如，取文件的后6行：
```
tail -n6
```

找出空白行：
```
grep -n '^$' regular_express.txt
```

点号`.`代表一定有一个任意字符

星号`*`代表重复前一个0到无穷多次，为组合形态。

假设我们要找出g后面接2到5个o，然后接一个g的字符串，他会是这样：
```
grep -n 'go\{2,5\}g' regular_express.txt
```

### sed 工具

sed本身是一个管线命令，可以分析standard input。可以将数据进行取代、删除、新增、截取等功能。

```
-n 只有经过sed特殊处理的那一行才会被列出来。
-e 直接在指令列模式上进行sed的动作编辑。
-f 直接将sed的动作写在一个档案内，-f filename 则可以执行filename内的sed动作;
-r sed的动作支持的是延伸型正则表达式的语法
-i 直接修改读取的档案内容，而不是由屏幕输出。

动作说明：[n1[,n2]]function
n1,n2: 不见得会存在，一般代表选择进行动作的行数，举例来说，如果我的动作是需要在10到20行之间进行的，则「10,20[动作行为]」
function底下的东西：

a: 新增，a的后面可以接字符串，而这些字符串会在新的一行出现（目前的下一行）
c: 取代，c后面可以接字符串，这些字符串可以取代n1,n2之间的行！
d: 删除
i: 插入，i的后面可以接字符串，而这些字符串会在新的一行出现
p: 打印，即将某个选择的数据打印出来。通常p会与参数sed -n 一起运作
s: 取代，可以直接进行取代的工作哩。通常这个s的动作可以搭配正则表示法。
```	
`nl` 就是将内容带上行号显示出来

如果要删除从3行到最后的内容：
```
nl /etc/passwd | sed '3,$d'
```

在第二行后面加入内容：
```
nl /etc/passwd | sed '2a drink tea'
```

将2-5行替换为指定的内容：
```
nl /etc/passwd | sed '2,5c No 2-5 number'
```

仅列出/etc/passwd档案内的第5-7行
```
nl /etc/passwd | sed -n '5,7p'
```

搜索并替代：

```
sed 's/要被取代的字符/新的字符/g'
```

grep的进阶用法：

```
grep [-A] [-B] [--color=auto] '搜寻字符串' filename

选项与参数:

-A : 后面可加数字，为after的意思，除了列出该行外，后续的n行也列出来;
-B：后面可加数字，为before的意思，除了列出该行以外，前面的n行也列出来

============ 例子 =====================
范例三：打印出eth的内容的前2行和后三行
dmesg | grep -n -A3 -B2 --color=auto 'eth'
```

取出IP地址的那一行，基于我的电脑：
```
ip addr | grep -n -A2 '^3' | tail -n 1
```

删除IP地址前面的内容：
```
ip addr | grep -n -A2 '^3' | tail -n 1 \ 
| sed 's/^.*inet.//g'
```

删除IP地址后面的内容：
```
ip addr | grep -n -A2 '^3' | tail -n 1 \ 
| sed 's/^.*inet.//g' | sed 's/brd.*//g'
```

删除man.conf的批注之后的数据：
```
cat /etc/man.config | grep 'MAN'|sed '/#.*$//g'
```

sed 删除操作
```
sed '/^$/d'
```

利用sed替换原文内容：
```
sed -i 's/\.$/\!/g' regular_express.txt
```



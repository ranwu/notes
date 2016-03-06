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

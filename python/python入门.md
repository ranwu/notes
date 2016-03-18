### 帮助信息

<object>.__doc__会显示其文档：

```python
abs.__doc__
```

dir()显示该对象的所有方法

如果需要查看某个对象是如何工作的：

```python
help(<object>)
```

### 语法
缩进表示一个代码块的开始，逆缩进表示一个代码块的结束。

声明以冒号(:)字符结束，并且开始一个缩进级别。

单行注释以井号字符(#)开头，多行注释则以多行字符串的形式出现。

赋值（实际上是将对象绑定到名字）通过等号`=`实现，`==`则是判断。

可以在一行上使用多个变量。

`r''` 中的内容不用转义：
```python
>>>print(r'\\\t\\')
\\\t\\
```

空值，用`None`表示，python还提供了列表、字典等多种数据类型。

在Python中，变量不仅可以是数字，还可以是任意数据类型。

这种变量本身类型固定不变的语言称之为动态语言，与之对应的是静态语言。

多行输出：
```python
print('''line1
... line2
... line3''')
```

```python
a = 'ABC'
```
Python 解释器现在干了两件事：
1. 在内存中创建了一个‘`ABC`的字符串;
2. 在内存中创建了一个名为`a`的变量，并把它指向`ABC`

python对整数没有大小限制。

### 字符编码
因为计算机只能处理数字，如果要处理文本就必须把文本转换成数字才能处理

ASCII编码和Unicode编码的区别：ASCII编码是一个1字节，而Unicode编码
通常是2个字节。

可变长编码：`UTF-8`。UTF-8编码把一个Unicode字符根据不同的数字大小编码
成1-6个字节，常用的英文字母被编码成1个字节。汉字通常是3个字节，只有很
生僻的字符才会被编码成4-6个字节。

在计算机内存中，统一使用Unicode编码，当需要保存到硬盘或者需要传输的时候
，就转换为UTF-8编码。

用记事本编辑器的时候，从文件读取的UTF-8字符被转换成Unicode字符到内存里
，编辑完成后，保存的时候再把Unicode转换为UTF-8保存到文件。

浏览网页的时候，服务器会把动态生成的Unicode内容转换为UTF-8再传输到
浏览器

*Python的字符串*

最新的Python3版本中，字符串是以Unicode编码的，也就是说，Python的字符串
支持多语言。

对于单个字符的编码，Python提供了`ord()`函数获取字符串的整数表示，
`chr()`函数把编码转换为对应的字符

由于Python的字符串类型是`str`，在内存中以Unicode表示，一个字符对应
若干个字节。如果要在网络上传输，或者保存到磁盘上，就需要把`str`变为
以字节为单位的`bytes`。

Python对于`bytes`类型的数据用带`b`前缀的单引号或双引号表示：
```python
x = b'ABC'
```

在`bytes`中，无法显示为ASCII字符的字节，用`\x##`显示。

反过来，如果我们从网络或磁盘上读取了字节流，那么读到的数据就是`bytes`
。要把`bytes`变为`str`，就需要用到`decode()`方法。

计算`str`包含多少个字符，可以用`len()`函数。

`len()`函数计算的是`str`的字符数，如果换成`bytes`，`len()`函数就计算
字节数。
```python
len('中文'.encode('utf-8'))
6
```

1个中文字符经过UTF-8编码后通常会占用3个字节，而1个英文字符只占用1个字节。

保证源文件为UTF-8，在文件开头写上：
```
#!/usr/bin/env python3
# _*_ coding: utf-8 _*_
```

*格式化*

python的格式化字符串和c语言是一致的。用`%`实现。

例子：
```python
'Hello, %s' %'world'

'Hi, %s, you have $%d.' %('Michael', 10000)
```

常见的占位符有：
|符号|意义|
|----|----|
|%d|整数|
|%f|浮点数|
|%s|字符串|
|%x|十六进制整数|

格式化整数和浮点数还可以指定是否补0和整数与小数的位数：
```python
'%2d-%02d' %(3,1)
'%.2f' %3.1415926
```

有些时候，字符串里面的`%`是一个普通字符怎么办？这个时候就需要转义，
用`%%`来表示一个`%`：
```python
'growth rate: %d%%' % 7
```

list 是python内置的数据类型，list是一种有序的列表，可以随时添加和删除其中的
元素。

取最后一个元素：
```python
classmaets[-1]
```
以此类推，最后第二个就是:
```python
classmates[-2]
```
等等。

附加元素到list：
```python
classmates.append('Adam')
```

把元素插入到指定位置：
```
classmates.insert(1, 'Jack') # 在下标为1的位置插入元素
```

删除末尾的元素：
```
classmates.pop() #删除末尾的元素并返回此数
```

删除指定位置的元素：
```
classmates.pop(1) #删除下标为1的元素
```

list里面的元素的数据类型可以不同：
```python
L = ['Apple', 123, True]
```

可以嵌套list：
```
s = ['python', 'java', ['asp', 'php'], 'schema']
```

*tuple*

tuple和list非常类似，但是tuple一旦初始化就不能更改了。
```
classmates = ('Michael', 'Bob', 'Tracy')
```
现在classmates这个tulpe不能改变了，它没有`append()`，`insert()`这样的方法。
其他获取元素的方法和list是一样的，可以正常使用`classmates[0]`, `classmates[-1]`
，但不能赋值成另外的元素。

在定义一个tuple的时候，元素必须确定下来。

如果要定义一个空的tuple，可以写成`()`
```
t = ()
```

定义只有一个元素的tuple：
```
t = (1)
```

python的缩进规则，如果`if`语句判断是`True`，就把缩进的两行print语句执行了，否则，
什么也不做。
```python
age = 20
if age >= 18:
    print('your age is', age)
    print('adult')
```
也可以给`if`添加一个`else`语句，意思是，如果`if`判断是`False`，不要执行`if`的内容，
去把`else`执行了：
```python
age = 3
if age >= 18:
    print('your age is', age)
    print('adult')
else:
    print('your age is', age)
    print('teenager')
```

`elif`的用法：
```
age = 3
if age >= 18:
    print('adult')
elif age >= 6:
    print('teenager')
else:
    print('kid')
```

*input*

`input()`读取用户的输入：
```
s = input('birth: ')
birth = int(s)
if birth < 2000:
    print('00前')
else: 
    print('00后')
```
当我输入`1982`的时候会报错，因为`input()`返回的数据类型是`str`，而`str`不能直接
和整数比较，必须先把`str`转换成整数。用`int()`函数来完成这件事。



`if`语句执行有个特点，它是从上往下判断，如果在某个判断上是`True`，把该判断对应的
语句执行后，就忽略掉剩下的`elif`和`else`

python的循环有两种，一种是for...in循环：
```
names = ['Michael', 'Bob', 'Tracy']
for name in names:
    print(name)
```

`range()`函数可以生成一个整数序列，再通过`list()`函数可以转换为list。

### 使用dict和set

Python内置了字典：dict的支持，dict全称dictionary，在其他语言中也称为map，使用
键-值（key-value）存储，具有极快的查询速度。

把数据放入dict的方法，除了初始化时指定外，还可以通过key放入：
```python
d['Adam'] = 67
d['Adam']
67

d = {'Micheal': 95, 'Bob': 75, 'Tracy': 85}
d['Michael']
```

由于一个key只能对应一个value，所以，多次对一个key放入value，后面的值会把前面的值
冲掉。

要避免key不存在的错误，有两种方法，一是通过`in`判断key是否存在：
```
'Thomas' in d
False
```

二是通过dict提供的get方法，如果key不存在，可以返回None，或者自己指定value：
```
d.get('Thomas')
d.get('Thomas', -1)
```

返回`None`的时候Python的交互式命令行不显示结果。

要删除一个key，用`pop(key)`方法：
```
d.pop('Bob')
```

dict的特点：
1. 速度快
2. 需要占用大量内存

list特点：
1. 速度慢
2. 内存消耗少

dict的key是不可变对象。

通过key来计算位置的方法叫哈希算法(Hash)。

在Python中，字符串、整数等都是不可变的，因此可以放心地作为key。而list是可变的，
就不能作为key：

set和dict类似，也是一组key的集合，但不存储value。

由于key不能重复，所以，在set中，没有重复的key。

重复元素在set中自动被过滤：
```
s = set([1, 1, 2, 2, 3, 3])
s
{1, 2, 3}
```

通过`add(key)`方法可以添加元素到set中，可以重复添加，但不会有效果。

set可以看成数学意义上的无序和无重复元素的集合，因此，两个set可以做数学意义上的
交集、并集等操作：
```python
s1 = set([1, 2, 3])
s2 = set([2, 3, 4])
s1 & s2
s1 | s2
```

对于不变对象来说，调用对象自身的任意方法，也不会改变该对象自身的内容。相反这些
方法会创建新的对象并返回。这样，就保证了不可变对象本身是不可变的。

绝对值：`abs`
交互命令行查看帮助信息：`help(abs)`

`max`返回最大的数

### 数据类型转换



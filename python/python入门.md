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
```
int()
```

### 定义函数
```python
def my_abs(x):
    if x >= 0:
        return x
    else:
        return -x
```

`return None`可以简写为`return`

如果已经把`my_abs()`的函数定义保存为`abstest.py`文件了，那么，可以在
该文件的当前目录下启动Python解释器，用`from abstest import my_abs`来
倒入`my_abs()`函数

### 空函数
```python
def nop():
    pass
```
`pass`语句什么都不做，实际上， pass可以用来作为占位符，比如现在还没想好
怎么写函数的代码，就可以先放一个`pass`，让代码能运行起来。

`pass`还可以用在其他语句里，比如：
```python
if age >= 18:
    pass
```
缺少了pass会有语法错误。

### 参数检查
调用函数时，如果参数个数不对，Python解释器会自动检查出来，并抛出`TypeError`:

对`my_abs`做类型检查，只允许整数和浮点数类型的参数。数据类型检查可以用
内置函数`isinstance()`实现：
```python
def my_abs(x):
    if not isinstance(x, (int, float)):
        raise TypeError('bad operand type')
    if x >= 0:
        return x
    else:
        return -x
```

### 返回多个值

比如在游戏中经常需要从一个点移动到另一个点，给出坐标，位移和角度，就
可以计算出新的坐标：
```python
import math

def move(x, y, step, angle=0):
    nx = x + step * math.cos(angle)
    ny = x - step * math.sin(angle)
    return ny, ny
```

在语法上，返回一个tuple可以省略括号，而多个变量可以同时接收一个tuple，
按位置赋给对应的值，所以Python的函数返回多值其实就是返回一个tuple。

小结：
1. 定义函数时，需要确定函数名和参数个数;
2. 如果有必要，可以先对参数的数据类型做检查;
3. 函数体内部可以用`return`随时返回函数结果;
4. 函数执行完毕也没有`return`语句时，自动`return None`
5. 函数可以同时返回多个值，但其实就是一个tuple

Python的函数定义非常简单，但灵活度非常大。除了正常定义的必选参数之外，还可以
使用默认参数、可变参数和关键字参数，使得函数定义出来的接口，不但能处理复杂的参数
，还可以简化调用者的代码。 

**默认参数：**

```python
def power(x, n=2):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s
```

设置默认参数需要注意的地方：
1. 必选参数在前，默认参数在后，否则Python的解释器会报错
2. 如何设置默认参数。当函数有多个参数时，把变化大的参数放前面，变化小的参数放后面
。变化小的参数可以作为默认参数。

定义默认参数必须指向不变对象。

**可变参数：**

定义一个可变参数：
```python
def calc(*numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum 
```

如果已经有一个list或tuple，要调用一个可便参数怎么办？
```python
nums = [1, 2, 3]
calc(nums[0], nums[1], nums[2])
```
上面这种写法太繁琐，所以Python允许你在list或tuple前面加一个`*`号把list或tuple的元素
变成可变参数传进去：
```python
nums = [1, 2, 3]
calc(*nums)
```

**关键字参数**

可变参数允许你传入0个或任意个参数这些参数在函数调用时自动组装为一个tuple。而
关键字参数允许你传入0个或任意个含参数名的参数。这些关键字参数在函数内部自动组装
为一个dict。

```python
def person(name, age, **kw):
    print('name:', name, 'age:', age, 'other:',kw)
```
函数`person`除了必选参数`name`和`age`外，还接受关键字参数`kw`。在调用该函数时，
可以只传入必选参数：
```python
person('Michael', 30)
```

也可以传入任意个数的关键字参数：
```python
person('Bob', 35, city='Beijing')
person('Adam', 45, gender='M', job='Eengineer')
```

###迭代

方式：
1. for.. in... //默认键迭代
2. for value in d.vaues() //值迭代
3. for k, v in d.items() //值和键迭代

collections.iterable //判断对象是否可迭代

方法：
```
isinstance(<object>, Iterable)
```

enumerate()函数把list变成索引-元素对。

任何可迭代对象都可以作用于`for`循环，包括我们自定义的数据类型，只要符合迭代条件，就
可以使用`for`循环。

```python
d = {'x':'A', 'y':'B', 'z':'C'}
[k + '=' + v for k, v in d.items()]
['y=B', 'x=A', 'z=C']
```

把`list`，`dict`, `str`等`Iterable`变成`Iterator`可以使用`iter()函数

凡是可作用于`for`循环的对象都是`Iterable`类型;

凡是可作用于`next()`函数的对象都是`Iterator`类型，它们表示一个惰性计算的序列;

可通过`iter()`函数来获得一个`Iterator`对象。

python的`for`循环本质上就是通过不断调用`next()`函数实现的。

由于`abs`函数实际上是定义在`__builtin__`模块当中，所以要让修改`abs`变量的指向在其他模块也生效，要用
`__builtin__.abs = 10`

`reduce`把结果继续和序列的下一个元素做累积运算。

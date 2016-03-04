type: 这个命令用来查看命令是属于bash外部命令还是bash内建命令。

不加参数时，会显示是外部命令还是内部命令。

当加入 `-t` 参数时，type会以底下这些字眼显示出其他的意义：

```
file: 表示为外部指令;
alias: 表示该命令为别名的名称
builtin: 表示该指令为bash内建的指令功能
-p：如果后面接的name为外部指令时，才会显示完整文件名
-a: 会由PATH变量定义的路径中，将所有包含name的指令都列出来，包含alias
```

如果type 后面的指令名称没有找到，那么该名称是不会被显示出来的，type主要是找出可执行文件，而不是一般的文件。可以作为类似which指令的用途。

在shell内用脱字符 `\` 表示转义。

扩增变量内容：

``` 
PATH="$PATH":/home/bin
```
上面这句话也是给PATH变量添加路径的方式。

如果该变量需要在其他子程序执行：

```
export PATH
```

取消变量的设置：

```
unset name
```

一般情况下，父程序的自定义变量无法在子程序内使用的。

核心模块目录：
```
/lib/modules/
```

查看和某个命令或文件相关的目录：

```
locate name
```

要活用bash的变量，比如我想到达某个目录，但这个目录太复杂，那么我可以将这个目录放在一个变量中，然后我就可以在任何地方引用这个变量了。

```
work="/home/ranwuer/test"
cd $work
```

查看目前shell环境中的默认环境变量：

```
可用env 和export
```

env变量存储了很多有用的信息：

- 家目录
- SHELL
- HISTSIZE，历史记录大小
- MAIL，当我们使用mail这个指令收信时，系统会去读取mailbox

在bash下生成随机数：

```
echo $RANDOM
```

产生一个0～32767之间的随机数。

如果想产生一个0～9的随机数呢？

```
declare -i number=$RANDOM*10/32768; echo $number
```

首先用`declare`声明一个整形变量`number`，由于`$RANDOM`产生的是5位数字的随机数，那么当这个数字乘以10,就扩大了10倍，也就是6位数字了，当再除以32768时，取整的话，刚好是1位数字，也就是0-9。

`set`除了显示bash的环境变量外，还会显示其他变量。

基本上，在Linux预设的情况下，使用{大写的字母}来设定的变量一般为系统内定需要的变量。

给PS1变量设置内容，可以改变shell提示符的显示方式：

- \d: 日期格式
- \H: 完整的主机名
- \h: 主机名逗号之前的内容
- \t: 显示时间，24小时「H:M:S」
- \T: 显示时间，12小时
- \A: 显示时间，24小时[H:M]
- \@: 显示时间，12小时「am:pm」
- \u: 目前使用者帐号
- \v: bash的版本
- \w: 完整的工作目录
- \W: 利用basename函数取得工作目录名称，所以仅仅会列出最后一个目录名
- \#: 下达的第几个指令
- \$: 如果是root，则为#，其他则为$

`$` 钱字号本身也表示一个变量，想要知道shell的进程ID（PID）号，就用`echo $$`

`?` 问号是关于上一个命令的回传值。成功执行就会返回0.

在bash中，子程序会继承父程序的环境变量，子程序不会继承父程序的自定义变量。

查看系统支持的语系：

```
locale -a
```

事实上，如果其他的语系变量都未设定。如果在系统中设置LANG或LC_ALL时，则其他语系变量会被这两个变量替代。

查看系统默认支持的语系：

```
cat /etc/sysconfig/i18n
```

`read`用来读取来自键盘的输入。

```
read -p “提示符” -t 30 named
```

提示用户在30秒内输入内容到named。

设置变量类型：declare/typeset

declare语法：

```
declare [-aixr] variable

-a 定义为数组类型
-i 定义为整型
-x 将变量变成环境变量
-r 将变量设为只读，说明此变量不能被更改，不能被unset
```

在默认情况下，bash对变量有几个基本的定义：

1. 变量类型为字符串
2. bash环境中的数值运算，预设最多只能达到整型形态，所以1/3的结果为0。

取消环境变量：

```
declare +x sum
```


单独列出变量的类型：

```
declare -p sum
```

如果将变量设为只读后想取消只读，那么只有注销用户再登陆才行。

定义数组：

```
var[index]=content
```

输出一个数组的内容：

```
echo "${var[1]},${var[2]},${var[3]}"
```

`ulimit`主要是用来限制用户使用系统资源。

```
ulimit [-SHacdfltu] [配额]

-H：hard limit，严格限定，必定不会超过这个数
-S：soft limit，超过会警告
-a：列出所有的限制额度
-c：当某些程序放生错误时，系统可能会将该程序在内存中的信息写成档案。这种档案被称为核心档案
-f：此shell可以建立的最大档案容量，单位为Kbyte
-d：程序可使用的最大分段内存容量
-l：锁定内存容量
-t：可使用的最大CPU时间（秒）
-u：单一用户可以使用的最大程序数量

```

限制用户仅能建立10M以下容量的档案：

```
ulimit -f 10240

# 当尝试建立超过此容量的数据时报错
dd if=/dev/zero of=123 bs=1M count=20
File size limit exceeded
```

还原ulimit的设定最简单的方法就是注销再登陆。

打印出想要的内容：

```
echo ${path#/*:} # 删除/和：之间内容长度最短的那个
echo ${path##/*:} # 删除/和：之间内容长度最长的那个
```

上文删除的是从左往右删除，如果想从右往左删除呢？

```
echo ${path%:*bin} # 从右往左删除冒号：与bin之间的内容
```

如果只想保留第一条内容呢？

```
echo ${path%%:*bin}
```

替换内容：

```
echo ${path/bin/BIN} # 将一个bin替换为BIN
echo ${path//bin/BIN} # 将替换所有符合条件的内容
```

还有种替换方式：
```
username=${username:-root}
```

注意冒号，加上冒号后，不管变量有没有设置，都会被冒号后面的内容替换掉。

总结：

![各种替换方式总结](http://i.v2ex.co/4HdlMRdo.png)

查看变量是否有值，如果没有值便会打印出预先设置好的内容：
```
var=${str?无此变数}
```

若str存在时，则var的内容会与str相同

设置别名：

```
alias lm='ls -al | more'
```

查看有哪些别名：

```
alias
```

取消别名：
```
unalias
```

将历史记录写入 ～/.bash_history中：

```
history -w
```

执行上一个指令：

```
!!
```

执行以`!al` 开头的指令

执行第66条指令：`!66`

系统指令搜寻顺序：

```
1. 以相对/绝对路径执行指令
2. 由alias找到该指令来执行
3. 有bash内建的（builtin）指令来执行
4. 透过$PATH这个变量的顺序搜寻到的第一个指令来执行
```

编辑`/etc/motd`可以让其他登录者看到消息。

login shell: 取得bash时需要完整的登入流程的，就称为login shell，举例来说，你要由tty1～tty6登入，需要输入用户的帐号与密码，此时取得的bash就称为「login shell」了。

non-login shell: 取得bash接口的方法不需要重复登入的举动。

login shell启动时会读取的两个配置文件：

1. `/etc/profile`: 这是系统整体的设定，最好不要修改这个档案;
2. `~/.bash_profile`或`~/.bash_login`或`~/.profile`：属于使用者个人设定;

在`/etc/profile`设置内容，每个login shell 都会读取这个配置文件。

`/etc/profile`会调用的外部数据：

*/etc/inputrc*

`/etc/profile` 会主动地判断使用者有没有自定义输入的按键功能，如果没有的话，`/etc/profile`就会决定设定「INPUTRC=/etc/inputrc」这个变量。

*/etc/profile.d/\*.sh*

只要在`/etc/profile.d/`这个目录内且扩展名为`.sh`，另外，使用者能够具有r的权限，那么该档案就会被`/etc/profile`调用。如果你需要帮所有使用者设定一些共享的命令别名时，可以在这个目录底下自建扩展名为`.sh`的档案，并将所需的数据写入即可。

*/etc/sysconfig/i18n*

这个档案是由`/etc/profile.d/lang.sh`呼叫进来的，这是我们决定bash预设使用何种语系的重要配置文件。文件中最重要的就是`LANG`这个变量。

*~/.bash_profile(login shell 才会读)*

bash在读完了整体环境设定的`/etc/profile`并由此呼叫其他配置文件后，接下来则是会读取使用者的个人配置文件。以下是个人配置文件：

1. `~/.bash_profile`
2. `~/.bash_login`
3. `~/.profile`

其实 `bash` 的 `login shell` 设定只会读取上面三个文档的其中一个，而读取的顺序则是按照它来的。

如果`~/.bash_profile`存在，那么不管其他文件有没有存在，都不会被读取。

bash读取配置文件主要是透过指令「source」来读取的。同时也可以用小数点`.`来读取。

```
source ~/.bashrc
. ~/.bashrc
```

如果命令提示符号消失，那么这样做可以恢复：

复制/etc/skel/.bashrc 到你的家目录，再修订一下你所想要的内容，并用source去调用`~/.bashrc`

还有一些配置文件可能会影响到你的bash操作的：

*/etc/man.config*

这个文档规定了使用`man`的时候，`man page`的路径需要到哪里去找。

如果你是以tarball的方式来安装你的数据，那么你的`man page`可能会放置在`/usr/local/softpackage/man`里头，那个`softpackage`是你的套件名称，这个时候你就得以手动的方式将该路径加到`/etc/man.config`里头。

这个档案最重要的是`MANPATH`这个变量设定。

*~/.bash_history*

预设的情况下，我们的历史命令就记录在这里。

*~/.bash_logout*

这个档案则记录了「当我注销bash后，系统再帮我做完什么动作才离开」的意思。不过，你也可以将一些备份或者是其他你认为重要的工作写在这个档案中，那么当你离开Linux的时候，就可以解决一些烦人的事情了。

```
# 列出所有的按键与按键内容
stty -a
```

eof：End of file 的意思，代表结束输入
erase：向后删除字符
intr：送出一个interrupt（终端）的讯号给目前正在run的程序
kill：删除目前指令列上的所有文字
quit：送出一个quit的信号给目前正在run的程序
start：在某个程序停止后，重新启动它的output
stop：停止目前屏幕的输出sty
susp：送出一个terminal stop的讯号给正在run的程序

设置用 `ctrl + h` 来删除字符：

```
stty erase ^h
```

变量`$-`保存着set的设定值，一般是`himBH`

设定“若未使用未定义变量时，则显示错误信息”

```
set -u # 取消用+u
echo $vbirding
```

执行前显示该指令内容：

```
set -x
```

|组合按键|执行结果|
|----|----|
|Ctrl+C|终止目前的命令|
|Ctrl+D|输入结束（EOF），例如邮件结束的时候|
|Ctrl+M|就是Enter|
|Ctrl+S|暂停屏幕的输出|
|Ctrl+Q|恢复屏幕的输出|
|Ctrl+U|在提示字符下，将整列命令删除|
|Ctrl+Z|「暂停」目前的命令|

### 通配符

|符号|意义|
|----|----|
|*|代表0个到无穷多个任意字符|
|?|一定有一个任意字符|
|[]|同样代表「一定有一个在括号内」的字符。|
|[-]|代表在编码顺序内的所有字符。例如[0-9]代表0到9之间的所有数字|
|[^]|若中括号的第一个字符为指数符号（^），那表示「反向选择」，比如[^abc]代表一定有一个字符，只要非a，b，c的其他字符就接受的意思|

通配符汇总：

|符号|内容|
|----|----|
|#|批注符号|
|`\`|转义字符|
|`|`|管线（pipe）分隔两个管线命令的界定|
|;|连续指令下达分割符|
|~|用户的家目录|
|&|工作控制，将指令变成背景下工作|
|$|取用变数前导符：亦即是变量之前需要加的变量取代值|
|!|逻辑运算意义上的「非」not的意思！|
|/|目录符号|
|>,>>|数据流重定向，输出导向，分别是「取代」与「累加」|
|<,<<|数据流重定向：输入导向|
|‘’|单引号，不具备变量置换功能|
|""|具备变量置换功能|
|``|先行执行的命令，也可用$()|
|()|在中间为子shell的起始与结束|
|{}|在中间为命令区块的组合！|

### 标准输入与输出

数据流重定向可以将standard output(stdout)与standard error output(stderr)分别传送到其他的档案或装置去，而分别传送所用的特殊字符如下所示：

1. 标准输入 (stdin)：代码为0，使用 < 或 <<;
2. 标准输出 (stdout): 代码为1，使用 > 或 >>;
3. 标准错误输出(stderr): 代码为2,使用 2> 或 2>>;

如果只使用大于符号 `>` 那么以前的文件会被覆盖掉，而`>>`则是累加。

输出错误代码`2>`/`2>>`

将stdout与stderr分存到不同的档案去：

```
find /home -name .bashrc > list_right 2> list_err
```

### /dev/null 垃圾桶黑洞装置与特殊写法

需求：

如果我知道错误信息会发生，所以要将错误信息忽略掉，而不显示呢？

```
find /home -name .bashrc 2> /dev/null
```

将正确与错误信息输出到同一个文件：

```
find /home -name .bashrc &> list
```

### standard input : < 与 <<

利用cat来建立一个档案的简单流程：

```
cat > catfile
testing
cat file test
<==这里按下[ctrl]+d离开
```

用stdin取代键盘的输入以建立新档案的简单流程

```
cat > catfile < ~/.bashrc
```

这句话的意思是用bashrc来代替键盘的输入以表示catfile的输入内容。就等于是复制了。

`<<`代表结束的输入字符：

```
cat > catfile << "eof"
```

###命令执行的判断依据： `;, &&, ||`

分号`;`可以在一行中敲入两条指令比如：

```
sync;sync;shutdown -h now
```

|指令下达情况|说明|
|cmd1&&cmd2|1.若cmd1执行完毕且正确执行($?=0)，则开始执行cmd2。2.若cmd1执行完毕且为错误($?!=0),则cmd2不执行。|
|cmd1`||`cmd2|1.若cmd1执行完毕且正确执行($?=0)，则cmd2不执行。2.cmd1执行完毕且为错误($?!=0)，则开始执行cmd2。|

```
测试/tmp/abc是否存在，若不存在则予以建立，若存在就不作任何事情

ls /tmp/abc || mkdir /tmp/abc
```

```
我不清楚/tmp/abc是否存在，但就是要建立 /tmp/abc/hehe档案
ls /tmp/abc || mkdir /tmp/abc && touch /tmp/abc/hehe
```

例题：

以ls测试/tmp/vbirding是否存在，若存在则显示“exist”，若不存在，则显示“not exist”！

```
ls /tmp/vbirding && echo "exist" || echo "not exist"
```

向下面这种情况会出问题：

```
ls /tmp/vbirding || echo “not exist” && echo “exist”
```

分析：

如果第一条语句返回的值为0,那么不会执行第二条语句，但是会执行最后一条语句也就是exist。

如果第一条语句返回的值为非0,那么会执行第二条语句，也就是“not exist” ，但也会执行最后一条语句“exist”

所以，一般的假设判断是这样的格式：

```
command1 && command2 || command3
```

### 管线命令（pipe）

每个管线后面接的第一个数据必定是「指令」，而且这个指令必须要能够接受standard input的数据才行，这样的指令才可以是为「管线命令」。例如，less，more，head，tai等都是可以接受standard input的管线命令。

注意：

管线命令仅会处理standard output，对于standard error output会予以忽略

管线命令必须要能够接受来自前一个指令的数据成为standard input 继续处理才行

### 截取指令 cut grep

```
cut -d'分隔字符' -f fields # 以分隔字符的方式来分隔字符
cut -C 字符区间 # 用于排列整齐的讯息

选项与参数：

-d: 后面接分隔字符。与-f一起使用
-f：依据-d的分隔字符将一段信息分隔为数段，用-f取出第几段的意思
-c：以字符的单位取出固定字符区间，数字符是从0开始
```

```
范例一：将PATH变量取出，我要找出第5个路径

echo $PATH | cut -d`:` -f 5

范例二：截取第12个字符后面的字符

export | cut -c 12-

范例三：截取last输出信息的第一列

last | cut -d ' ' -f 1
```

cut 是处理多行数据，grep则是处理单行数据。

```
grep [-acinv] [--color=auto] `搜寻字符串` filename

选项参数：

-a：将binary档案以text档案的方式搜寻数据
-c：计算找到‘搜寻字符串’的次数
-i：忽略大小写的不同，所以大小写视为相同
-n：顺便输出行号
-v：反响选择
--color=auto：可以将找到的关键词部分加上颜色的显示！

==================== 示例 =========================

范例一：将last当中，有出现root的那一行就取出来

last | grep ‘root’

范例二：与范例一相反，只要没有root的就取出来

last | grep -v 'root'

范例三：在last的输出信息中，只要有root就取出，并且只取第一栏

last | grep 'root' | cut -d ' ' -f 1

范例四：取出/etc/man.config内含MANPATH的那几行

grep --color=auto 'MANPATH' /etc/man.config

```

### 排序命令：sort，wc，uniq

```
sort [-fbMnrtuk] [file or stdin]

选项与参数：

-f : 忽略大小写的差异，例如A与a视为编码相同;
-b: 忽略最前面的空格符部分
-M：以月份的名字来排序，例如JAN，DEC等等的排序方法
-n：使用「纯数字」进行排序（默认是以文字型态来排序的）
-r：反向排序
-U：就是uniq，相同的数据中，仅出现一行代表
-t：分隔符，预设是用[tab]键来分隔
-k：以那个区间来进行排序的意思

================ 例子 =========================

范例一：个人帐号都记录在/etc/passwd下，请将帐号进行排序

cat /etc/passwd | sort 

范例二：/etc/passwd内容是以冒号:来分隔的，我想以第三栏来排序，该如何？

cat /etc/passwd | sort -t ':' -k 3

默认是以文字方式来排序的，所以看不到想象中的数字排序效果，达到预期效果需要使用：

cat /etc/passwd | sort -t ':' -k 3 -n

```

如果我排序完成了，想要将重复的资料仅列出一个显示，可以怎么做呢？

```
uniq [-ic]

选项参数：
-i ：忽略大小写字符的不同;
-c ：进行计数

范例一：使用last将帐号列出，仅取出帐号栏，进行排序后仅取出一位;

last | cut -d ' ' -f1 | sort | uniq

范例二：承上题，如果我还想要知道每个人的登入总次数呢？

last | cut -d ' ' -f1 | sort | uniq -c
```

如果我想要知道/etc/man.config这个档案里面有多少字？多少行？多少字符的话，可以怎么做呢？

```
wc [-lwm]

选项参数：

-l：仅列出行
-w：仅列出多少字
-m：多少字符

============ 例子 ==================

范例一：统计文件的字符数
cat /etc/man.config | wc
141 722 4617
|字 |行 |字符数|

范例二：我知道使用last可以输出登入者，但是last最后两行并非账号内容，该如何取得这个月份登入系统的总人数？
last | grep [a-zA-Z] | grep -v 'wtmp' | wc -l
```

### 双向重导向：tee

|Standard input| --> |tee| --> |Screen|
                       |
                       |
                       V
                     |file|

tee会同时将数据流分送到档案与屏幕（screen），而输出到屏幕的，其实就是stdout，可以让下个指令继续处理。

```
tee [-a] file

选项参数：

-a：以累加方式，将数据加入file当中！

last | tee last.list | cut -d " " -f1 # 这个范例可以让我们将last的输出存一份到last.list当中

ls -l /home | tee ~/homefile | more # 这个范例将ls的数据存一份到 ~/homefile，同时屏幕也有输出信息

如果再次执行上面那条命令，则`~/homefile`将会被覆盖。加上 `-a` 选项则累加。
```

### 字符转换命令：tr, col, join, paste, expand

`tr`:

tr用来删除一段信息当中的文字，或是替换。

```
tr [-ds] SET1...

选项与参数：
-d：删除讯息当中的SET1这个字符串;
-s：取代重复的字符！

范例一：将last输出的信息中，所有的小写变成大写字符：
last | tr '[a-z]''[A-Z]' # 也可以不用加单引号

范例二：将/etc/passwd输出的信息中，将冒号(:)删除
cat /etc/passwd | tr -d ':'

范例三：将/etc/passwd转存成dos断行到/root/passwd中，再将^M符号删除
cp /etc/passwd /root/passwd && unix2dos /root/passwd
```

col:

```
col [-xb]

选项与参数：

-x：将tab键转换成对等的空格键
-b：在文字内有反斜杠（/）时，仅保留反斜杠最后接的那个字符

范例一：利用cat -A 显示出所有特殊按键，最后以col将[tab]转成空白。
cat -A /etc/man.config | col -x | cat -A | more

范例二：将col的man page转存为 /root/col.man的纯文本档
man col > /root/col.man
vi /root/col.man
```

join:

主要是在处理两个档案中，有“相同数据”的那一行，才将他们加在一起的意思

```
join [-ti12] file1 file2

选项与参数：

-t：join默认以空格分隔数据，并且比对「第一个字段」的数据，如果两个档案相同，则将两笔数据联成一行，且第一个字段放在第一个！
-i：忽略大小写的差异
-1：数字1,代表「第一个档案要用那个字段来分析」的意思
-2：代表「第二个档案要用那个字段来分析」的意思

范例一：用root的身份，将/etc/passwd与/etc/shadow相关数据整合成一栏
head -n 3 /etc/passwd /etc/shadow
```

需要特别注意的是，在使用join之前，你所需要处理的档案应该要事先经过排序（sort）处理，否则有些比对的项目会被略过呢。

past：

将两行贴在一起，中间以tab键隔开。

```
paste [-d] file1 file2

选项与参数：
-d：后面可以接分隔字符。预设是以tab来分隔的。
-：如果file部分写成 -，表示来自standard input的资料的意思。

范例一：将/etc/passwd 与 /etc/shadow同一行贴在一起
paste /etc/passwd /etc/shadow

范例二：先将/etc/group读出，然后与范例一贴上一起，且仅取出前三行：
cat /etc/group | paste /etc/passwd /etc/shadow - | head -n 3
```

expand:

这玩意儿就是在将[tab]按键转成空格键：

```
expand [-t] file

-t: 后面可以接数字。一般来说，一个tab按键可以用8个空格键取代。我们也可以自定义一个[tab]按键代表多少个字符。

范例一：将/etc/man.config内行首为MANPATH的字样就取出;仅取前三行;
grep '^MANPATH' /etc/man.config | head -n 3

范例二：承上，如果我想要将所有的符号都列出来？
grep '^MANPATH' /etc/man.config | head -n 3 | cat -A

范例三：承上，我将[tab]按键设定为6个字符的话？
grep '^MANPATH' /etc/man.config | head -n 3 | expand -t 6 -| cat -A
```

expand会自动将[tab]转成空格键，所以，上面的例子来说，使用`cat -A`就会查不到 ^I的字符了。

unexpand将空白转成[tab]的指令功能。

### 分割命令：split

```
split [-bl] file PREFIX

选项与参数：
-b: 后面可接欲分割成的档案大小，可加单位，例如b，k，m等
-l：以行数来进行分割
PREFIX：代表前导符的意思，可作为分割档案的前导文字。

范例一：我的/etc/termcap有七百多K，若想要分成300K一个档案时？
cd /tmp; split -b 300k /etc/termcap termcap

范例二：如何将上面的三个小档案合成一个档案，档案名为termcapback
cat termcap* >> termcapback

范例三：使用ls -al / 输出的信息中，每十行记录成一个档案
ls -al / |split -l 10 - lsroot
```



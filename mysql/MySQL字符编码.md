### 基本概念：

字符是指人类语言中最小的表义符号。例如：A,B,C,等。

编码是指，当给定一系列字符，对每个字符赋予一个数值，用数值来代表对应的字符，这一数值就是字符的编码(Encoding)。

给定一系列字符并赋予对应的编码后，所有这些字符和编码对组成的集合就是字符集(Character Set)。

字符序(Collation)是指在同一字符集内字符之间的比较规则。确定了字符序之后，才能在一个字符集上定义什么是等价的字符，以及字符之间的大小关系。

每个字符序唯一对应一种字符集，但一个字符集可以对应多种字符序，其中有一个是默认字符序(Default Collation);

MySQL中的字符序名称遵从命名惯例：以字符序对应的字符集名称开头;以_ci(表示大小写不敏感)、_cs(表示大小写敏感)或 _bin(表示按编码值比较)结尾。

例如：在字符序“utf8_general_ci”下，字符“a”和“A”是等价的。

### MySQL的字符集支持

1. 字符集(Character set)
2. 排序比较方式(Collation)

查看方式：
```
show character set;
show collation;
```

MySQL对字符集的支持细化到4个层次：

1. 服务器(server)
2. 数据库(database)
3. 数据表(table)(字段column)
4. 连接(connection)

MySQL字符集变量：

- character_set_server: 默认的内部操作字符集
- character_set_client: 客户端来源数据使用的字符集
- character_set_connection: 连接层字符集
- character_set_results: 查询结果字符集
- character_set_database: 当前选中数据库的默认字符集
- character_set_system: 系统元数据（字段名等）字符集
- 还有以collation_开头的同上面对应的变量，用来描述字符。

### 用introducer指定文本字符串的字符集：

格式为：[_charset] 'string' [COLLATE collation] 

例如：

- SELECT _latin1 'string';
- SELECT _utf8 '你好' COLLATE utf8_general_ci;

经过哦introducer修饰的文本字符串在请求过程中不经过多余的转码，直接转换为内部字符集处理。

查看默认字符集：

默认情况下，MySQL的字符集是latin1(ISO_8859_1)

查看字符集合和字符序的命令是：
```
show variables like 'character%'
show variables like 'collation_%'
```

在my.cnf中修改默认字符集：
```
default-character-set=utf8
character-set-server=utf8
collation-server=utf8-general_ci
init_connect='SET collation_connection=utf8_general_ci'
init_connect='SET NAMES utf8'
```

检测字符集问题的手段：
```
show character set;
show collation;
show variables like 'character%'
show variables like 'collation%'
SQL函数HEX, LENGTH, CHAR_LENGTH
SQL函数CHARSET，COLLATION
```


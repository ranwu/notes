创建数据库和表：
```
CREATE DATABASE databasename

CREATE TABLE tablename (
column1name description,
column1name description
)
```

创建user表：

```
CREATE TABLE users (
user_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(40) NOT NULL,
email VARCHAR(60) NOT NULL,
pass CHAR(40) NOT NULL,
registration_date DATETIME NOT NULL,
PRIMARY KEY (user_id)
);
```

确认表是否存在：

```
SHOW TABLES;
SHOW COLUMNS FROM users; // 查看user表的结构
```
### 插入记录

用insert命令来插入记录：
```
INSERT INTO tablename (column1, column2...)
VALUES (value1, value2...)
INSERT INTO tablename (column4, column8)
VALUES (valueX, valueY)
```
注意，任何未赋值的列都将被视为NULL(如果定义了默认值，就设置为默认值)

第二种方式：
```
INSERT INTO tablename VALUES (value1, NULL, value2, value3, ...)
```

MySQL还允许同时插入多行，并用逗号隔开每条记录。
```
INSERT INTO tablename (column1, column4) VALUES (valueA, valueB),
(valueC, valueD),
(valueE, valueF)
```

在每个SQL命令中：

- 数值不应该用引号括住;
- 字符串值(对于CHAR、VARCHAR和TEXT列类型)必须总是用引号括住;
- 日期和时间值必须总是用引号括住;
- 函数不能用引号括住;
- 单词NULL一定不能用引号括住;

如果在值中使用引号，必须转义：
```
INSERT INTO tablename (last_name) VALUES ('O\'Toole')
```

向users表中插入一条记录(指定列的方式)：
```
INSERT INTO users 
(first_name, last_name, email, pass, registration_data)
VALUES('Larry', 'Ullman', 'email@example.com',
SHA1('mypass'), NOW());
```

SHA1()是MySQL函数，用来加密密码，NOW()函数用来插入当前系统日期和时间。

SHA1()加密后的字符串长度为40个字符。这也是为什么把pass列设为CHAR(40)的原因。

SHA1()是单向加密技术，对于那些无需以未加密的形式再次查看的敏感数据

如果使用MD5()函数，可以把pass列定义为CHAR(32)。

不指定列向表中插入数据：
```
INSERT INTO users VALUES
(NULL, 'Zoe', 'Isabella', 'email2@example.com',
SHA1('mojito'), NOW());
```
这种方法必须为每个字段提供一个值，将user_id设置为NULL值，依据其AUTO_INCREMENT
描述，它将导致MySQL使用下一个逻辑编号。

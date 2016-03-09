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

### QPS计算（每秒查询数）

针对MyISAM引擎为主的DB
```
SHOW GLOBAL STATUS LIKE 'questions';
SHOW GLOBAL STATUS LIKE 'uptime';
```

MySQL自启动以来的平均QPS
```
QPS=question/uptime=5172
```

如果要计算某一时间段内的QPS，可在高峰期间获取间隔时间`t2-t1`，然后分别计算出t2和t1时刻的q值，QPS=(q2-q1)/(t2-t1)

### 针对InnnoDB引擎为主的DB

```
SHOW GLOBAL STATUS LIKE 'com_update';
SHOW GLOBAL STATUS LIKE 'com_select';
SHOW GLOBAL STATUS LIKE 'com_delete';
SHOW GLOBAL STATUS LIKE 'uptime';
```

QPS为：
```
QPS=(com_update+com_insert+com_delete+com_select)/uptime=3076
```

### TPS计算（每秒事务数）

```
SHOW GLOBAL STATUS LIKE 'com_commit';
SHOW GLOBAL STATUS LIKE 'com_rollback';
SHOW GLOBAL STATUS LIKE 'uptime';
```

公式：

```
TPS=(com_commit+com_rollback)/uptime=22
```


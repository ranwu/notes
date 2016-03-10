这次的压力测试用到了mysqlslap。

mysqlslap运行的三个步骤：

1. 创建schema、table、test data等，使用单个连接(在MySQL中，schema就是database);
2. 运行负载测试，可以使用多个并发客户端连接;
3. 测试环境清理(删除创建的数据、表等)，使用单个连接

### 测试实例

单线程测试：

```
mysqlslap -a -uroot -p123456
```

多线程测试,这里的c表示：concurrency

```
mysqlslap -a -c 100 -uroot -p123456
```

迭代测试：
```
mysqlslap -a -i 10 -uroot -p123456
```

测试同时不同的存储引擎的性能进行对比：
```
mysqlslap -a --concurrency=50,100 --number-of-queries=1000 \
--iterations=5 --engine=myisam,innodb --debug-info -uroot -p123456
```

执行一次测试，分别50和100个并发，执行1000次总查询：
```
mysqlslap -a --concurrency=50,100 --number-of-queries=1000 \
--debug-info -uroot -p123456
```

50和100个并发分别得到一次测试结果(Benckmark)，并发数越多，执行完所有查询的所需时间越长。为了准确起见，可以多迭代测试几次：
```
mysqlslap -a --concurrency=50,100 --number-of-queries=1000 \
--iterations=5  --debug-info -uroot -p123456
```

### 测试用例1
本次测试以50,100,200个并发线程、运行200个查询、迭代10次，自动生成SQL测试脚本、读、写、更新混合测试、自增长字段、测试引擎为innodb，输出cpu资源信息
```
mysqlslap -a --concurrency=50,100,200 \
--number-of-queries=200 \
--iterations=10 \
--auto-generate-sql-load-type=mixed \
--auto-generate-sql-add-autoincrement \
--engine=innodb --debug-info \
-uroot -p 
```

### 测试用例2
增加int型4列，char型35列，测试innodb读的性能，分别用50，100, 200个客户端对服务器进行测试，总共200个查询语句执行20次查询。

```
mysqlslap -a --concurrency=50,100,200 \
--iterations=20 \
--number-int-cols=4 \
--number-char-cols=35 \
--auto-generate-sql-add-autoincrement \
--auto-generate-sql-load-type=read \
--engine=innodb \
--number-of-queries=200 \
--verbose \
-uroot -p 
```

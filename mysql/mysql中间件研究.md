### 什么是中间件？

我的理解是，中间件就是一个代理服务。对于客户端来说，中间件就是mysql服务器，对于本身的mysql服务器来说，中间件就是客户端。

我们这次使用的是奇虎360的Atlas。Atlas提供的功能：

1. 读写分离
2. 从库负载均衡
3. IP过滤
4. 自动分表
5. DBA可平滑上下线DB
6. 摘除自动宕机的DB

### 应用场景：

针对读大于写的应用场景。通过读写分离来实现业务请求的负载均衡。这样做能有效提高数据库的QPS（每秒查询率）


### 怎样来设计这种架构？

假设有4台CentOS6服务器，分别为master，slave_01，slave_02，slave_03。

*IP分别为：*

1. master： 192.168.0.254
2. slave_01: 192.168.0.10
3. slave_02: 192.168.0.20
4. slave_03: 192.168.0.30

master主要做写的请求。其余三台服务器做读的请求。

slave_01上安装Atlas。

*前提条件：*

1. 保证每台服务器的MySQL环境一样
2. 保证每台服务器处于同一个局域网


### 部署过程

*1. 安装*

下载最新版Atlas：https://github.com/Qihoo360/Atlas/releases，并安装：

```
sudo rpm –i Atlas-XX.el6.x86_64.rpm
```

我们用的是：Atlas-2.2.1.el6.x86_64.rpm 这个版本。

*2. 编辑配置文件*

```
# vi /usr/local/mysql-proxy/conf/test.cnf

[mysql-proxy]

#带#号的为非必需的配置项目

#管理接口的用户名
admin-username = user # 这里不用改

#管理接口的密码
admin-password = pwd # 这里不用改

#Atlas后端连接的MySQL主库的IP和端口，可设置多项，用逗号分隔
proxy-backend-addresses = 192.168.0.254:3306 # 这里填写主库IP

#Atlas后端连接的MySQL从库的IP和端口，@后面的数字代表权重，用来作负载均衡，若省略则默认为1，可设置多项，用逗号
分隔
proxy-read-only-backend-addresses = 192.168.0.10:3306, 192.168.0.20:3306, 192.168.0.30:3306 # 填写三台备库的IP

#用户名与其对应的加密过的MySQL密码，密码使用PREFIX/bin目录下的加密程序encrypt加密，下行的user1和user2为示例，
将其替换为你的MySQL的用户名和加密密码！
pwds = mysql:GS+tr4TPgqc= #我给所有的服务器都配了mysql超级用户，并且密码都一样。那个encrypt程序在/usr/local/mysql-proxy/bin/目录下，如果要生成密码的密文的话：./encrypt [密码]，就这样做。

#设置Atlas的运行方式，设为true时为守护进程方式，设为false时为前台方式，一般开发调试时设为false，线上运行时设>为true,true后面不能有空格。
daemon = true # 这里不用改

#设置Atlas的运行方式，设为true时Atlas会启动两个进程，一个为monitor，一个为worker，monitor在worker意外退出后会
自动将其重启，设为false时只有worker，没有monitor，一般开发调试时设为false，线上运行时设为true,true后面不能有>空格。
keepalive = true # 这里不用改

#工作线程数，对Atlas的性能有很大影响，可根据情况适当设置
event-threads = 2 # 由于服务器为1个CPU，就设为它的2倍（github上面有关于此的详细说明）

#日志级别，分为message、warning、critical、error、debug五个级别
log-level = message # 不用改

#日志存放的路径
log-path = /usr/local/mysql-proxy/log # 不用改

#SQL日志的开关，可设置为OFF、ON、REALTIME，OFF代表不记录SQL日志，ON代表记录SQL日志，REALTIME代表记录SQL日志且
实时写入磁盘，默认为OFF
#sql-log = ON # 不用改

#慢日志输出设置。当设置了该参数时，则日志只输出执行时间超过sql-log-slow（单位：ms)的日志记录。不设置该参数则>输出全部日志。
#sql-log-slow = 10 # 不用改

#实例名称，用于同一台机器上多个Atlas实例间的区分
#instance = test # 不用改

#Atlas监听的工作接口IP和端口
proxy-address = 0.0.0.0:1234 # 不用改

#Atlas监听的管理接口IP和端口
admin-address = 0.0.0.0:2345 # 不用改

#分表设置，此例中person为库名，mt为表名，id为分表字段，3为子表数量，可设置多项，以逗号分隔，若不分表则不需要>设置该项
#tables = person.mt.id.3 # 不用改

#默认字符集，设置该项后客户端不再需要执行SET NAMES语句
charset = gbk # 特殊需求，我设为gbk，你也可以设为utf-8

#允许连接Atlas的客户端的IP，可以是精确IP，也可以是IP段，以逗号分隔，若不设置该项则允许所有IP连接，否则只允许>列表中的IP连接
#client-ips = 127.0.0.1, 192.168.1 # 不用改

#Atlas前面挂接的LVS的物理网卡的IP(注意不是虚IP)，若有LVS且设置了client-ips则此项必须设置，否则可以不设置
#lvs-ips = 192.168.1.1 # 不用改
```

*3. 启动Atlas*

```
 sudo ./mysql-proxyd test start，启动Atlas。

 sudo ./mysql-proxyd test restart，重启Atlas。

 sudo ./mysql-proxyd test stop，停止Atlas
```

查看服务器是否运行：

```
netstat -tlnp | grep 0.0.0.0

=============== 结果 ====================================

tcp        0      0 0.0.0.0:1234                0.0.0.0:*                   LISTEN      7071/mysql-proxy    
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      900/sshd            
tcp        0      0 0.0.0.0:2345                0.0.0.0:*                   LISTEN      7071/mysql-proxy    
tcp        0      0 0.0.0.0:3306                0.0.0.0:*                   LISTEN      3057/mysqld
```

看到`1234` 和 `2345` 端口，说明Atlas成功启动。

用配置的用户登录Atlas：

```
mysql -h127.0.0.1 -P1234 -umysql -p123456 # 注意1234前面的P为大写
```

用管理账号登录：

```
mysql -h127.0.0.1 -P2345 -uuser -ppwd
```

进入后查看帮助信息：

```
select * from help
```

查看backends状态：

```
mysql> select * from backends;
+-------------+--------------------+-------+------+
| backend_ndx | address            | state | type |
+-------------+--------------------+-------+------+
|           1 | 192.168.0.254:3306 | up    | rw   |
|           2 | 192.168.0. 10:3306 | up    | ro   |
|           3 | 192.168.0. 20:3306 | up    | ro   |
|           4 | 192.168.0. 30:3306 | up    | ro   |
+-------------+--------------------+-------+------+
4 rows in set (0.00 sec)

```

如果提示：

```
ERROR 1045 (28000): Access denied for user 'buck'@'127.0.0.1:44369' (using password: YES)
```

说明是`test.cnf`中的pwds参数项没有配置好(前提是所有的服务器都有mysql用户和它对应的密码)。


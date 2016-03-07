作为一个大型企业的数据库管理员，你可能需要做以下的事情：

- 提供灾难发生时核心业务数据的恢复计划。理论上说这个过程至少需要执行一次。
- 通过采集大量用户数据并监控网站各个节点的负载，提供优化计划。
- 当用户量急剧增长时的快速横向扩展计划。

为了保证站点可响应和可用，你需要做两件事：系统的数据备份和冗余。

备份可以将节点恢复到它崩溃之前的状态，而冗余则保证即使在一个或更多的节点停止提供服务的情况下，站点仍然继续运行。

复制就是复制一个服务器上的所有改变到另一个服务器。

在横向扩展的场景下使用复制时，理解MySQL复制的异步性很重要。即事务首先在主节点提交，然后复制给从节点并在从节点上应用。这意味着主节点和从节点可能并不一致

使用异步复制的好处是它比同步复制更快，更具有可扩展性。对于实时性要求比较高的场景，必须采用同步的方式。

复制的另一个重要应用是通过添加冗余来保证高可用性。最常见的技术是使用双主配置(dual-master setup)，即通过复制使得一对主节点总是可用，每个主节点都是对方的镜像。如果其中一个主节点失效，另一个会立即接手。

将服务器配置为Master，要确保该服务有一个活动的二进制日志(binary log)和唯一的服务器ID

Master的配置
```
[mysqld]
log-bin			= master-bin
log-bin-index	= master-bin.index
server-id		= 1
```

在Master上创建一个复制账户：
```
CREATE USER repl_user;
GRANT REPLICATION SLAVE ON *.* TO repl_user IDENTIFIED BY 'p4ssword'
```

Slave的配置
```
server-id		= 2
relay-log-index	= slave-relay-bin.index
relay-log		= slave-relay-bin
```

### 连接Master和Slave

需要知道Master的4部分信息：

- 主机名
- 端口号
- Master上拥有REPLICATION SLAVE权限的用户账号
- 该用户的密码

主机名不能通过my.cnf指定，端口号可以。主机名通过系统来指定。

用CHANGE MASTER TO 命令指向Master：
```
CHANGE MASTER TO
> MASTER_HOST = 'master-1',
> MASTER_PORT = 3306,
> MASTER_USER = 'repl_user',
> MASTER_PASSWORD = 'XYZZY';

START SLAVE;
```

master_host的参数如果是主机名，那么通过调用`gethostname(3)`得到对应的IP地址，即通过域名查找来解析主机名，其结果与配置有关。相关内容：域名解析配置。

|权限|用途|
|---|---|
|CREATE USER|用于创建和删除用户|
|REPLICATION SLAVE|用于复制账户|
|RELOAD|执行FLUSH LOGS命令，或任何FLSH命令|
|SUPER或REPLICATION CLIENT|用于执行SHOW MASTER STATUS和SHOW SLAVE STATUS|
|SUPER|执行CHANGE MASTER TO|

### 二进制日志记录了什么

二进制日志的目的是记录数据库中表的更改，然后用于复制和PITR，另外少数审计情况下也会用到。

注意，二进制日志只包括数据库的改动，所以对那些不改变数据的语句则不会写入二进制日志。

查看二进制日志：
```
SHOW BINLOG EVENTS IN 'mysql-bin.000017'\G
```

事件：

*格式描述事件*

用于服务器内部管理二进制日志

*查询事件*

查询事件是如何将数据库上执行的语句写入二进制语句

*日志轮换事件*

用于服务器内部管理二进制日志

目前的mysql大约有27中事件类型。

一个事件只能存储在一个文件中，永远不能跨两个文件。

Pos是事件在文件中的开始位置，即事件的第一个字节。

End_log_pos是事件在文件中的结束位置，也是下一个事件的开始位置，这个位置比事件的最后一个字节高一位。因此事件的字节范围为Pos到End_log_pos - 1,然后通过End_log_pos来减去Pos，即得到这个事件的长度。

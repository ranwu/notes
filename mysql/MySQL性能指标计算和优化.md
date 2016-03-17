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

### 线程连接数和命中率
```mysql
SHOW GLOBAL STATUS LIKE 'threads_%';
Threads_cached | 480 | // 代表当前线程缓存中有多少空线程
Threads_running | 2| // 代表当前激活的（非睡眠状态）线程数

SHOW GLOBAL STATUS LIKE 'Connections';

线程缓存命中率=1-Threads_created/Connections=99.994%
```

我们设置的线程缓存个数：
```mysql
SHOW VARIABLES LIKE '%thread_cache_size%';
```

根据Threads_connected可预估thread_cache_size值应该设置多大，一般来说250是一个
不错的上限值，如果内存足够大，也可以设置为thread_cache_size值和threads_connec-
ted值相同。

通过观察threads_created值，如果该值很大或一直在增长，可以适当增加thread_cache_size的值; 在休眠状态下每个线程大概占用256KB的内存，所以当内存足够时，设置太小也
不会节约太多内存，除非该值已经超过几千。

### 表缓存
```mysql
# 现实mysql的表缓存
SHOW GLOBAL STATUS LIKE 'open_tables%';

# 表的缓存和表定义缓存
SHOW VARIABLES LIKE 'table_open_cache';
SHOW VARIABLES LIKE 'table_defi%';
```

**针对MyISAM**

mysql每打开一个表，都会读入一些数据到table_open_cache中。当mysql在这个缓存中找不到
相应的信息时，才会去磁盘上直接读取。所以该值要足够大，以避免需要重新打开和重新解析
表的定义，一般设置为max_connections的10倍。最好保持在10000以内。

还有一种是根据open_tables的值进行设置，如果发现open_tables的值每秒变化很大，那就增加
tables_open_cache的值。

table_definition_cache 通常简单设置为服务器中存在的表的数量。

**针对InnoDB**

InnoDB的open table和open file并无直接联系，即打开frm表时相应的ibd文件可能处于关闭状态;

故InnoDB只会用到table_definition_cache，不会用到table_open_cache;

其frm文件保存于table_definition_cache中，而idb则由innodb_open_files决定（前提是开启
了innodb_file_per_table)，最好将innodb_open_files设置得足够大，使得服务器可以保持
所有的.ibd文件同时打开。

### 最大连接数

```
SHOW GLOBAL STATUS LIKE 'Max_used_connections';

# 设置的max_connections大小:
SHOW VARIABLES LIKE 'max_connections%';
```

通常max_connections的大小应该比Max_used_connections的状态值大。

Max_used_connections状态值反映服务器连接在某个时间段内是否有尖峰，如果该值大于
max_connections的值，代表客户端至少被拒绝了一次。

可以简单地设置为符合以下条件：
```
Max_used_connections/max_connections=0.8
```

### InnoDB缓存命中率

```
SHOW GLABAL STATUS LIKE 'innodb_buffer_pool_read%';

Innodb_buffer_pool_read_ahead | 2678720 | # 预读的页数
Innodb_buffer_pool_read_requests | 33223 | # 从缓冲池中读取的次数
Innodb_buffer_pool_reads | 29923 | # 表示从物理磁盘读取的页数 
```

缓冲池命中率=(Innodb_buffer_pool_read_requests)/(Innodb_buffer_pool_read_requests + Innodb_buffer_pool_read_ahead + Innodb_buffer_pool_reads)=99.994%

如果该值小于99.9%，建议就应该增大innodb_buffer_pool_size的值了，该值一般设置为内存
总大小的75%-85%或者计算出操作系统所需缓存+mysql每个连接所需要的内存（例如排序缓冲
和临时表）+ MyISAM键缓存，剩下的内存都给innodb_buffer_pool_size，不过也不宜设置过大。

### MyISAM Key Buffer 命中率和缓冲区使用率

```
SHOW GLOBAL STATUS LIKE 'key_%';

# 查看缓冲区单个区块容量
SHOW VARIABLES LIKE '%key_cache_block_size%';

# 查看buffer大小
SHOW VARIABLES LIKE '%key_buffer_size%';
```

缓冲区的使用=1-(Key_blocks_unused\*key_cache_block_size/key_buffer_size)=18.6%

读取命中率=1-Key_reads/Key_read_requests=99.98%

写命中率=1-Key_writes/Key_write_requests=99.05%

如果很长一段时间内还没有使用完缓存，可以把缓存区调小点。

### 临时表使用情况

```
SHOW GLOBAL STATUS LIKE 'Created_tmp%';

|Created_tmp_disk_tables|19226325|
|Created_tmp_tables|56265821|

show variables lik '%tmp_table_size%';

|tmp_table_size|67108864|
```

可以看到总共创建了56265821张表，其中有19226325张涉及到了磁盘IO，大概比例占到了0.34，证明
数据库中排序，join语句涉及的数据量太大，需要优化SQL或增大tmp_table_size的值，
比如64M。该比值应该控制在0.2以内。

### binlog cache 使用情况

```
SHOW STATUS LIKE 'Binlog_cache%';

    |Binlog_cache_disk_use|15|
    |Binlog_cache_use|95978256|

SHOW VARIABLES LIKE 'Binlog_cache_size';

|binlog_cache_size|1048576|
```
Binlog_cache_disk_use表示因为我们binlog_cache_size设计的内存不足导致缓存二进制日志
用到了临时文件的次数。

Binlog_cache_use表示用binlog_cache_size缓存的次数。

当对应的Binlog_cache_disk_use值比较大的时候，我们可以考虑适当调高binlog_cache_size对应的值。

### Innodb log buffer size的大小设置

```
SHOW VARIABLES LIKE '%innodb_log_buffer_size%';

    innodb_log_buffer_size | 8388608 |

SHOW STATUS LIKE 'innodb_log_waits';

    Innodb_log_waits | 0 |
```

如果Innodb_log_waits的值不为0,可以适当增大innodb_log_buffer_size的值。Innodb_log_waits
表示因log buffer不足导致等待的次数。

### 表扫描情况判断

```
SHOW GLOBAL STATUS LIKE 'Handler_read%';

Handler_read_first: 使用索引扫描次数，该值大小说不清系统性能是好是坏
Handler_read_key: 通过key进行查询的次数，该值大证明系统性能越好
Handler_read_next: 使用索引进行排序的次数
Handler_read_prev: 此选项表明在进行索引扫描时，按照索引倒叙从数据文件里取数据的次数，
一般是ORDER BY ... DESC 
Handler_read_rand: 该值越大证明系统中有大量的没有使用索引进行排序的操作，或者join
时没有使用到index
Handler_read_rnd_next: 使用数据文件进行扫描的次数。该值越大证明有大量的全表扫描，
或者合理地创建索引，没有很好地利用已经建立好的索引。
```

### Innodb_buffer_pool_wait_free
```
SHOW GLOBAL STATUS LIKE 'Innod_buffer_pool_wait_free';
```
如果该值不为0,表示buffer pool没有空闲的空间了。可能原因是innodb_buffer_pool_size
设置太大，可以适当减少该值。

### join操作信息
```
SHOW GLOBAL STATUS LIKE 'select_full_join';

|Select_full_join|10403| # 该值表示在join操作中没有使用到的索引的次数，值很大说明
join语句写得有问题。

SHOW GLOBAL STATUS LIKE 'Select_range_check';

|Select_range_check|0|
如果该值不为0，需要检查表的索引是否合理。
```

### 慢查询
```
SHOW GLOBAL STATUS LIKE 'Slow_queries';

|Slow_queries|114111|
该值表示mysql启动以来的慢查询个数，即执行时间超过long_query_time的次数，可根据
Slow_queries/uptime的比值来判断单位时间内的慢查询个数，进而判断系统的性能。
```

### 表锁信息
```
SHOW GLOBAL STATUS LIKE 'table_lock%';

|Table_licks_immediate|1644917567|
|Table_locks_waited|53|
```

这两个值的比值：Table_locks_waited/Table_locks_immediate 趋向于0,如果值比较大则表示
系统的锁阻塞比较严重。

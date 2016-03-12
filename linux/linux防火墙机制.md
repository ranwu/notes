检查iptables是否安装：
```
# rpm -qa | grep iptables
```

iptables相关文件：
```
/etc/init.d/iptables # 用来开始、停止iptables或是保存规则的初始化脚本
/etc/sysconfig/iptables # 所有的规则都保存在这个文件。
/sbin/iptables # 是iptables的二进制文件。
```

查看iptables当前的配置：
```
# iptables -L
```

默认只有三条规则链：
```
INPUT # 包含进站数据包的规则
OUTPUT # 包含出站数据包的规则
FORWARD # 包含转发数据包到其他主机的规则
```

当有数据包通过Linux核心，下面几个指令将会决定数据包被匹配之后如何处理：
```
ACCEPT # 数据包允许通过
REJECT # 数据包被拒绝并返回给发数据包的主机一个简单的解释
DROP # 数据包被拒绝不返回任何信息
```

开始配置规则之前的建议：
1. 规则的顺序很重要。比如一开始你就开始添加了一个阻止任何的规则，那么你下面的允许规则都不会起作用。
2. 编写规则是存储在内存中，所以要手动执行初始化脚本来保存规则。
3. 如果你是在远程管理服务器，比如SSH，那么配置规则之前首先添加允许SSH的规则。
允许SSH连接：
```
# iptables -A INPUT -s 213.10.10.13 -d 192.168.1.1 -p TCP \
-dport 22 -j ACCEPT

说明：
-A # 附加INPUT规则链
-s # 来源IP，即客户端IP
-d # 目的地址，即服务端IP
-p # 通信协议
-dport # 目的端口
-j # jump，如果之前的规则都匹配，则接受数据包
```
下面是一个新的连接的数据包的状态：
```
NEW #第一服务器发送给第二服务器一个SYN数据包来建立一个连接
RELATED #第二服务器接收SYN数据包并发送给第一服务器一个SYN-ACK数据包来确定连接正常
ESTABLISHED #第一服务器接收到SYN-ACK数据包并发送给第二服务器ACK来做最后的确认，至此连接建立完成，两台服务器开始传输数据。
```

为了能让服务器与其他服务器建立TCP连接，iptables必须配置如下：
```
# iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A OUTPUT -m state --state RELATED,ESTABLISHED
```

### 自定义规则

*阻止IP：*
```
// 这条规则表示阻止从213.10.10.13传进来的数据包
# iptables -A INPUT -s 213.10.10.13 -j DROP

// 这条规则表示阻止从局域网192.168.1.15传来的数据包
# iptables -A INPUT -d 192.168.1.15 -j REJECT
```

*允许IP：*
```
// 这条规则表示接受来自213.10.10.13到目标地址FTP服务器192.168.1.4的数据包
# iptables -A INPUT -s 213.10.10.13 -d 192.168.1.4 -p tcp --dport 21
```

*允许规则配完，配拒绝规则：*
```
# iptables -A INPUT -j REJECT
# iptables -A FORWARD -j REJECT
// 这些规则在必须在最后添加
```

删除规则：只需要把 `-A` 替换成 `-D`即可删除

### 保存规则
```
//保存
# /etc/init.d/iptables save

//停止iptables来刷新所有规则
# /etc/init.d/iptables stop

//重新启动iptables
# /etc/init.d/iptables start
```


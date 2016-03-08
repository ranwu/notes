keepalived 主要有三个模块，分别是core，check和vrrp。core模块被认为是keepalived的核心，负责主进程的启动，维护以及全局配置文件的加载和解析。

check负责健康检查，包括常见的各种检查方式。

vrrp模块是来实现VRRP协议的。

### keepalived高可用

#### 第一，安装keepalive(分别在主从上安装)

解压源码包：tar zxvf keepalive-1.9.tar.gz

编译安装 ：进入解压目录  ./configure --prefix=/usr/local/keepalived

make & make install

注：期间可能会有依赖的安装。看具体信息。

#### 配置keepalived

配置文件：cp -R /usr/local/keepalived/etc/keepalived /etc

配置服务：cp /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/

配置系统参数：cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/

#### 配置文件修改

global_defs {

   notification_email {

     acassen@firewall.loc  #邮件通知

   }

   notification_email_from Alexandre.Cassen@firewall.loc  #邮件来源

   smtp_server 192.168.1.161 #邮件服务器

   smtp_connect_timeout 30 #发 送邮件超时时间

   router_id 300 #路由id

}

vrrp_script chk_atlas {  

    script "killall -0 nginx" # 这里的脚本可以自定义

    interval 2 #每2s检测一次

    weight -5 # 检测失败（脚本返回非0）则优先级 -5

    fall 2 #检测连续 2 次失败才算确定是真失败。会用weight减少优先级（1-255之间）

    rise 1 #检测 1 次成功就算成功。但不修改优先级

}

vrrp_instance VI_1 { #实例

    state MASTER  #主配置为MASTER 从为BACKUP

    interface eth0

    virtual_router_id 51 

    priority 103 #优先级，主配置的值 尽量高于从

    advert_int 1 #检查间隔，默认为1秒。这就是VRRP的定时器，MASTER每隔这样一个时间间隔，就会发送一个advertisement报文以通知组内其他路由器自己工作正常

    authentication { #通信验证方式

        auth_type PASS 

        auth_pass 1111

    }

    virtual_ipaddress { #vritual Ip 配置

        192.168.1.110

    }

    track_script { #引用VRRP脚本，即在 vrrp_script 部分指定的名字。定期运行它们来改变优先级，并最终引发主备切换

chk_atlas

    }

}

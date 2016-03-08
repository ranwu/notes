Linux是怎么启动的呢？

1. 打开计算机电源，开始读取BIOS并进行主机的自我测试;
2. 透过BIOS取得第一个可启动装置，读取主要驱动区(MBR)取得启动管理程序;
3. 透过启动管理程序的配置，取得kernel并加载内存且侦测系统硬件;
4. 核心主动呼叫init程序
5. init程序开始运行系统初始化(/etc/rc.d/rc.sysinit)
6. 依据init的配置进行daemon start (/etc/rc.d/rc[0-6].d/\*)
7. 加载本机配置(/etc/rc.d/rc.local)

如何查看run level 5（图形界面）有哪些服务默认可以启动呢？

chkconfig:管理系统服务默认启动与否

```
chkconfig --list [服务名称]

chkconfig [--level [012456]] [服务名称] [on|off]

--list : 列出目前的服务状态
--level: 配置某个服务在该level下启动或关闭
```

让服务在atd在level3,4,5启动：

```
chkconfig --level 345 atd on
```

查看某个服务的状态：
```
/etc/init.d/httpd status
```

查看某服务是否启动：
```
chkconfig --list httpd
```

已经配置为默认启动了，再来看看到底启动该服务没？
```
chkconfig httpd on: chkconfig --list httpd
```

查阅rsync是否启动，若要将其关闭该如何处理？
```
/etc/init.d/rsync status
```
提示没有这个文件，原因是rsync是super daemon管理的，所以当然不可以使用stand alone的启动方式来观察。



将光标下的字母改变大小写：`~`

将光标位置开始的3个字母改变其大小写：`3~`

GIT配置忽略文件：
```
echo '*.swp' > .gitignore
```

字体目录：
```
/usr/shar/fonts/
```

================ 2016.03.13 ==================

计划：
1. PHP开发
2. 扇贝炼句，希望英语有本质提高

================ 2016.03.14 ==================

vim 把加载进内存的文件叫做buffer，buffer不一定可见;若要buffer可见，则必须通过window作为载体呈现：多个window组合成一个tab

vim的buffer、window、tab可以对应理解成视角、布局、工作区。重点关注buffer、window。

vim中每打开一个文件，vim就创建一个相应的buffer，但默认只看得到最后buffer对应的window

`*`星号表示当前有window的buffer，`！`表示当前正在编辑的window;

多文件操作主要有两个显示手段，一个是buffer方式，一个tab方式。如果你打开了三个文件，vim并不将这三个文件显示出来，只能通过`:ls`来查看buffer，然后通过`:bn`(buffer next)和`:bp`(buffer previous)，或者`:b num`这样的命令来切换不同的文件。

删除buffer用`:bd`。

显示监听所有TCP/UDP端口的程序：
```bash
lsof -Pan -i tcp -i udp
```

用sed命令显示出某个文件3-7行的内容：
```
sed -n '3,7p' vims.md
```

查看进程：
```
ps -ef
netstat -tlnp
```

杀掉进程：
```
kill -s 9 PID
```

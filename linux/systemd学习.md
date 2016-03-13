如果要让正在运行的“前台任务”变成“后台任务”，可以先按`ctrl+z`，然后执行`bg`命令，让最后一个暂停的后台任务继续执行。

后台任务的特点：
1. 继承当前session的标准输出(stdout)和标准错误(stderr)。因此，后台任务的所有输出依然会同步地在命令行下显示
2. 不再继承当前session的标准输入(stdin)。你就无法向这个任务输入指令了。如果它试图读取标准输入就会暂停执行(halt)。

### SIGHUP信号
Linux系统：
1. 用户准备退出`session`
2. 系统向该`session`发出SIGHUP信号
3. `session`将SIGHUP信号发送给所有子进程
4. 子进程收到SIGHUP信号后，自动退出

后台任务会不会收到SIGHUP信号？

这由shell的huponexit参数决定的。
```bash
$ shopt | grep huponexit
```
大多数linux系统的这个参数默认是`off`的，因此，session退出的时候，不会把SIGHUP信号发给后台任务，一般来说，后台任务不会随着session一起退出。

### disown命令
通过后台任务启动守护进程的并不保险，因为有的系统的`huponexit`参数可能是打开的(on)。

使用`disown`命令更保险。它可以将指定任务从后台任务列表（jobs命令返回的结果）
之中移除。一个后台任务只要不在这个列表之中，session就肯定不会向它发出`SIGHUP`信号。
```
node server.js &
disown
```
执行上面的命令后，server.js进程就被移除了“后台任务”列表。你可以执行`jobs`命令验证，不会有这个进程。

`disown`的用法：
```bash
# 移除最近一个正在执行的后台任务
$ disown

# 移除所有正在执行的后台任务
$ disown -a

# 不移除后台任务，但是让它们不会收到SIGHUP信号
```


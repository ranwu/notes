1) 首先你需要有mysql的源码包：

解压：tar vzxf mysql.tar.gz

2) 用Cmake编译：

```
cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DMYSQL_USER=mysql \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_READLINE=1 \
-DEXTRA_CHARSETS=all \
-DMYSQL_DATADIR=/usr/local/mysql/var \
-DMYSQL_TCP_PORT=3306
```

然后

```
make 
make install
```

3) 设置权限：

查看是否有mysql用户和用户组：

```
cat /etc/passwd | grep mysql
cat /etc/group | grep mysql
```

没有就创建用户和用户组：

```
groupadd mysql
useradd -g mysql mysql
```

修改mysql主目录的权限：

```
chown -R mysql:mysql /usr/local/mysql/
```

4) 创建var目录并设置权限：

```
mkdir /usr/local/mysql/var/
chown -R mysql:mysql /usr/local/mysql/var/
```
5) 初始化mysql数据库：

```
scripts/mysql_install_db --user=mysql --datadir=/usr/local/mysql/var/ --basedir=/usr/local/mysql/
```

6) 复制mysql的配置文件：

8) 启动MySQL

复制开机启动脚本

```
cp support-files/mysql.server /etc/init.d/mysqld
```

设置PATH路径

```
vim /etc/profile

# 在文件末加入以下内容
export PATH=$PATH:/usr/local/mysql/bin

# 然后刷新文件
source /etc/profile
```

---

修改mysql目录所有者和组

cd /usr/local/mysql
chown -R mysql:mysql . 

初始化mysql数据库
cd /usr/local/mysql/scripts/
./mysql_install_db --user=mysql --datadir=/usr/local/mysql/var/  --basedir=/usr/local/mysql/

复制mysql的配置文件
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf 

复制mysql服务启动脚本及加入PATH路径
cp support-files/mysql.server /etc/init.d/mysqld   

vim /etc/profile   
  
export PATH=$PATH:/usr/local/mysql/bin  
  
source /etc/profile  

启动mysql服务并加入开机自启动(可选这个步骤，以后可以自己启动的)
service mysqld start 
chkconfig --level 35 mysqld on

修改MySQL用户root的密码
mysqladmin -u root password '123456'
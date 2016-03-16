```bash
sudo apt-get autoremove --purge mysql-server-5.5
sudo apt-get remove mysql-server
sudo apt-get autoremove mysql-server
sudo apt-get remove mysql-common
```

清理残余：
```bash
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P
sudo find /etc -name "*mysql*" |xargs  rm -rf 
```

检查是否清理干净：
```bash
dpkg -l | grep mysql # 如果没有返回，说明清理干净
```


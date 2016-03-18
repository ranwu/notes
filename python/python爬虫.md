用户看到的网页是由HTML代码构成，抓取的数据也是这些。一般通过分析和过滤这些HTML代码，来实现对图片、文字等资源的获取。

### Urllib库的使用
简单爬虫demo：
```python
import urllib2

response = urllib2.urlopen("http://www.baidu.com")
print response.read()
```

用`urlopen`方法来打开url
```
urlopen(url, data, timeout) # 接收三个参数,第一个必须，其他可有可无
```
然后用`read`方法来输出内容

### 构造Request
urlopen可以可以传入一个request请求，它其实就是一个Request类的实例：
```python
import urllib2

request = urllib2.Request("http://www.baidu.com")
response = urllib2.urlopen(request)
print response.read()
```

### POST和GET数据传送

POST登陆原理：
```python
import urllib
import urllib2

values = {"username":"ranwuer@gmail.com", "password":"xxxx"}
data = urllib.urlencode(values)
url = "https://xxxxx"
request = urllib2.Request(url,data)
response = urllib2.urlopen(request)
print response.read()
```

headers的一些属性：
```
User-Agent: 有些服务器或Proxy会通过该值来判断是否是浏览器发出的请求
Content-Type: 在使用REST接口时，服务器会检查该值，用来确定HTTP Body中的内容该怎么
解析。
application/xml: 在XML RPC，如RESTful/SOAP调用时使用
application/json: 在JSON RPC调用时使用
application/x-www-form-urlencoded: 浏览器提交Web表单时使用
在使用服务器提供的RESTful 或 SOAP服务时，Content-Type设置错误会导致服务器拒绝服务
```
### Proxy的设置
urllib2默认会使用环境变量http_proxy来设置HTTP Proxy
```python
import urllib2

enable_proxy = True
proxy_handler = urllib2.ProxyHandler({"http": 'http://some-proxy.com:8080})
null_proxy_handler = urllib2.ProxyHandler({})
if enable_proxy:
    opener = urllib2.build_opener(proxy_handler)
else:
    opener = urllib2.build_opener(null_proxy_handler)
urllib2.install_opener(opener)
```

### Timeout设置

可以设置等待多久超时，为了解决一些网站实在响应过慢而造成的影响。

例如，如果第二个参数data为空，那么要特别指定是timeout是多少，写明形参，如果data
已经传入，则不必声明：
```python
import urllib2
response = urllib2.urlopen('http://www.baidu.com', timout=10)
```
```python
import urllib2
response = urllib2.urlopen('http://www.baidu.com', data, 10)
```



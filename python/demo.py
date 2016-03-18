# _*_ coding: utf-8 _*_

import urllib
import urllib2

values = {}
values['username'] = "ranwuer"
values['password'] = "19927120"
data = urllib.urlencode(values)
url = "https://passport.baidu.com/v2/?login&tpl=mn&u=http%3A%2F%2Fwww.baidu.com%2F"
request = urllib2.Request(url, data)
response = urllib2.urlopen(request)
print response.read()

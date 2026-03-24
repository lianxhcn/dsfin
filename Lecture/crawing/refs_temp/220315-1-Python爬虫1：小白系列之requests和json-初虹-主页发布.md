
&emsp;

> Stata连享会 &ensp; [主页](https://www.lianxh.cn/news/46917f1076104.html)  || [视频](http://lianxh.duanshu.com) || [推文](https://www.lianxh.cn/news/d4d5cd7220bc7.html) || [知乎](https://www.zhihu.com/people/arlionn/) || [Bilibili 站](https://space.bilibili.com/546535876) 

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lianxhtop00.png)](https://www.lianxh.cn/news/46917f1076104.html)

> **温馨提示：** 定期 [清理浏览器缓存](http://www.xitongzhijia.net/xtjc/20170510/97450.html)，可以获得最佳浏览体验。

> <font color=red>New！</font> **`lianxh` 命令发布了：**    
> 随时搜索推文、Stata 资源。安装：  
> &emsp; `. ssc install lianxh`  
> 详情参见帮助文件 (有惊喜)：   
> &emsp; `. help lianxh`    
> 连享会新命令：`cnssc`, `ihelp`, `rdbalance`, `gitee`, `installpkg`      
&emsp;


> &#x270C; **[课程详情](https://www.lianxh.cn/news/46917f1076104.html)：** <https://gitee.com/lianxh/Course> 

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lianxhtop01.png)](https://www.lianxh.cn/news/46917f1076104.html)

&emsp;

> &#x26F3; **[课程主页](https://www.lianxh.cn/news/46917f1076104.html)：** <https://gitee.com/lianxh/Course>

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lianxhtop02.png)](https://www.lianxh.cn/news/46917f1076104.html)

&emsp;

> &#x26F3; Stata 系列推文：

- [全部](https://www.lianxh.cn/blogs.html)  | [Stata入门](https://www.lianxh.cn/blogs/16.html) |  [Stata教程](https://www.lianxh.cn/blogs/17.html) |  [Stata资源](https://www.lianxh.cn/blogs/35.html) | [Stata命令](https://www.lianxh.cn/blogs/43.html) 
- [计量专题](https://www.lianxh.cn/blogs/18.html) | [论文写作](https://www.lianxh.cn/blogs/31.html) | [数据分享](https://www.lianxh.cn/blogs/34.html) |  [专题课程](https://www.lianxh.cn/blogs/44.html)
- [结果输出](https://www.lianxh.cn/blogs/22.html) | [Stata绘图](https://www.lianxh.cn/blogs/24.html) | [数据处理](https://www.lianxh.cn/blogs/25.html) |  [Stata程序](https://www.lianxh.cn/blogs/26.html)
- [回归分析](https://www.lianxh.cn/blogs/32.html) |  [面板数据](https://www.lianxh.cn/blogs/20.html)  | [交乘项-调节](https://www.lianxh.cn/blogs/21.html)  | [IV-GMM](https://www.lianxh.cn/blogs/38.html) 
- [内生性-因果推断](https://www.lianxh.cn/blogs/19.html) |  [倍分法DID](https://www.lianxh.cn/blogs/39.html) |  [断点回归RDD](https://www.lianxh.cn/blogs/40.html) |  [PSM-Matching](https://www.lianxh.cn/blogs/41.html) |  [合成控制法](https://www.lianxh.cn/blogs/42.html)
- [Probit-Logit](https://www.lianxh.cn/blogs/27.html) |  [时间序列](https://www.lianxh.cn/blogs/28.html) |  [空间计量](https://www.lianxh.cn/blogs/29.html) | [分位数回归](https://www.lianxh.cn/blogs/48.html) | [生存分析](https://www.lianxh.cn/blogs/46.html) | [SFA-DEA](https://www.lianxh.cn/blogs/49.html)
- [文本分析-爬虫](https://www.lianxh.cn/blogs/36.html) |  [Python-R-Matlab](https://www.lianxh.cn/blogs/37.html) | [机器学习](https://www.lianxh.cn/blogs/47.html)
- [Markdown](https://www.lianxh.cn/blogs/30.html)  | [工具软件](https://www.lianxh.cn/blogs/23.html) |  [其它](https://www.lianxh.cn/blogs/33.html)


> &#x261D; [PDF下载 - 推文合集](https://file.lianxh.cn/KC/lianxh_Blogs.pdf)

&emsp;


> **作者**：初虹  
> **E-mail**：20170237402@mail.sdufe.edu.cn  
> **个人公众号**：虹鹄山庄  

> 本文展示的代码极其基础，结构上没有使用面向对象编程*（Object Oriented Programing，OOP）*，爬取中也没有用到多线程*（multithreading）*，除了想引起你对 Python 爬虫的兴趣外，还期许不懂 Python 的你，能够看到简短的代码量激起你跃跃欲试的好奇心。



&emsp;

---

**目录**
[[TOC]]

---

&emsp;


&emsp;

## 0. 写在前面

初识 Python，感觉这个编程语言很有趣，自学的就是爬虫部分。由于没有编程基础，东一榔头、西一棒槌，零零散散、不成体系。而且一直感觉基础还没打好，项目应用起来必极其艰难，于是当初的激情也就慢慢消下去了。后来有次试着帮老师完成一个小爬虫项目，再次捡起来的时候，竟也跌跌撞撞地完成了。再后来，又以「毫无精进」的水平试着练习了十几个小项目，也能歪歪扭扭地实现了不错的效果。

自己和身边同学偶尔会有爬取微型项目的需求，本着也能让你「上手」的原则我试着完成了本系列的两篇文章，希望对你有启发~

这里我想把常见的爬虫分为两类，一类是 JSON 字符串型、一类是 HTML 型，分别对应 `requests.post() → JSON  → json/jsonpath` 和 `requests.get() → HTML → lxml/xpath` 两种解决路径。于是，本系列的两篇文章分别以现实中的项目案例展开讲这两种不同的爬虫类型。


Python 软件安装不难，Windows 系统配置 **环境变量** 乃由衷之言，寻一款合适的代码编辑器应是必然，网上资料浩繁，此处便不再侃侃而谈。

> **关联阅读**： [为非技术人群准备的 Python 安装指南 - 少数派](https://sspai.com/post/69595)

本文将一个真实案例（ [@国家宗教事务局：宗教活动场所基本信息](http://www.sara.gov.cn/zjhdcsjbxx/index.jhtml) ）拆解，看看该如何使用 Python 爬虫~

首先，浏览一下待爬取的页面十分规范，我们要做的无非就是把这 2830 页所有的内容「下载」下来，然后在 Excel 等文件中持久化存储。

![网站页面](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251933325.png)

一页页复制，显然不现实。那这一切该如何 **自动化** 呢？就得请出本文主角 Python 上场了。于是，我们也理解了**爬虫**通俗意义的原理 —— 自动抓取网页信息、代替繁琐的人工处理。

所以，爬虫步骤基本上可以概括为以下四步：

1.  准备 URL 列表 *（Uniform Resource Locator，统一资源定位符，即我们通常说的网址。）*
2.  遍历 URL，发送请求*（Request）*，获取响应*（Response）*
3.  提取数据
4.  数据存储

这其中最重要的是第二步。关于如何发送请求，我们待会儿再说，这里先聊几句题外话：为啥发送了请求，就能获取响应了呢？这就得从 **HTTP 协议** 说起了。~~（故事太长，简言一二）~~ HTTP 协议*（Hyper Text Transfer Protocol：超文本传输协议）*是服务器*（Server）*和客户端*（Client）*之间进行**数据交互**的「沟通方式」。浏览器作为 HTTP 客户端通过  **URL ** 向 HTTP 服务端即  **WEB**  发送请求，Web 根据接收到的请求，向客户端发送对应的响应信息。

![常见的请求头和响应头，图源 <https://book.apeland.cn/details/66/>](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251933327.png)

运用上面提到的爬虫四步，理顺咱们项目的爬取思路。一共 2830 页，每页15条，计算下来共 42439 条数据，没有详情页需要爬取，所以实际工作量很小，就两步：

- 构造所有页面的 URL 列表
- 根据某页 URL 爬取该页面所有数据

现在思路明确了，那就一步步来吧。

&emsp;

## 1. 抓包

第一步构造 URL 列表。等等，这里的 URL 就是我们看到的浏览器地址栏的那串地址吗？眼见不一定为实。我们自认为造访的地址和浏览器向服务器发送请求的地址可能不是一致的。

乍听起来，你或许不相信。不妨试试点击[此页面](http://www.sara.gov.cn/zjhdcsjbxx/index.jhtml)底部的页码按钮，观察浏览器地址栏的变化。发现了吗，地址栏并没有任何变化。明明是不同的页码，返回的数据也不相同，为啥「看起来」却是同一个「地址」呢？真正发起请求的 URL *（Request URL）*又是哪一个幕后大 BOSS 呢？

侦查案件抽丝剥茧寻蛛丝马迹之前，得先选个「好工具」带着。这个工具的必备功能是能分析出本地浏览器和远端服务器之间传递的信息就是，它就是——**「抓包」**。当然，专业的抓包工具不少，比如 [Fiddler](https://www.telerik.com/fiddler) 、 [Wireshark](https://www.wireshark.org/) 等，但对于中小型爬虫来说，浏览器自带的**开发者工具** 就绰绰有余了。

在浏览器内*（以 Chrome 浏览器为例）*按下 `F12`，或者右键选择**检查**，即可调出「开发者工具」。在下图最上方的工具栏中，网络面板 `Network` 可以得到发送请求后获取的服务器响应信息，也就是我们在分析中最关心的数据来源。在使用中，合理利用下面几点可以使自己的「抓包」效率更高：

- 勾选 `Preserve log`
    - 默认情况下，页面跳转之后，之前的请求信息都会消失，而选择 `Preserve log` ，之前的请求也能被一并保留。
    - 比如，上图的绿色方框，除了第二次的请求被保留外，第一次请求也保留下来了。
- Filter 过滤
    - 筛选 URL 地址进行过滤，有时候返回的结果会非常多，通过部分 URL 过滤可以极大缩小结果范围
- 请求种类的类型
    - 根据不同的类型进行结果的过滤

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251933328.png)

> **关联阅读**：
> - [浏览器实现抓包过程详解](http://c.biancheng.net/python_spider/capture-package.html)
> - [Google Chrome 抓包分析详解 - 知乎](https://zhuanlan.zhihu.com/p/32825491)


&emsp;

## 2. 准备 URL 列表

到这里或许你还是一头雾水。别怕，我引申的几个小概念确实无聊了些。不妨你也跟着试一试。点击 `F12`，选择 `Network`，再次刷新，是不是一瞬间「冒」出了好多东西？这些都是服务器返回的响应，这些响应共同组成了你眼中、能「看得见」的页面。那我们要找的真正 Request URL 在哪里呢？

此处就是经验之谈了。你尝试得多了，慢慢也会有自己的一套「侦查」体系了。给个小 TIP，一般来说 Img（后缀包括 `.png`/`.gif` 等）、CSS（后缀 `.css`）和JS（后缀 `.js`）等基本是可以先 Pass 的（上图 Name 栏）。去掉这些，剩下的一定也没几个了。

接下来，把光标定位到上图蓝色方块上面的 `Response` 处，挨个点进去看看，如果 Response 能出现页面里的数据信息，那必是此无疑了。还可以切换到 Response 左侧的 Preview 标签，更加直观查看数据信息（下图绿框）。

![第一页浏览器抓包信息](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251933329.png)

呼，距离这个重要「线索」最后的确定之差一步了，怀着激动的心情将视线移到 Preview 左侧的 Headers，好家伙，「嫌疑人」（Request URL）的踪迹原形毕露了 ！

```python
Request URL: http://www.sara.gov.cn/api/front/zj/query
```

等等，先别高兴太早，不信你试试把该链接放进浏览器地址栏，出错了吧，别灰心，那是因为还有一个重要的知识没讲：`Request Method`。

&emsp;

## 3. 发送请求，获取响应：requests

常见的 Method 有两种，GET 和 POST。这里显然是 POST 请求。但不管是哪种类型的请求，Python 的 `requests` 库都可以轻松应对。

 > **关联阅读：**[Requests 中文文档](https://docs.python-requests.org/zh_CN/latest/index.html)

### 3.1 GET 方法

```python
# 导入模块
import requests

# User-Agent 伪装 (headers 为字典类型)
headers = {
  "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
}

# 自定义参数
params = {
  "kw":"hello"
}

# 定义代理服务器 (proxies 为字典类型)
proxies = {
  "http":"http://IP地址:端口号",
  "https":"https://IP地址:端口号"
}

# 定义请求地址
url = 'http://www.baidu.com'

# 发送 GET 请求获取响应
    # 自定义请求头：requests.get(url, headers=headers)
    # 携带参数发送请求：requests.get(url, params=params)
    # 使用代理：requests.get(url, proxies = proxies)
    # 忽略证书错误：requests.get(url,verify=False)
    # 设置超时参数（如果5秒钟未返回响应则报错）：requests.get(url,timeout=5)
response = requests.get(url, headers=headers, params=params, proxies=proxies, verify=False, timeout=5)

# 获取响应的 html 内容
html = response.content.decode()
print(html)
```

这几行代码基本上把 `requests` 库 中的 GET 方法介绍了大概，或许你还是一下子吃不消，无妨，我们一同「会会」它。

首先是导入模块，Python 语法为 `import`，接着是定义参数和 Request URL，GET 方法里最重要的参数是 `headers` （请求头），而 headers 中最重要的又是 User-Agent*（UA）*，简而言之，就是模拟请求时你可以先只定义 UA 参数，如果不行就再依次尝试加入 Referer 、Cookie 和 Host，最不济把请求头里所有的参数*（见上图：常见请求头和响应头，当然每个网站的请求头略有差别，以抓包结果为依据）*都加进去总没错。

`params` 用来自定义参数，因为这里的现实需求是在百度主页搜索 `hello` 后打印页面源码，很多时候这个参数是不需要的。`proxies` 用来设置代理、更换 IP，是反反爬的基础手段之一。

把参数都传递进 `requests.get()` 便可发起 GET 请求，同时返回响应对象*（此处定义为 response）* ，然后调用响应对象的 `content.decode()` 属性来获取响应数据。

比如，你可以试着爬取[必应](https://cn.bing.com/) 首页的页面数据~

```python
import requests

url = 'https://cn.bing.com/?mkt=zh-CN/'
headers = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36"}

response = requests.get(url=url, headers=headers)
text = response.content.decode()
print(text)
```

哦对了，还有一个小窍门。模拟请求时，除了必须要加入 UA 参数外，还可以伪装 UA，比如搭建自己的 UA 池（这和搭建 Cookie 池、代理池是一样的道理），可以使得每次爬取或每隔一段时间换一个不同的 UA，也能起到反反爬的效果。或者更简单地，我们使用 `fake_useragent` 模块随机生成 UA。下面的代码就能生成 500 个「伪 UA」，把这个 snippet 保存下来，可以常用。

```python
from fake_useragent import UserAgent

ua = UserAgent(verify_ssl=False)
for i in range(1,500):
    headers = {
        "User-Agent":ua.random,
    }
```

### 3.2 POST 方法

POST 方法和 GET 方法几无差别，但是 POST 必须得传递以字典形式定义的自定义参数。其余便也不再赘述了。

```python
# 导入模块
import requests
# 定义请求地址
url = 'http://www.baidu.com'
# 定义自定义请求头
headers = {
  "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
}
# 定义POST请求参数
data = {
  "kw":"hello"
}

# 使用 POST 请求参数发送请求
response = requests.post(url,headers=headers,data=data)
# 获取响应的 html 内容
html = response.text
```


我们回到真实的案例中来，上面也说到 `http://www.sara.gov.cn/api/front/zj/query` 这个 URL 并不完全正确，结合刚才提到的知识（POST 方法），找找 POST 需要传递的自定义参数有没有线索。

发现了没，线索就隐藏在自定义参数里（见图：第一页浏览器抓包信息的第二个红框框）。第一页 page 为 1，第二页 page 为 2，以此类推，第 100页 page 为 100，规律很容易找出来。一个简单的 `for` 循环就能完美定义出 Request URL 列表啦！

```python
# 爬取前100页
for pagenum in range(1, 100):
    payload={
        "pageSize": 15,
        "page": pagenum,
    }
```

在使用 `requests.post` 发送请求时，别忘了带上 `data=payload` 参数~

```python
url = "http://www.sara.gov.cn/api/front/zj/query"
resp = requests.post(url=url, headers=headers, data=payload, verify=False)
text = resp.content.decode()
```

然后，我们把发送请求、获取响应这一步放进 `for` 循环体下，就能完成爬虫四步的前两步了。万里长征已过半，深呼一口气，我们接着干。

```python
for pagenum in range(1, 100):
	payload={
	 "pageSize": 15,
	 "page": pagenum,
	}

	url = "http://www.sara.gov.cn/api/front/zj/query"
	resp = requests.post(url=url, headers=headers, data=payload, verify=False)
	text = resp.content.decode()
```

&emsp;

## 4. 数据提取大法 ：json 及 jsonpath

接下来就第三步——解析数据了。本案例的数据是以 JSON 格式存储的，我们需要将他们提取出来，然后保存。

![<http://www.sara.gov.cn/zjhdcsjbxx/index.jhtml> 抓包后 URL 返回的 Response](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251933330.png)

> JSON (JavaScript Object Notation) 是一种轻量级的数据交换格式，适用于进行数据交互的场景，使得人们很容易的进行阅读和编写。

JSON 对象在大括号 `{}` 中书写，对象可以包含多个 key/value（键/值）对，key 必须是字符串，value 可以是合法的 JSON 数据类型（字符串, 数字, 对象, 数组, 布尔值或 null），key 和 value 中使用冒号 `: ` 分割，每个 key/value 对使用逗号 `,` 分割。可以使用在线解析工具进行 JSON 数据的格式化，比如 [OKTools](https://oktools.net/json) 、 [Be JSON](https://www.bejson.com/) 。

### 4.1 json 模块的入门使用

```Python
# json.dumps 实现Python类型转化为json字符串
	# indent 实现换行和空格
	# ensure_ascii=False实现让中文写入的时候保持为中文
json_str = json.dumps(mydict,indent=2,ensure_ascii=False)

# json.loads 实现json字符串转化为Python类型
my_dict = json.loads(json_str)

# json.dump 实现把Python类型写入类文件对象
with open("temp.txt","w") as f:
    json.dump(mydict,f,ensure_ascii=False,indent=2)

# json.load 实现类文件对象中的json字符串转化为Python类型
with open("temp.txt","r") as f:
    my_dict = json.load(f)
```

`json.dumps()` 和 `json.loads()` 可以实现 Python 类型和 JSON 字符串的互相转化。对于我们的真实案例，可以 `dict_temp = json.loads(resp.content.decode())` 进行 Python 语法操作了。

### 4.2 jsonpath 语法规则

除了 `json` 模块，我还想给你介绍一个进阶操作，用于解决多层嵌套的复杂字典问题，这种情况下想要根据 key 和下标来批量提取 value，这是比较困难的，因为层级较多。`jsonpath` 模块就能解决这个痛点。

```Python
from jsonpath import jsonpath
ret = jsonpath(a, 'jsonpath 语法规则字符串')
```

![jsonpath 的语法规则](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251933331.png)

- 最常使用的语法是：
  - 根节点：`$`
  - 子节点：`.`
  - 子孙节点：`..`
- 需要注意的是，`jsonpath` 的结果是 **列表**，获取数据必须索引。

> **关联阅读：**[JSON 教程 | 菜鸟教程](https://www.runoob.com/json/json-tutorial.html)
> **关联阅读：**[@B站小甲鱼 特效最佳的 Python 教程](https://www.bilibili.com/video/BV1et411L7eR?p=25)

好了，再次回到主题上来。返回的类型既然是 JSON 字符串，直接 `jsonpath` 提取便可。一共五个字段（宗教类型、派别、场所名称、地址和负责人姓名），先定义空列表（list），再 `extend` 或 `append` 拼接就完事了。

```python
import json
import jsonpath

address = []
faction = []
person_charge = []
place_name = []
religion_name = []

dict_temp = json.loads(resp.content.decode())

address.extend(jsonpath.jsonpath(dict_temp, '$..address'))
faction.extend(jsonpath.jsonpath(dict_temp, '$..faction'))
person_charge.extend(jsonpath.jsonpath(dict_temp, '$..person_charge'))
place_name.extend(jsonpath.jsonpath(dict_temp, '$..place_name'))
religion_name.extend(jsonpath.jsonpath(dict_temp, '$..religion_name'))
```

&emsp;

## 5. 持久化存储

最后一步，就更简单了，定义两个列表 `proj` 和 `tablehead`，使用 `dict(zip())` 方法将两个列表合并为一个字典，然后使用 `pandas` 模块存储，大功告成！

```python
proj = [pagenum, address, faction, person_charge, place_name, religion_name]
tablehead = ['pagenum', 'address', 'faction', 'person_charge', 'place_name', 'religion_name']
dataframe = pd.DataFrame(dict(zip(tablehead, proj)))
dataframe.to_excel("./sara/sara.xlsx", encoding='gbk', index=False)
```

解决了 JSON 字符串式的爬虫，不要走开，接下来的文章我们继续看看第二种类型如何应对~

&emsp;

## 6. 附：完整 Python 文件代码

完整的 `py` 文件：

```python
# Author: @初虹
# Date: 2021-11-14
# mail: chuhong@mail.sdufe.edu.cn
# 个人公众号: 虹鹄山庄

# 导入模块
import requests
import json
import jsonpath
import time
import random
from fake_useragent import UserAgent
from pandas.core.frame import DataFrame
import pandas as pd

# 伪装 UserAgent
ua = UserAgent(verify_ssl=False)
for i in range(1,500):
    headers = {
        "User-Agent":ua.random,
    }
    
# 定义列表
address = []
faction = []
person_charge = []
place_name = []
religion_name = []

# for 循环自定义爬取的页数
for pagenum in range(1, 100):
    print("正在爬取的页码：" +str(pagenum))
    
    # 定义 POST 请求的参数
    payload={
        "pageSize": 15,
        "page": pagenum,
    }

    # 发送请求，获取响应 
    url = "http://www.sara.gov.cn/api/front/zj/query"
    resp = requests.post(url=url, headers=headers, data=payload, verify=False)
    dict_temp = json.loads(resp.content.decode())
    
    # jsonpath 提取数据
    address.extend(jsonpath.jsonpath(dict_temp, '$..address'))
    faction.extend(jsonpath.jsonpath(dict_temp, '$..faction'))
    person_charge.extend(jsonpath.jsonpath(dict_temp, '$..person_charge'))
    place_name.extend(jsonpath.jsonpath(dict_temp, '$..place_name'))
    religion_name.extend(jsonpath.jsonpath(dict_temp, '$..religion_name'))
    
    # 定义列表，保存数据
    proj = [pagenum, address, faction, person_charge, place_name, religion_name]
    tablehead = ['pagenum', 'address', 'faction', 'person_charge', 'place_name', 'religion_name']
    dataframe = pd.DataFrame(dict(zip(tablehead, proj)))
    dataframe.to_excel("./sara1114/sara2.xlsx", encoding='gbk', index=False)
    
    time.sleep(random.randint(1,4))
print("Finished!!!---------------------------")
```



&emsp;

## 7. 相关推文

> Note：产生如下推文列表的 Stata 命令为：   
> &emsp; `lianxh 爬`  
> 安装最新版 `lianxh` 命令：    
> &emsp; `ssc install lianxh, replace` 

- 专题：[专题课程](https://www.lianxh.cn/blogs/44.html)
  - [⏩ 专题课：文本分析-爬虫-机器学习-2022年4月](https://www.lianxh.cn/news/88426b2faeea8.html)
  - [⚽助教招聘：文本分析-爬虫-机器学习](https://www.lianxh.cn/news/d8995f7fe9dcf.html)
  - [助教入选结果 - 连享会 文本分析与爬虫直播课](https://www.lianxh.cn/news/b788ae9022934.html)
- 专题：[文本分析-爬虫](https://www.lianxh.cn/blogs/36.html)
  - [Stata爬虫：爬取地区宏观数据](https://www.lianxh.cn/news/815b934b27073.html)
  - [Stata爬虫：爬取Ａ股公司基本信息](https://www.lianxh.cn/news/9c1607842eb49.html)
  - [Python：爬取东方财富股吧评论进行情感分析](https://www.lianxh.cn/news/788ffac4c50fb.html)
  - [Stata爬虫-正则表达式：爬取必胜客](https://www.lianxh.cn/news/8c6be3c47d2eb.html)
  - [Python爬虫: 《经济研究》研究热点和主题分析](https://www.lianxh.cn/news/2fb619662956e.html)
- 专题：[Python-R-Matlab](https://www.lianxh.cn/blogs/37.html)
  - [Python爬虫：爬取华尔街日报的全部历史文章并翻译](https://www.lianxh.cn/news/e080bab8798f9.html)
  - [Python爬虫：从SEC-EDGAR爬取股东治理数据-Shareholder-Activism](https://www.lianxh.cn/news/f2ec917e39a6c.html)
  - [Python：爬取巨潮网公告](https://www.lianxh.cn/news/94192bcec139e.html)
  - [Python：爬取上市公司公告-Wind-CSMAR](https://www.lianxh.cn/news/ca3a4a5b54758.html)
  - [Python: 6 小时爬完上交所和深交所的年报问询函](https://www.lianxh.cn/news/0e57c635cd225.html)
  - [Python 调用 API 爬取百度 POI 数据小贴士——坐标转换、数据清洗与 ArcGIS 可视化](https://www.lianxh.cn/news/a72842993b22b.html)
  - [Python 调用 API 爬取百度 POI 数据](https://www.lianxh.cn/news/223fabe3b6724.html)
  - [Python: 批量爬取下载中国知网(CNKI) PDF论文](https://www.lianxh.cn/news/a27e2dd57f12e.html)



![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Lianxh_装饰黄线.png)

&emsp;

## 相关课程

>### 免费公开课  

- [直击面板数据模型](https://lianxh.duanshu.com/#/brief/course/7d1d3266e07d424dbeb3926170835b38) - 连玉君，时长：1小时40分钟，[课程主页](https://gitee.com/arlionn/PanelData)，[Bilibili 站版](https://www.bilibili.com/video/BV1oU4y187qY)
- [Stata 33 讲](http://lianxh-pc.duanshu.com/course/detail/b22b17ee02c24015ae759478697df2a0) - 连玉君, 每讲 15 分钟. [课程主页](https://gitee.com/arlionn/stata101)，[课件](https://gitee.com/arlionn/stata101)，[Bilibili 站版](https://space.bilibili.com/546535876/channel/detail?cid=160748)    
- [Stata 小白的取经之路](https://lianxh.duanshu.com/#/brief/course/137d1b7c7c0045e682d3cf0cb2711530) - 龙志能，时长：2 小时，[课程主页](https://gitee.com/arlionn/StataBin) 
- 部分直播课 [课程资料下载](https://gitee.com/arlionn/Live) (PPT，dofiles等) 




>### 最新课程-直播课   

| 专题 | 嘉宾    | 直播/回看视频    |
| --- | --- | --- |
| &#x2B50; **[最新专题](https://www.lianxh.cn/news/46917f1076104.html)**|   | 文本分析、机器学习、效率专题、生存分析等 |
| 研究设计 | 连玉君    | [我的特斯拉-实证研究设计](https://lianxh.duanshu.com/#/course/5ae82756cc1b478c872a63cbca4f0a5e)，[-幻灯片-](https://gitee.com/arlionn/Live/tree/master/%E6%88%91%E7%9A%84%E7%89%B9%E6%96%AF%E6%8B%89-%E5%AE%9E%E8%AF%81%E7%A0%94%E7%A9%B6%E8%AE%BE%E8%AE%A1-%E8%BF%9E%E7%8E%89%E5%90%9B)|
| 面板模型 | 连玉君    | [动态面板模型](https://efves.duanshu.com/#/brief/course/3c3ac06108594577a6e3112323d93f3e)，[-幻灯片-](https://quqi.gblhgk.com/s/880197/o7tDK5tHd0YOlYJl)   |
| 面板模型 | 连玉君  | [直击面板数据模型](https://lianxh.duanshu.com/#/brief/course/7d1d3266e07d424dbeb3926170835b38) [免费公开课，2小时]  |

- Note: 部分课程的资料，PPT 等可以前往 [连享会-直播课](https://gitee.com/arlionn/Live) 主页查看，下载。

&emsp; 

> #### &#x26F3; [课程主页](https://www.lianxh.cn/news/46917f1076104.html)

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lianxhbottom01.png)](https://www.lianxh.cn/news/46917f1076104.html)

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lianxhbottom02.png)](https://www.lianxh.cn/news/46917f1076104.html)

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/lianxhbottom03.png)](https://www.lianxh.cn/news/46917f1076104.html)

> #### &#x26F3; [课程主页](https://www.lianxh.cn/news/46917f1076104.html)

&emsp;

>### 关于我们

- **Stata连享会** 由中山大学连玉君老师团队创办，定期分享实证分析经验。
- [连享会-主页](https://www.lianxh.cn) 和 [知乎专栏](https://www.zhihu.com/people/arlionn/)，700+ 推文，实证分析不再抓狂。[直播间](http://lianxh.duanshu.com) 有很多视频课程，可以随时观看。
- **公众号关键词搜索/回复** 功能已经上线。大家可以在公众号左下角点击键盘图标，输入简要关键词，以便快速呈现历史推文，获取工具软件和数据下载。常见关键词：`课程, 直播, 视频, 客服, 模型设定, 研究设计, stata, plus, 绘图, 编程, 面板, 论文重现, 可视化, RDD, DID, PSM, 合成控制法` 等

&emsp; 

> 连享会小程序：扫一扫，看推文，看视频……

[![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/连享会小程序二维码180.png)](https://www.lianxh.cn/news/46917f1076104.html)

&emsp; 

> 扫码加入连享会微信群，提问交流更方便

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/连享会-学习交流微信群001-150.jpg)

> &#x270F;  连享会-常见问题解答：  
> &#x2728;  <https://gitee.com/lianxh/Course/wikis>  

&emsp; 

> <font color=red>New！</font> **`lianxh` 命令发布了：**    
> 随时搜索连享会推文、Stata 资源，安装命令如下：  
> &emsp; `. ssc install lianxh`  
> 使用详情参见帮助文件 (有惊喜)：   
> &emsp; `. help lianxh`

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Lianxh_装饰黄线.png)

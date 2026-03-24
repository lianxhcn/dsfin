
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
> **E-mail**：chuhong@mail.sdufe.edu.cn  
> **个人公众号**：虹鹄山庄  

> **提示**：本文是系列文章的第二篇，建议你先看完上一篇，再来继续。


&emsp;

---

**目录**
[[TOC]]

---

&emsp;


本文将以[中国自愿减排交易信息平台 China Certified Emission Reduction Exchange Info-Platform](http://cdm.ccchina.org.cn/zyblist.aspx?clmId=164) 为例，详细介绍常见爬虫的第二种类型~ 

![网站页面](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934982.png)

先上图，一共 44 页，共 861 条数据~ 乍一看，比上篇文章的案例稍微复杂了一点，因为要根据项目 URL 进入详情页爬取具体信息。不过别怕，同样按照**爬虫四步**来分析。

1.  准备 URL 列表 *（Uniform Resource Locator，统一资源定位符，即我们通常说的网址。）*
2.  遍历 URL，发送请求*（Request）*，获取响应*（Response）*
3.  提取数据
4.  数据存储

&emsp;

## 1. 获取所有页面的 URL：url_page

我们的最终目标是进入详情页获取到每个项目详细的备案信息，所以在进入详情页之前，我们需要得到每个项目的 URL（`url_li`），才能根据该 URL 发起对详情页的请求。而获取项目的 URL 需要处理好「翻页」动作，也就是先把这 44 页的页面 URL （`url_page`）拿到手。

一边点击不同的页码，一边观察浏览器地址栏的变化，是不是可以很容易找到规律。

```
http://cdm.ccchina.org.cn/zyblist.aspx?clmId=164&page=0  #第1页
http://cdm.ccchina.org.cn/zyblist.aspx?clmId=164&page=3  #第2页 
http://cdm.ccchina.org.cn/zyblist.aspx?clmId=164&page=43 # 第44页
```

一个 `for` 循环搭配字符串格式化输出函数 `format()`，就能很容易解决「翻页」问题。不信你也试试运行下面三行命令，是不是与预期完全一致~

```python
for page_num in range(0, 44):
    url_page = 'http://cdm.ccchina.org.cn/zyblist.aspx?clmId=164&page={}'.format(page_num)
    print(url_page)
```

> **关联阅读**：[Python format 格式化函数 | 菜鸟教程](https://www.runoob.com/python/att-string-format.html)

&emsp;

## 2. 获取所有项目的 URL：`url_li

接下来就得获取项目 URL 了（`url_li`）。点开几个项目看看浏览器地址栏的变化，是不是和 `url_page` 基本相同，除了尾部的数字在动态变化，其余都没变~

```
http://cdm.ccchina.org.cn/zybDetail.aspx?Id=905 #第一个项目
http://cdm.ccchina.org.cn/zybDetail.aspx?Id=906 #第二个项目
http://cdm.ccchina.org.cn/zybDetail.aspx?Id=907 #第三个项目
```

但是这次可以 `for` 循环和 `format()` 的方式解决嘛？恐怕不行。因为我们无法确定 `Id` 后面的数值是规律可循的、还是随机的。不管怎样，接下来搞定它。

![抓包](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934983.png)

拿出我们的侦查工具——抓包，看他究竟藏在哪里。应该不费力就能确定`url_page` 对应的`Request Method` 为 `GET`，所以直接 `requests.get()` 便可轻松获取页面对应 HTML。

```Python
import requests
from fake_useragent import UserAgent

# 伪装 UA
ua = UserAgent(verify_ssl=False)
for i in range(1,500):
    headers = {
        "User-Agent":ua.random,
    }

# 发起请求、获取响应
resp = requests.get(url=url_page, headers=headers, verify=False)
html = resp.content.decode()
```

那如何从 HTML 页面中提取数据呢？回答这个问题之前，我们先来回顾一下上篇文章返回的 Response 类型是哪种嘛？JSON 字符串是吧，然后用的 `json` 模块和 `jsonpath` 模块提取数据。

而本文返回 HTML 格式，需要通过正则表达式 `re` 库 、 Beautiful Soup 库或`lxml` 等模块获取数据。`lxml` 模块解析速度最快，语法也很简洁，本文重点介绍这个。

`lxml` 模块作为一款高性能的 Python HTML 、XML 解析器，在解析数据方面离不开 `XPath` 的加持。 `lxml`可以利用 `XPath`*(XML Path Language)*  快速定位特定的元素及获取的节点信息，数据解析效率飞起。

> **关联阅读**：
> - [lxml 中文文档 @w3cschool](https://www.w3cschool.cn/lxml/)
> - [XPath 教程 @w3cschool](https://www.w3school.com.cn/xpath/index.asp)

### 2.1 Xpath  常用表达式

| 表达式                           | 描述 |
| ------------------------------- | ---- |
| `nodename`|    选中该节点的所有子节点|
| `/`    |从根节点选取、或者是元素和元素间的过渡|
| `//`    |从匹配选择的当前节点选择文档中的节点，而不考虑它们的位置|
| `.`    |选取当前节点|
| `..`    |选取当前节点的父节点|
| `@`    |选取属性|
| `text()`|    选取文本|

除了写 `xpath` 语法外，还可以直接使用节点选择的工具 **XPath Helper** 在浏览器中进行语法测试，这是一个浏览器插件，各大浏览器扩展商店均不难下载，若网络不畅，可移步 [ 浏览器技巧：我的常用扩展](https://mp.weixin.qq.com/s/jk1-aFwkGn0NzcV-1fCGhQ) 寻找谷歌应用商店镜像网站下载插件。

![XPath 浏览器插件](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934984.png)

> **注意**： 该工具是用来学习 `xpath` 语法的，他们都是从 `elements` 中匹配数据，`elements` 中的数据和 `Network`里 URL 地址对应的 `Response` 不相同，所以代码中，不建议使用这些工具进行数据的提取。

### 2.2 lxml 模块使用

- 导入 `lxml` 模块的 `etree` 库
```Python
from lxml import etree
```

- `etree.HTML` 实例化 Element 对象，Element 对象具有 `xpath` 的方法，返回列表类型，能够接受 `bytes` 类型的数据和 `str` 类型的数据。

```Python
html = etree.HTML(text) 
ret_list = html.xpath("xpath 字符串")
```

解析过程中有个小技巧，建议你也形成这个习惯：先分组后提取。如果我们取到的是一个节点，返回的是 `element` 对象，可以继续使用 `xpath` 方法，对此可在后面的数据提取过程中先根据某个标签进行分组，分组之后再进行数据提取。

```Python
html = etree.HTML(text)
# 先提取一个整组
li_list = html.xpath("//li[@class='item-1']")

#再在每一组中继续进行数据的提取
for li in li_list:
    item = {}
    item["href"] = li.xpath("./a/@href")[0]
    item["title"] = li.xpath("./a/text()")[0]
    # 如果部分数据缺失使得提取出来的数据可能存在对应错误的情况，可使用 if else 三元运算符来解决
    # 三元运算符：exp1 if condition else exp2
    # item["href"] = li.xpath("./a/@href")[0] if len(li.xpath("./a/@href"))>0 else None
    # item["title"] = li.xpath("./a/text()")[0] if len(li.xpath("./a/text()"))>0 else None
    # print(item)
```

好了，回到我们的案例中来。我们想要在 HTML 源码中获取项目 URL，通过 `Ctrl+F` 搜索项目名称快速定位到页面对应位置，通过获取 `a` 标签的 `href` 属性实现对项目 URL （`url_li`）的补齐。

![抓包分析](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934985.png)

抓包分析（上图）可以看出项目信息都存储在 `class="li"` 里，我们要找补全的 `url_li` 动态部分，就在 `a` 标签中。于是，循着「先分组后提取」的思路，通过 `xpath` 定位到该页面的所有项目并存储为 `li_list`，再遍历 `li_list`，将 `title`、`href` 和 `pagenum` 存储为字典（dict）类型，然后通过 `pandas` 存储为 `.csv` 格式。

```Python
html1 = etree.HTML(html_first)  
content_list = []
# 先分组
li_list = html1.xpath("//body//li[@class='li']")

# 再提取
for li in li_list:
    item = {}
    item["href"] = "http://cdm.ccchina.org.cn/"+li.xpath(".//a/@href")[0]
    item["title"] = li.xpath(".//a/@title")[0]
    item["pagenum"] = page_num+1
    content_list.append(item)
    # 持久化存储
    dataframe = pd.DataFrame(content_list)
    dataframe.to_csv("./ccer/ccer_url.csv", encoding='gbk')
time.sleep(random.randint(1 ,2))
print("第"+str(page_num+1)+"页---")
```

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934987.png)

这样就把所有项目的 URL （`url_li`）爬好并储存在 `ccer_url.csv` 中了，接下来遍历上图的变量 `href`，就能爬取详情页数据了。 

&emsp;

## 3. 获取详情页数据

首先，我们需要读取 `ccer_url.csv` 中 `href` 列，作为详情页的 URL。

```python
# 遍历存储好的项目 URL 
df = pd.read_csv('./ccer/ccer_url.csv',encoding='gbk')
for url_li in df['href'].to_list():
    print(url_li)
```

接下来，发送 `get` 请求，获取响应。

```python
# 发送请求，获取响应
response = requests.get(url_li, headers=headers, verify=False)
html_second = response.content.decode()
html2 = etree.HTML(html_second)
```

最后，思路基本同上，按照「先分组后提取」的原则遍历得到每个项目具体信息。

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934988.png)

```Python
# 数据提取：先分组再提取
td_list = html2.xpath("//div[@class='text_main']/div/table/tbody")
for td in td_list:
	item = {}
	# html.xpath("normalize-space(xpath语法)"") 可以去除\r \n \t
	item["beian_num"]   = td.xpath("normalize-space(./tr[1]/td[2])")
	item["name"]        = td.xpath("normalize-space(./tr[2]/td[2])")
	item["owner"]       = td.xpath("normalize-space(./tr[3]/td[2])")
	item["category"]    = td.xpath("normalize-space(./tr[4]/td[2])")
	item["type"]        = td.xpath("normalize-space(./tr[5]/td[2])")
	item["method"]      = td.xpath("normalize-space(./tr[6]/td[2])")
	item["quantity"]    = td.xpath("normalize-space(./tr[7]/td[2])")
	item["period"]      = td.xpath("normalize-space(./tr[8]/td[2])")
	item["institution"] = td.xpath("normalize-space(./tr[9]/td[2])")
	item["report"]      = td.xpath("normalize-space(./tr[10]/td[2]//span/b/span/a/text())")
	item["time1"]       = td.xpath("normalize-space(./tr[11]/td[2])")
	item["other"]       = td.xpath("normalize-space(./tr[12]/td[2])")

	item_list.append(item)
	df1 = pd.DataFrame(item_list)
	df1.to_csv("./ccer/ccer_item.csv", encoding="gb18030")
```

于是，所有任务就大功告成啦~

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/202111251934989.png)

&emsp;

## 4. 矛与盾：反爬与反反爬

在结束本文之前，还是想要聊聊反爬与反反爬这事儿。爬虫，短期内快速爬取数据的方式会给网站服务器造成不小压力，所以很多网站都有比较严格的反爬措施，比如，常见反爬手段可粗略分为五大类：

- `headers` 字段：`User-Agent`、`referer`、`cookie` 
- IP 地址
- `js`：`js` 实现跳转、`js` 生成请求参数或数据加密
- 验证码
- 其他：自定义字体（比如：猫眼电影）、CSS像素偏移（比如：去哪儿网）

而对于用户来说，既然你有「盾」护，那就只能以锋「矛」应对了。反反爬的主要思路是尽可能地**模拟浏览器**，浏览器如何操作，代码中就如何实现。所以反爬与反反爬其实就处于「动态博弈」之中。

下面提了几点反反爬的主要措施，毕竟只有知己知彼了，才能对症下药。

严控 IP 和 `headers` 是最常见的反爬手段。如果爬取过快，同一个 IP 大量请求了对方服务器，那有可能会被识别为爬虫，也就是我们常听到的「封 IP」。对应的措施可以通过购买高质量的代理 IP 搞定。对于 `headers` 字段的反爬问题，我们的原则就是「缺啥补啥」，Response 返回的 `headers` 字段很多，一开始我们不清楚哪些有用、哪些没用，只能一次次尝试，在盲目尝试之前，也可以参考别人的思路。

比如，伪装 UA 需要在请求前添加 User-Agent 字典，当然更好的方式是构建 **User-Agent 池** 或**随机生成 UA**。还有些网站（比如 [豆瓣电视剧](https://movie.douban.com/tv/)）必须得加入 `referer` 字段来反反爬，抑或某些网站需要登录（比如 [新浪微博](https://weibo.com/login.php/)）才能获取全部数据，那我们就需要对应加上`referer` 和 `cookie` 字段。

> **关联阅读：** [UA 池的构建](https://cloud.tencent.com/developer/article/1580789)、[Cookies 池的搭建](https://cuiqingcai.com/8243.html)。

关于 `js` 生成请求参数或数据加密，通过 Selenium 很容易解决；还有现在网上随处可见的验证码也属于反爬手段之一，对于简单的爬虫，我们手动填上就好，但如果大批量爬取就需要通过打码平台或者机器学习的方法来识别，当然打码平台廉价易用没有其他学习成本，更值得推荐。

使用网络爬虫做数据采集也应该有所**不为**。爬取过快会给对方的网站服务器造成很大压力，恶意消耗网站服务器资源，在道德层面上应该自我节制，练手的项目爬几页即可，重点是思路的理顺和代码的学习。**总之，爬虫需谨慎，慢点就慢点吧 : ) **

&emsp;

## 4. 写在最后

这两篇文章运用的爬虫知识都十分基础，但提到的两种类型的爬虫却十分常见。进阶操作基本均未涉及，比如易于维护的面向对象编程、提高爬取速度的多线程和多进程、万能爬虫法 Selenium、大型爬虫框架 Scrapy 等。为了尽可能解释清楚，文中也引申了不少无聊的概念，很高兴你能看到最后 。

当然，如果文章能激起你一点点儿想要动手试试的好奇心，实乃荣幸。作为回馈，我也找了几个小项目，适合上手，你可以练一练~

- [豆瓣电影 Top 250](https://movie.douban.com/top250)
- [古诗文网](https://www.gushiwen.cn/)
- [WallHere 电脑桌面壁纸](https://wallhere.com/)
- [百度新闻：海量中文资讯平台](http://news.baidu.com/)
- [51 job：前程无忧](https://www.51job.com/)
- [当当网图书](http://book.dangdang.com/)

万事难开头，「入门」后便是另一番天地。

&emsp;

## 5. 附录：完整 Python 代码

```python
# Author：@初虹
# Date：2021-11-14
# mail: chuhong@mail.sdufe.edu.cn
# 个人公众号：虹鹄山庄

# 导入模块
import requests
from lxml import etree
import time
import random
from fake_useragent import UserAgent
from pandas.core.frame import DataFrame
import pandas as pd

# 伪装 UA
ua = UserAgent(verify_ssl=False)
for i in range(1,500):
    headers = {
        "User-Agent":ua.random,
    }

# 爬取项目URL，并储存到文件中
content_list = []
for page_num in range(0, 44):
    url_page = 'http://cdm.ccchina.org.cn/zyblist.aspx?clmId=164&page={}'.format(page_num)
    resp = requests.get(url=url_page, headers=headers, verify=False)
    html_first = resp.content.decode()
    html1 = etree.HTML(html_first)    
    
    li_list = html1.xpath("//body//li[@class='li']")
    
    for li in li_list:
        item = {}
        item["href"] = "http://cdm.ccchina.org.cn/"+li.xpath(".//a/@href")[0]
        item["title"] = li.xpath(".//a/@title")[0]
        item["pagenum"] = page_num+1
        content_list.append(item)
        dataframe = pd.DataFrame(content_list)
        dataframe.to_csv("./ccer/ccer_url.csv", encoding='gbk')
    time.sleep(random.randint(1 ,2))
    print("第"+str(page_num+1)+"页---")
print("Finished!--------------")

# 定义空列表
beian_num = []
name = []
owner = []
category = []
type = []
method = []
quantity = []
period = []
institution = []
report = []
time1 = []
other = []
item_list = []

# 读取文件中的项目 URL 并遍历
df = pd.read_csv('./ccer/ccer_url.csv',encoding='gbk')
for url_li in df['href'].to_list():
    # 发送请求、获取响应 
    response = requests.get(url_li, headers=headers, verify=False)
    html_second = response.content.decode()
    html2 = etree.HTML(html_second)
    
    # 数据解析（先分组，后提取）
    td_list = html2.xpath("//div[@class='text_main']/div/table/tbody")
    for td in td_list:
        item = {}
        # html.xpath("normalize-space(xpath语法)"") 可以去除\r \n \t
        item["beian_num"]   = td.xpath("normalize-space(./tr[1]/td[2])")
        item["name"]        = td.xpath("normalize-space(./tr[2]/td[2])")
        item["owner"]       = td.xpath("normalize-space(./tr[3]/td[2])")
        item["category"]    = td.xpath("normalize-space(./tr[4]/td[2])")
        item["type"]        = td.xpath("normalize-space(./tr[5]/td[2])")
        item["method"]      = td.xpath("normalize-space(./tr[6]/td[2])")
        item["quantity"]    = td.xpath("normalize-space(./tr[7]/td[2])")
        item["period"]      = td.xpath("normalize-space(./tr[8]/td[2])")
        item["institution"] = td.xpath("normalize-space(./tr[9]/td[2])")
        item["report"]      = td.xpath("normalize-space(./tr[10]/td[2]//span/b/span/a/text())")
        item["time1"]       = td.xpath("normalize-space(./tr[11]/td[2])")
        item["other"]       = td.xpath("normalize-space(./tr[12]/td[2])")
        item_list.append(item)
	 
	 # 持久化存储
        df1 = pd.DataFrame(item_list)
        df1.to_csv("./ccer/ccer_item1.csv", encoding="gb18030")
    # time.sleep(random.randint(1, 3))
    print("第"+str(df['href'].to_list().index(url_li)+1)+"个----")
print("Finished！-------------")
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

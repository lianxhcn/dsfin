
> **作者**：胡煊翊 (南开大学)    
> **邮箱**：<Elizabeth666@yeah.net>  

&emsp;

> **编者按**：本文摘译自下文，特此致谢！  
> **Source**：Cohn J B, Liu Z, Wardlaw M I. Count (and count-like) data in finance[J]. Journal of Financial Economics, 2022, 146(2): 529-551. [-Link-](https://doi.org/10.1016/j.jfineco.2022.08.004)


&emsp;

## 1. 背景介绍

对于计数的非负变量，如企业专利数量、有毒排放吨数、工伤事故数量，以及两家企业所在城市之间的距离，其通常高度右偏，且在 0 处有大量的值。这种分布特征对回归分析提出了挑战，它使得线性回归效率低下，以及置信区间难以确定。为了解决这一问题，学者们通常会取对数，即 $log(y)$。

当 $y$ 取值为 0 时，由于 $log(0)$ 不具有实际意义，学者会采用 $log(y+1)$ 的形式。然而 Cohn 等 (2022) 认为，$log(y+1)$ 作为因变量的回归系数缺乏有意义的解释，并可能导致符号错误，更好的做法是使用泊松回归。

&emsp;

## 2. 偏误原因

假设 $1 + y$ 对协变量回归，在 $x_j$ 上得到的半弹性估计系数为 $λ_j$：

$$
log( 1 + y ) = xλ+φ
$$

我们或许会认为，这种半弹性与 $y$ 对 $x_j$ 的半弹性相同，因为加到 $y$ 上的常数对 $x$ 是不变的。然而，这个猜想忽略了詹森不等式问题。事实上，$log(1+y)$ 得到的回归系数没有任何经济意义的解释：它既不能解释为结果变量的半弹性，也不能从 $log(1+y)$ 的回归系数中推导出 $y$ 与协变量 $x$ 之间的关系。


$$
\begin{aligned}
λ_j &=\frac{1}{E[1 + y | x ]} \frac{∂E[1 + y | x ]}{∂ x_j } \\ 
& = \frac{1}{1 + E[y | x ]} \frac{∂E[ y | x ]}{∂ x_j }        \\
& \neq \frac{1}{E[y | x ]} \frac{∂E[ y | x ]}{∂ x_j} =β_j
\end{aligned}
$$

由于 $E[y|x]$ 是不可观测的，$y$ 的半弹性 $β_j$ 不能从 $λ_j$ 中恢复。当 $E[y|x]$ 很大时，$λ_j ≈β_j$ ， $log(1 +y)$ 的回归系数 $λ_j$ 约等于 $y$ 相对于 $x_j$ 的半弹性。然而，当 $E[y|x]$ 较大时，$y$ 很可能在少数观测值中为零，因此不太可能从一开始就需要添加常数。相反，当 $E[y|x]$ 很小时，$λ_j$ 和 $β_j$ 之间的差异变得很大。

$log(1+y)$ 方法除了会造成估计系数值大小的偏误，还会造成符号的错误。这是因为 $log(1+y)$ 回归会面临两种形式的偏差。

**第一种偏差**来自被解释变量和协变量之间的非线性关系。因变量和一个协变量之间关系的错误设定，会污染其他协变量的估计系数。这个问题在 $log(1+y)$ 回归中是特有的，因为任何 $y$ 的经济模型都会产生 $log(1 + y)$ 和协变量之间的非线性关系。例如，一个模型指定了 $log(y)$ 和 $x_j$ 之间的线性关系，但产生了 $log(1 + y)$ 和 $x_j$ 之间的非线性关系。

具体来看，假设 $log(y) = β_1x_1 +β_2x_2$，$β_1 = 1$，$β_2 = 0$，$x_1$ 均匀分布在 $[−4, 4]$ 上。令 $\varepsilon_1$ 表示 $log(1 + y)$ 对 $x_1$ 做线性回归的误差项，并考虑 $\varepsilon_1$ 对 $x_2$ 的线性回归。根据构造，第二次回归中 $x_2$ 的系数等价于在控制 $x_1$ 的条件下，$log(1 + y)$ 对 $x_2$ 回归的系数。

现在考虑 $x_2$ 的三种情况：(1) $x_2$ 独立于 $x_1$，并在 $[0, 1]$ 上均匀分布；(2) $x_2 = x_1$；(3) $x_2 =x_1^2$。

下图 (c)-(e) 分别为在 (1)、(2) 和 (3) 三种不同情况下，绘制 $\varepsilon_1$ 对 $x_2$ 的曲线以及回归线。在 (c) 和 (d) 中，回归线的斜率都为零。前者是正确的，因为假设 $x_2$ 与 $x_1$ 和 $y$ 都无关。后者也是正确的，因为 $corr(\varepsilon_1, x_2) = corr(\varepsilon_1, x_1) = 0$，这对 $x_2$ 和 $x_1$ 之间的任何线性关系都成立。

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/为什么计数制变量不宜采用形式_胡煊翊_Fig01.png)

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/为什么计数制变量不宜采用形式_胡煊翊_Fig02.png)

图 (c) 表明，当 $x_2 = x_1^2$ 时，$\varepsilon_1$ 与 $x_2$ 呈正相关。当 $x_1$ 较高或较低时，$x_2$ 较大，当 $x_1$ 处于中间值范围时，$x_2$ 较小。因为 $\varepsilon_1$ 在 $x_1$ 较高或较低时也比较大，在 $x_1$ 取中间范围时较小，$\varepsilon_1$ 和 $x_2$ 是间接正相关的。

所以，$x_2$ 上的系数在 $log(1+y)$ 关于 $x_1$ 和 $x_2$ 的回归中是正的，即使假设 $log(1+y)$ 与 $x_2$ 无关。并且，$x_1$ 上的系数也可能是有偏差的。更一般地，两个协变量之间的任何非线性关系，必然会对 $log(1+y)$ 在这些协变量上的回归系数造成偏差。

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/为什么计数制变量不宜采用形式_胡煊翊_Fig03.png)

**第二种偏差**来自无偏估计需要一个关于高阶模型误差矩和协变量之间关系的不合理假设。与 $log(1+y)$ 回归最接近的合理经济模型是恒定弹性模型。假设 $y=exp(xβ)+\varepsilon'$ 是真正的模型，两边加 1 得到 $1+y = exp(xβ)+\varepsilon''$，其中 $\varepsilon''=\varepsilon'+1$。

改写成乘法形式，得到 $1+y = exp(xβ)η''$，其中

$$
η'' = 1+ \frac{\varepsilon''}{exp(xβ)} = 1+ \frac{\varepsilon'}{exp(xβ)} + \frac{1}{exp(xβ)}
$$

显然，不同于对数线性回归，假设 $\varepsilon'$ 可以写成 $\varepsilon'= exp(xβ)ν$，$ν$ 独立于 $x$ 并不能使 $E[log(η'')|x]$ 独立于 $x$，除非所有非常数项的系数都是 0。也就是说，在常弹性模型中，乘法误差中的同方差性不足以对 $log(1 +y)$ 模型进行一致估计。相反，一致估计所需要的是 $\varepsilon'= exp(xβ)ν−1$，这是一种不太可能被任何合理的经济模型所满足的形式。

&emsp;

## 3. 改进方法

Cohn 等 (2022) 提出的改进方法是泊松回归，该方法可以对计数类结果变量做出一致估计。泊松回归假设因变量具有依赖于协变量的泊松分布。密度函数为：

$$f(y|x) = \exp(-\mu(x))\frac{\mu(x)^y}{y!}$$

其中 $\mu(x) = E[y|x] = \exp(x\beta)$。泊松模型中的条件期望形式为 $E[y|x] = \exp(x\beta)$，或等价于 $\log(E[y|x])=x\beta$。

泊松回归估计具有许多理想的特征：

- 泊松回归产生的估计具有有效的半弹性解释，不需要对高阶模型误差矩和协变量之间的关系进行假设，以获得一致的估计。
- 泊松回归施加了结果的条件均值和方差相等的限制。违反这一限制会降低效率，但不会造成任何偏差。
- 泊松回归允许可分离的群体固定效应，即使是具有高维固定效应的泊松模型，也可以快速地估计出来。
- 固定效应泊松回归需要排除所有观察结果变量为零的组。然而，这种排除并不是泊松回归的缺点，因为在固定效应是乘性的回归模型中，这些观察结果不包含关于回归系数的信息。
- 泊松回归即使在结果变量是连续的情况下也会产生有效的估计，它允许一个暴露变量作为结果的缩放变量，并且可以在 IV 回归中使用。

&emsp;

## 4. 代码示例

关于 `ppmlhdfe` 命令的详细介绍，请参考连享会推文「[ZIP-too many Zero：零膨胀泊松回归模型](https://www.lianxh.cn/news/2144066aaa0b4.html)」。

命令安装：

```stata
ssc install ppmlhdfe, replace
```

命令介绍：

```stata
ppmlhdfe depvar [indepvars] [if] [in] [weight] , [absorb(absvars)] [options]
```

- `absorb(absvars)`：要吸收的固定效应；
- `vce(vcetype)`：`vcetype` 可以是 `robust` 或者 `cluster` (允许两个及以上聚类)；
- `exposure(varname)`：包含模型中的 `ln(varname)`，系数约束为 1；
- `offset(varname)`：在模型中包含变量名，系数约束为 1；
- `d(newvar)`：把固定效应合并保存为 **newvar**，如果随后运行 `predict` (`predict, xb` 除外)，则强制执行；
- `d`：和上面一样，但是变量将被保存为 **_ppmlhdfe_d**；
- `separation(string)`：用于删除分离的观察结果及其相关的回归量；
- `eform`：报告指数系数 (发病率比)；
- `irr`：与 `eform` 相同；
- `display_options`：控制回归表的许多选项，如置信度、数字格式等；
- `tolerance(#)`：收敛准则 (默认：1e-8)；
- `guess(string)`：设定初值规则，有效的选项是 `simple` (默认的，几乎总是更快) 和 `ols`；
- `verbose(#)`：调试信息数量，使用 `v(1)` 或更高版本查看其他信息，秘密选项 `v(-1)` 禁用所有消息；
- `[no]log`：隐藏迭代日志；
- `keepsingleton`：不删除单例组；
- `version`：报告 `ppmlhdfe` 的版本号和日期，以及所需包的列表。

命令示例：

```stata
. use http://www.stata-press.com/data/r14/airline, clear 
. * 此时为带有默认稳健标准误的命令
. ppmlhdfe injuries XYZowned

. use "https://www.stata-press.com/data/r16/ships", clear
. * 增加固定效应，指定聚类稳健标准误
. ppmlhdfe accident op_75_79 co_65_69 co_70_74 co_75_79, ///
>     exp(service) irr absorb(ship) vce(cluster ship)

. use "http://fmwww.bc.edu/RePEc/bocode/e/EXAMPLE_TRADE_FTA_DATA" ///
>     if category=="TOTAL", clear
. egen imp = group(isoimp)
. egen exp = group(isoexp)
.  * 三个固定效应层次，分别对应于出口商-进口商、出口商-年度和进口商-年度
. ppmlhdfe trade fta, a(imp#year exp#year imp#exp) cluster(imp#exp)
```

&emsp;

## 5. 相关推文

> Note：产生如下推文列表的 Stata 命令为：   
> &emsp; `lianxh 泊松 对数 reghdfe, m`  
> 安装最新版 `lianxh` 命令：    
> &emsp; `ssc install lianxh, replace` 

- 专题：[回归分析](https://www.lianxh.cn/blogs/32.html)
  - [取对数！取对数？](https://www.lianxh.cn/news/feb8ffdcb6a87.html)
- 专题：[面板数据](https://www.lianxh.cn/blogs/20.html)
  - [Stata：关于reghdfe命令常见问题解答](https://www.lianxh.cn/news/7cf4632cceb9d.html)
  - [引力模型-高维固定效应面板泊松模型](https://www.lianxh.cn/news/9d7249af5b0d3.html)
  - [Stata新命令：ppmlhdfe-面板计数模型-多维固定效应泊松估计](https://www.lianxh.cn/news/c09d27b7de414.html)
  - [reghdfe：多维面板固定效应估计](https://www.lianxh.cn/news/8be6ff429cf93.html)
  - [Stata：reghdfe命令报错问题](https://www.lianxh.cn/news/f59baf0242956.html)
- 专题：[Probit-Logit](https://www.lianxh.cn/blogs/27.html)
  - [ZIP-too many Zero：零膨胀泊松回归模型](https://www.lianxh.cn/news/2144066aaa0b4.html)
- 专题：[其它](https://www.lianxh.cn/blogs/33.html)
  - [Stata：三维引力模型介绍与估计-ppmlhdfe-nbreg-reghdfe](https://www.lianxh.cn/news/2cb2767576554.html)



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

> <font color=red>New！</font> **`lianxh` 和 `songbl` 命令发布了：**    
> 随时搜索连享会推文、Stata 资源，安装命令如下：  
> &emsp; `. ssc install lianxh`  
> 使用详情参见帮助文件 (有惊喜)：   
> &emsp; `. help lianxh`   

![](https://fig-lianxh.oss-cn-shenzhen.aliyuncs.com/Lianxh_装饰黄线.png)
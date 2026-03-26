## 简介

这是中山大学岭南学院金融专硕选修课「金融数据分析与建模」课程的课件仓库，包含了课程讲义的源文件和在线网页内容。课程讲义以 Jupyter Notebook 的形式编写，涵盖了金融数据分析与建模的核心内容，包括数据获取、数据清洗、数据分析、模型构建等方面的知识和技能。

- 课程主页：[lianxhcn.github.io/dsfin](https://lianxhcn.github.io/dsfin/)
- GitHub 仓库：[lianxhcn/dsfin](https://github.com/lianxhcn/dsfin)

阅读本讲义过程中，如果你有任何问题或建议，欢迎在 GitHub 上提交 issue，或者直接联系我（连玉君，<arlionn@163.com>）。我会尽快回复并改进讲义内容。

- 我编写的其他讲义：[连享会 - Books](https://www.lianxh.cn/Books.html)
- 有关数据分析的推文：[连享会 - Blogs](https://www.lianxh.cn)

## 课件使用 

- 课程讲义以在线网页的形式发布在 GitHub Pages 上，网址为 <https://lianxhcn.github.io/dsfin/>。
- 课程讲义的源文件保存在 GitHub 仓库中，网址为 <https://github.com/lianxhcn/dsfin/Lecture>，主要包括：
  - 各讲的 Jupyter Notebook 文件，位于 `Lecture` 文件夹中，以 `Lec_` 开头命名，后缀为 `.ipynb`。
  - 你可以**下载整个仓库**，或者直接下载你感兴趣的讲义文件，然后在本地使用 VS Code 打开和实操。


## 下载本仓库-课件

### 手动下载 

- 点击绿色 **<font color=green><>Code</font>** 按钮，选择 **Download ZIP** 下载本仓库。
- 解压缩后，使用 VS Code 打开文件夹即可。


### 使用 github desktop 下载 (推荐)

对于多数人来说，推荐使用 [GitHub Desktop](https://desktop.github.com/)，详情参见：

  - 杨雪, 2025, [GitHub Desktop 使用方法介绍：可视化 Git 管理的效率工具](https://www.lianxh.cn/details/1672.html).

实操过程中遇到问题，可以问一下 DeepSeek 或豆包。

如果你熟悉 git，可以在 VScode 终端使用 git 命令 Fork 或 clone 本仓库。

## 发布自己的在线讲义

你可以修改本仓库的内容，发布自己的在线讲义。具体步骤如下：

- 在 GitHub 上 Fork 本仓库。
- 在本地使用 GitHub Desktop 或 git 命令将 Fork 后的仓库 clone 到本地。
- 修改内容后，在 VScode 终端执行 `quarto render` 命令生成新的网页内容。
  - 在此之前，你需要安装 [Quarto](https://quarto.org/docs/get-started/)，以及 VScode 的 [Quarto 扩展](https://marketplace.visualstudio.com/items?itemName=quarto.quarto)。
- 使用 GitHub Desktop 或 git 命令将修改后的内容 push 到 GitHub 上。
- 在 GitHub 上打开你的仓库，点击 **Settings**，选择 **Pages**，在 **Source** 处选择 **main branch**，然后点击 **Save**。
- 稍等几分钟后，你的在线讲义就会发布成功，网址为 `https://你的用户名.github.io/dsfin/`。

详情参见：连玉君，2025，[Quarto Book](https://lianxhcn.github.io/quarto_book/)。

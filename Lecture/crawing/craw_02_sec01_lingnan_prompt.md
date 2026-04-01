# 实例-提示词模式：爬取岭南学院教师名录

> *从一个公开页面，提取结构化名录数据，输出 Excel 与 Markdown 两种格式。*

---

## 目标分析：这是一个什么样的页面？

访问 <https://lingnan.sysu.edu.cn/Faculty>，用 DevTools 快速判断：

- `Ctrl+U` 查看源码，点击页面，按快捷键 **Ctrl+F**，在搜索框中填入教师姓名 (如 `毕青苗`)，即可定位到 `毕青苗` 老师的信息块，说明数据直接写在 HTML 中。
- Network 面板无明显 XHR/Fetch 数据请求 → 无需调用 API 接口
- 所有教师在同一个页面，无翻页 → 只需请求一次

这是静态页面爬取的最简单情形：**一次请求 → 解析 HTML → 输出文件**。

---

## 字段设计：爬取什么？

按照第一章「网页观察记录表」的思路，先把分析结论填好，再写提示词：

| 项目 | 内容 |
|------|------|
| 目标网址 | `https://lingnan.sysu.edu.cn/Faculty` |
| 一条记录对应什么 | 一位教师的基本信息 |
| 目标字段清单 | 姓名、职称、教研室、职务、研究方向、电子邮箱、个人主页链接 |
| 是否有分页 | 否，所有教师在同一页面 |
| 是否有详情页 | 有，但目标字段在列表页已完整呈现，无需进入详情页 |
| 数据来源模式 | HTML（模式 A） |
| 关键定位信息 | 见下方 HTML 结构分析 |
| 希望输出格式 | Excel（`.xlsx`）+ Markdown（`.md`） |
| 后续分析目标 | 名录整理，供查阅使用 |

---

## HTML 结构分析：字段在哪里？

用 DevTools 的 Elements 面板检查后，每位教师对应一个 `div.infors` 块。以下是两条真实样例，注意两位教师的结构**略有不同**：

**样例 A（有职务字段）**

```html
<div class="infors">
  <h3>
    <a href="/faculty/LiuGuanchun" target="_blank">刘贯春</a>
    <span>教授</span>
  </h3>
  <p class="one-line">宏观经济教研室</p>
  <p class="one-line">宏观经济教研室主任</p>
  <p class="one-line">liugch9@mail.sysu.edu.cn</p>
  <p class="text-light two-line">
    <b>研究方向:</b>财政与金融、企业投融资决策
  </p>
</div>
```

**样例 B（无职务字段）**

```html
<div class="infors">
  <h3>
    <a href="/faculty/LuoDanglun" target="_blank">罗党论</a>
    <span>教授</span>
  </h3>
  <p class="one-line">公司金融教研室</p>
  <p class="one-line">luodl@mail.sysu.edu.cn</p>
  <p class="text-light two-line">
    <b>研究方向:</b>公司治理与政府治理、资本市场、民营企业
  </p>
</div>
```

字段与 HTML 位置的对应关系：

| 字段 | HTML 位置 | 说明 |
|------|----------|------|
| 姓名 | `h3 > a` 标签文本 | — |
| 职称 | `h3 > span` 标签文本 | 如「教授」「副教授」 |
| 个人主页链接 | `h3 > a` 的 `href` 属性 | 需拼接域名前缀 |
| 教研室 | 第一个 `p.one-line` 文本 | 固定位置，始终存在 |
| 职务 | 第二个 `p.one-line`（若不含 `@`） | 部分教师无此字段 |
| 电子邮箱 | 含 `@` 符号的 `p.one-line` 文本 | 靠内容特征识别 |
| 研究方向 | `p.two-line` 文本，去掉「研究方向:」前缀 | — |

::: {.callout-warning}
## ⚠️ 本例的解析难点

`class="one-line"` 的 `<p>` 标签被同时用于教研室、职务、邮箱三种内容，**没有独立的 class 可以区分**。正确的识别方式是靠文本特征：含 `@` 的是邮箱，第一个出现的是教研室，两者之间若有其他文本则是职务。这是提示词里必须说明的关键细节，否则 AI 生成的选择器大概率会错位。
:::

---

## 提示词

::: {.callout-tip}
### 提示词：爬虫任务描述

 请帮我用 Python 写一个爬虫，完成以下任务。本代码仅用于课堂教学演示。

 **目标网站**：`https://lingnan.sysu.edu.cn/Faculty`，教师名录全部在一个页面内，无需翻页。

 **采集对象**：每一位教师的基本信息，每条记录对应一位教师。

 **数据格式**：数据直接写在 HTML 中（模式 A）。以下是两条真实 HTML 样例，注意两者结构不同——刘贯春有职务字段，罗党论没有：

 ```html
 <!-- 样例 A：有职务 -->
 <div class="infors">
   <h3>
     <a href="/faculty/LiuGuanchun" target="_blank">刘贯春</a>
     <span>教授</span>
   </h3>
   <p class="one-line">宏观经济教研室</p>
   <p class="one-line">宏观经济教研室主任</p>
   <p class="one-line">liugch9@mail.sysu.edu.cn</p>
   <p class="text-light two-line">
     <b>研究方向:</b>财政与金融、企业投融资决策
   </p>
 </div>
 ```

 ```html
 <!-- 样例 B：无职务 -->
 <div class="infors">
   <h3>
     <a href="/faculty/LuoDanglun" target="_blank">罗党论</a>
     <span>教授</span>
   </h3>
   <p class="one-line">公司金融教研室</p>
   <p class="one-line">luodl@mail.sysu.edu.cn</p>
   <p class="text-light two-line">
     <b>研究方向:</b>公司治理与政府治理、资本市场、民营企业
   </p>
 </div>
 ```

 **字段识别规则**（请严格按此逻辑解析）：

 - `h3 > a` 文本为**姓名**；`href` 属性拼接 `https://lingnan.sysu.edu.cn` 后为**个人主页链接**
 - `h3 > span` 文本为**职称**
 - `class="one-line"` 的 `<p>` 标签按顺序处理：第一个文本为**教研室**；之后若存在不含 `@` 的文本则为**职务**；含 `@` 的文本为**电子邮箱**
 - `class` 包含 `two-line` 的 `<p>` 标签内容去掉「研究方向:」前缀后为**研究方向**
 - 某字段不存在时填入空字符串，不跳过整条记录

 **需要提取的字段**（共 7 个，按此顺序）：

 `姓名`、`职称`、`教研室`、`职务`、`研究方向`、`电子邮箱`、`个人主页链接`

 **技术要求**：

 - 使用 `requests` + `BeautifulSoup`
 - `User-Agent` 设置为真实 Chrome 浏览器值
 - 请求失败时打印错误信息并终止，不静默失败
 - 将解析单条教师信息的逻辑封装为函数 `parse_faculty(card)`

 **输出**：

 - 一份 Excel 文件，命名为 `lingnan_faculty.xlsx`，中文字段名
 - 一份 Markdown 文件，命名为 `lingnan_faculty.md`，每位教师用列表格式呈现，邮箱和链接用尖括号包裹（可点击），格式如下：

 ```markdown
 - **刘贯春**｜教授
   - 教研室：宏观经济教研室
   - 职务：宏观经济教研室主任
   - 研究方向：财政与金融、企业投融资决策
   - 邮箱：<liugch9@mail.sysu.edu.cn>
   - 主页：<https://lingnan.sysu.edu.cn/faculty/LiuGuanchun>
 ```

 **代码要求**：加中文注释；先只打印前 3 条结果，确认字段正确后再保存完整文件。

**提示词要点分析：**

- ✅ **粘贴了真实 HTML 样例**，且样例刻意覆盖两种结构（有/无职务），AI 能据此处理边界情况
- ✅ **明确了字段识别规则**，尤其是 `class="one-line"` 复用问题——这是本例最容易出错的地方
- ✅ **指定了输出格式的具体样式**，包括 Markdown 尖括号写法，AI 不需要猜
- ✅ **要求先打印 3 条再保存**，对应「先验证、再输出」的实践习惯
- ✅ **封装为函数**，代码结构清晰，便于后续修改单条解析逻辑
  
:::


---

## 代码

```python
import requests
from bs4 import BeautifulSoup
import pandas as pd

# ── 请求头：模拟真实浏览器，避免被服务器拒绝 ──
HEADERS = {
    'User-Agent': (
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/120.0.0.0 Safari/537.36'
    )
}

BASE_URL = 'https://lingnan.sysu.edu.cn'
LIST_URL = f'{BASE_URL}/Faculty'


def parse_faculty(card) -> dict:
    """
    解析单个教师信息块（div.infors），返回包含 7 个字段的字典。
    字段缺失时填入空字符串，不抛出异常。
    """
    result = {
        '姓名': '', '职称': '', '教研室': '',
        '职务': '', '研究方向': '', '电子邮箱': '', '个人主页链接': ''
    }

    # 姓名 + 个人主页链接
    h3 = card.find('h3')
    if h3:
        a_tag = h3.find('a')
        if a_tag:
            result['姓名'] = a_tag.get_text(strip=True)
            href = a_tag.get('href', '')
            result['个人主页链接'] = BASE_URL + href if href else ''

        # 职称
        span = h3.find('span')
        if span:
            result['职称'] = span.get_text(strip=True)

    # 逐一处理 class="one-line" 的 <p> 标签
    one_lines = card.find_all('p', class_='one-line')
    for i, p in enumerate(one_lines):
        text = p.get_text(strip=True)
        if i == 0:
            # 第一个固定是教研室
            result['教研室'] = text
        elif '@' in text:
            # 含 @ 的是邮箱
            result['电子邮箱'] = text
        else:
            # 其余不含 @ 的文本是职务
            result['职务'] = text

    # 研究方向：去掉 <b> 标签里的「研究方向:」前缀
    two_line = card.find('p', class_='two-line')
    if two_line:
        raw = two_line.get_text(strip=True)
        result['研究方向'] = raw.replace('研究方向:', '').strip()

    return result


def main():
    # ── Step 1：请求页面 ──
    print(f'正在请求：{LIST_URL}')
    resp = requests.get(LIST_URL, headers=HEADERS, timeout=15)
    if resp.status_code != 200:
        print(f'请求失败，状态码：{resp.status_code}')
        return
    resp.encoding = 'utf-8'

    # ── Step 2：解析 HTML，定位所有教师信息块 ──
    soup = BeautifulSoup(resp.text, 'html.parser')
    cards = soup.find_all('div', class_='infors')
    print(f'共找到 {len(cards)} 位教师')

    # ── Step 3：先只解析前 3 条，验证字段是否正确 ──
    print('\n【前 3 条预览】')
    for card in cards[:3]:
        info = parse_faculty(card)
        for k, v in info.items():
            print(f'  {k}：{v}')
        print()

    # ── Step 4：确认字段无误后，解析全部教师 ──
    all_faculty = [parse_faculty(card) for card in cards]

    # ── Step 5：输出 Excel ──
    df = pd.DataFrame(all_faculty)
    excel_path = 'lingnan_faculty.xlsx'
    df.to_excel(excel_path, index=False)
    print(f'✅ Excel 已保存：{excel_path}（共 {len(df)} 条记录）')

    # ── Step 6：输出 Markdown（列表格式，邮箱和链接用尖括号包裹）──
    md_lines = ['# 中山大学岭南学院教师名录\n']
    for row in all_faculty:
        # 第一行：姓名｜职称
        md_lines.append(f"- **{row['姓名']}**｜{row['职称']}")
        # 有值才输出，避免空行
        if row['教研室']:
            md_lines.append(f"  - 教研室：{row['教研室']}")
        if row['职务']:
            md_lines.append(f"  - 职务：{row['职务']}")
        if row['研究方向']:
            md_lines.append(f"  - 研究方向：{row['研究方向']}")
        if row['电子邮箱']:
            md_lines.append(f"  - 邮箱：<{row['电子邮箱']}>")
        if row['个人主页链接']:
            md_lines.append(f"  - 主页：<{row['个人主页链接']}>")
        md_lines.append('')  # 教师间空一行

    md_path = 'lingnan_faculty.md'
    with open(md_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(md_lines))
    print(f'✅ Markdown 已保存：{md_path}')

if __name__ == '__main__':
    main()
```

---

## 爬完之后先检查，再保存

第一章强调：**「运行成功」≠「任务完成」**。对于名录类数据，重点检查以下四项：

```python
# 爬取完成后，运行以下检查代码

print("【1. 数据量】")
print(f"  共 {len(df)} 条记录")

print("\n【2. 字段完整性】")
print(df.isnull().sum())          # 查看各字段空值数量

print("\n【3. 字段内容抽查】")
print(df[['姓名', '职称', '电子邮箱']].head(10).to_string())

print("\n【4. 异常值检查】")
# 邮箱列不应出现人名，姓名列不应出现 @
bad_email = df[~df['电子邮箱'].str.contains('@', na=False) & df['电子邮箱'].ne('')]
print(f"  格式异常的邮箱：{len(bad_email)} 条")
print(f"  无邮箱记录：{df['电子邮箱'].eq('').sum()} 条")
print(f"  无职务记录：{df['职务'].eq('').sum()} 条（正常，非所有教师都有行政职务）")
```

::: {.callout-note}
## 💡 「无职务」不是错误

本例中大多数教师没有行政职务，`职务` 字段为空是正常现象，不需要修复。检查的目的是区分「正常缺失」和「解析错位」——如果发现邮箱列出现了人名，才说明 `one-line` 的解析逻辑有问题，需要回头修改 `parse_faculty()` 函数。
:::

---

## 课堂讨论

1. 本例的 `class="one-line"` 被用于三种不同字段，靠文本内容特征来区分。这种网页设计有什么问题？如果网站改版，增加了一种新的 `one-line` 内容，你的爬虫会在哪里出错？
2. Markdown 的尖括号写法（`<email>`）在不同平台的渲染效果可能不同。如果要确保在 GitHub、Typora、Notion 中都能正常显示可点击链接，分别应该用什么格式？
3. 本例没有设置请求间隔，因为只请求一次。如果改成爬取每位教师的**详情页**，你需要在提示词里加哪些内容？

## Round 1
图文并茂地介绍一下 Parquet，提供一些基本的 Python 代码实例，说明它的优点和适用场景。

我的很多学生 (金融硕士，数字经济专硕) 要么已经在银行、券商、投行、阿里等公司工作，要么即将去这些公司工作。他们将要进行的数据分析工作中的数据对象肯定不是简单的 .csv 表格，而是多个分散在不同文件夹甚至是不同服务器上的文件。

他们需要了解哪些实用的数据格式和工具，才能高效地进行数据分析工作？Parquet 和 SQLite 是两个非常重要的工具。请帮我介绍一下它们的基本概念、优缺点、适用场景，并提供一些 Python 代码示例，说明如何使用它们进行数据存储和查询。

---

```python
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq

df = pd.DataFrame({
    "id": [1,2,3],
    "name": ["Alice","Bob","Charlie"],
    "age": [25,30,35]
})

# 写入 Parquet（Snappy压缩）
pq.write_table(pa.Table.from_pandas(df), "data.parquet", compression="snappy")

# 读取（只读2列，高效）
df_read = pq.read_table("data.parquet", columns=["name","age"]).to_pandas()
```


## Round 2

这是不是意味着，我如果有一份 200M 的上市公司的财务资料 fin_ratios.csv ，我可以现在本地将其存为 Parquet 格式，然后再分享或发布到 github 仓库，同时提供解压/转换为 .csv 的命令。

用户使用时，只需执行这些命令就可以转换为 .csv 文件。

如果他熟悉 Parquet 格式，可以直接基于 Parquet 格式进行分析。
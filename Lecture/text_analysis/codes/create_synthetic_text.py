"""
create_synthetic_text.py
======================
为「金融文本分析」两章生成全部虚构文本素材。

运行方式:
    python codes/create_synthetic_text.py

输出目录结构:
    data_raw/
    ├── announcements/          # 50 条借贷公告 .txt + metadata.csv
    │   ├── 000001_2023_01.txt
    │   ├── 000001_2023_02.txt
    │   ├── ...
    │   └── metadata.csv
    ├── news/
    │   └── news_samples.csv    # 6 条财经新闻（标题+正文+标签）
    ├── pboc_reports/            # 4 段央行货币政策执行报告片段
    │   ├── pboc_2020Q1.txt
    │   ├── pboc_2017Q4.txt
    │   ├── pboc_2023Q4.txt
    │   └── pboc_2022Q2.txt
    ├── mda/                    # 3 段年报 MD&A 片段
    │   ├── mda_招商银行_2023.txt
    │   ├── mda_中兴通讯_2023.txt
    │   └── mda_万科A_2023.txt
    ├── inquiry_letters/        # 3 段交易所问询函片段
    │   ├── inquiry_营收确认.txt
    │   ├── inquiry_商誉减值.txt
    │   └── inquiry_关联交易.txt
    └── analyst_reports/        # 3 条分析师研报摘要
        ├── report_宁德时代_买入.txt
        ├── report_中兴通讯_中性.txt
        └── report_万科A_减持.txt

设计原则（与 create_sample_data.ipynb 一致）:
- 刻意植入特定问题和变体，用于教学演示
- 每条素材都标注了设计意图和教学用途
- 生成逻辑完全确定性（固定随机种子），确保可复现
"""

import os
import random
import csv
import json
from datetime import datetime, timedelta

# ── 固定随机种子，确保每次运行结果一致 ──────────────────────
random.seed(42)


# ============================================================
# 辅助函数
# ============================================================

def ensure_dir(path):
    """创建目录（如已存在则跳过）"""
    os.makedirs(path, exist_ok=True)


def write_text(filepath, content):
    """写入文本文件（UTF-8 编码）"""
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)


def write_csv(filepath, rows, fieldnames):
    """写入 CSV 文件"""
    with open(filepath, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


# ============================================================
# 第一部分：借贷公告（50 条）
# ============================================================
#
# 生成逻辑：
#   - 8 条"种子公告"（即前面虚构的素材①）作为基础模板
#   - 其余 42 条通过参数化变体扩展：
#     随机组合不同的公司、银行、金额、利率、期限、日期，
#     并按比例植入各类问题（HTML 噪音、全角字符、浮动利率等）
#
# 变体比例设计（50 条中）：
#   - ~10%（5 条）含 HTML 标签噪音
#   - ~10%（5 条）含全角字符
#   - ~14%（7 条）为 LPR 浮动利率
#   - ~10%（5 条）一文多笔
#   - ~6% （3 条）精确重复（爬虫重复抓取）
#   - ~8% （4 条）信息不完整（利率或期限未确定）
#   - 其余为标准格式（表述方式随机变化）

# ── 参数池 ─────────────────────────────────────────────────

COMPANIES = [
    {"stkcd": "000001", "name": "平安银行"},
    {"stkcd": "000002", "name": "万科A"},
    {"stkcd": "000063", "name": "中兴通讯"},
    {"stkcd": "600028", "name": "中国石化"},
    {"stkcd": "600036", "name": "招商银行"},
    {"stkcd": "600519", "name": "贵州茅台"},
    {"stkcd": "601318", "name": "中国平安"},
    {"stkcd": "000858", "name": "五粮液"},
    {"stkcd": "002415", "name": "海康威视"},
    {"stkcd": "300750", "name": "宁德时代"},
]

BANKS = [
    {"full": "中国工商银行股份有限公司", "short": "工行", "standard": "工商银行"},
    {"full": "中国建设银行股份有限公司", "short": "建行", "standard": "建设银行"},
    {"full": "中国农业银行股份有限公司", "short": "农行", "standard": "农业银行"},
    {"full": "中国银行股份有限公司",     "short": "中行", "standard": "中国银行"},
    {"full": "交通银行股份有限公司",     "short": "交行", "standard": "交通银行"},
    {"full": "招商银行股份有限公司",     "short": "招行", "standard": "招商银行"},
    {"full": "中信银行股份有限公司",     "short": "中信", "standard": "中信银行"},
    {"full": "兴业银行股份有限公司",     "short": "兴业", "standard": "兴业银行"},
    {"full": "浦发银行股份有限公司",     "short": "浦发", "standard": "浦发银行"},
    {"full": "中国民生银行股份有限公司", "short": "民生", "standard": "民生银行"},
]

BRANCHES = [
    {"suffix": "总行",             "level": "总行"},
    {"suffix": "总行营业部",       "level": "总行"},
    {"suffix": "北京市分行",       "level": "省级分行"},
    {"suffix": "上海市分行",       "level": "省级分行"},
    {"suffix": "广东省分行",       "level": "省级分行"},
    {"suffix": "浙江省分行",       "level": "省级分行"},
    {"suffix": "深圳市分行",       "level": "地级分行"},
    {"suffix": "杭州分行",         "level": "地级分行"},
    {"suffix": "南京分行",         "level": "地级分行"},
    {"suffix": "珠海分行",         "level": "地级分行"},
]

# 金额池（数值, 单位）——刻意混用亿元和万元
AMOUNTS = [
    (1.0,     "亿元"),
    (1.5,     "亿元"),
    (2.0,     "亿元"),
    (3.0,     "亿元"),
    (5.0,     "亿元"),
    (8.0,     "亿元"),
    (10.0,    "亿元"),
    (3000.0,  "万元"),
    (5000.0,  "万元"),
    (8000.0,  "万元"),
    (10000.0, "万元"),
    (15000.0, "万元"),
    (20000.0, "万元"),
    (30000.0, "万元"),
]

# 固定利率池（%）
RATES = [3.45, 3.65, 3.85, 4.00, 4.10, 4.20, 4.35, 4.50, 4.60, 4.75, 4.90, 5.10]

# 浮动利率表述池
FLOAT_RATES = [
    "一年期贷款市场报价利率（LPR）加50个基点",
    "一年期贷款市场报价利率（LPR）加80个基点",
    "一年期LPR加100个基点",
    "五年期LPR加60个基点",
    "一年期LPR减10个基点",
    "同期LPR加65个基点",
    "一年期贷款市场报价利率（LPR）上浮15%",
]

# 期限池（数值, 单位）
TERMS = [
    (1,  "年"),
    (2,  "年"),
    (3,  "年"),
    (5,  "年"),
    (6,  "个月"),
    (12, "个月"),
    (18, "个月"),
    (24, "个月"),
    (36, "个月"),
]


# ── 公告文本模板 ───────────────────────────────────────────

def random_date(year):
    """在指定年份内随机生成一个日期"""
    start = datetime(year, 1, 1)
    end = datetime(year, 12, 28)
    delta = (end - start).days
    d = start + timedelta(days=random.randint(0, delta))
    return d.strftime("%Y年%m月%d日").replace("年0", "年").replace("月0", "月")


def format_date_clean(year):
    """生成干净格式的日期字符串"""
    return random_date(year)


def make_bank_name(bank, branch, style="full"):
    """
    生成银行名称字符串。
    style: "full"  → 中国建设银行股份有限公司深圳市分行
           "short" → 建行深圳分行（简称 + 分行后缀简写）
           "mixed" → 建设银行深圳市分行（标准名 + 分行后缀）
    """
    if branch["level"] == "总行":
        if style == "full":
            return bank["full"].replace("股份有限公司", "") + branch["suffix"]
        elif style == "short":
            return bank["short"] + branch["suffix"]
        else:
            return bank["standard"] + branch["suffix"]
    else:
        if style == "full":
            return bank["full"] + branch["suffix"]
        elif style == "short":
            return bank["short"] + branch["suffix"].replace("市分行", "分行").replace("省分行", "分行")
        else:
            return bank["standard"] + branch["suffix"]


def gen_standard_announcement(company, year, bank, branch,
                               amount, amount_unit, rate, term, term_unit,
                               bank_style="full", verb_loan="贷款", verb_rate="利率为年化"):
    """
    生成标准格式的借贷公告文本。
    通过参数控制表述变体（贷款/借款、利率为年化/年息 等）。
    """
    date_str = random_date(year)
    bank_name = make_bank_name(bank, branch, style=bank_style)

    # 金额表述变体
    if amount_unit == "亿元":
        amount_str = f"{amount:.0f}亿元" if amount == int(amount) else f"{amount}亿元"
    else:
        amount_str = f"{int(amount)}万元"

    # 利率表述变体
    rate_str = f"{verb_rate}{rate:.2f}%"

    # 期限表述变体
    term_str = f"{int(term)}{term_unit}"

    # 组合文本（随机选择句式模板）
    templates = [
        f"本公司于{date_str}，与{bank_name}签署{verb_loan}协议，"
        f"{verb_loan}金额为{amount_str}，期限{term_str}，{rate_str}。",

        f"本公司于{date_str}与{bank_name}签订{verb_loan}合同，"
        f"{verb_loan}金额{amount_str}，{verb_loan}期限{term_str}，{rate_str}。",

        f"{date_str}，本公司与{bank_name}签署流动资金{verb_loan}协议。"
        f"{verb_loan}金额人民币{amount_str}，期限{term_str}，{rate_str}。",

        f"根据经营资金需要，本公司于{date_str}向{bank_name}申请{verb_loan}，"
        f"金额为人民币{amount_str}，期限{term_str}，{rate_str}。"
        f"上述{verb_loan}事项已经公司董事会审议通过。",
    ]
    return random.choice(templates)


def gen_float_rate_announcement(company, year, bank, branch,
                                 amount, amount_unit, float_rate_expr, term, term_unit):
    """生成浮动利率公告（正则无法直接提取利率数值）"""
    date_str = random_date(year)
    bank_name = make_bank_name(bank, branch, style=random.choice(["full", "mixed"]))

    if amount_unit == "亿元":
        amount_str = f"人民币{amount:.0f}亿元整" if amount == int(amount) else f"人民币{amount}亿元"
    else:
        amount_str = f"人民币{int(amount)}万元"

    term_str = f"{int(term)}{term_unit}"

    return (
        f"{date_str}，本公司与{bank_name}签署流动资金贷款协议。"
        f"贷款金额{amount_str}，期限{term_str}，"
        f"执行利率为{float_rate_expr}。"
    )


def gen_incomplete_announcement(company, year, bank, branch, amount, amount_unit, term, term_unit):
    """生成信息不完整的公告（利率未确定）"""
    date_str = random_date(year)
    bank_name = make_bank_name(bank, branch, style=random.choice(["full", "mixed"]))

    if amount_unit == "亿元":
        amount_str = f"人民币{amount:.0f}亿元" if amount == int(amount) else f"人民币{amount}亿元"
    else:
        amount_str = f"人民币{int(amount)}万元"

    term_str = f"{int(term)}{term_unit}"

    endings = [
        "具体贷款利率将根据届时市场情况另行确定。",
        "贷款利率按双方另行签署的具体借款合同约定执行。",
        "利率将参照届时中国人民银行公布的同期贷款基准利率确定。",
        "实际执行利率以提款日当日的市场报价为准。",
    ]

    return (
        f"本公司于{date_str}与{bank_name}签署综合授信协议，"
        f"获得授信额度{amount_str}，期限{term_str}。"
        f"{random.choice(endings)}"
    )


def gen_multi_loan_announcement(company, year):
    """生成一条公告含两笔贷款"""
    date_str = random_date(year)

    bank1 = random.choice(BANKS)
    bank2 = random.choice([b for b in BANKS if b != bank1])
    branch1 = random.choice(BRANCHES)
    branch2 = random.choice(BRANCHES)

    a1, u1 = random.choice(AMOUNTS[:7])   # 选亿元级别
    a2, u2 = random.choice(AMOUNTS[:7])
    r1 = random.choice(RATES)
    r2 = random.choice(RATES)
    t1, tu1 = random.choice(TERMS[:4])    # 选年为单位
    t2, tu2 = random.choice(TERMS[:4])

    bn1 = make_bank_name(bank1, branch1, style=random.choice(["full", "mixed"]))
    bn2 = make_bank_name(bank2, branch2, style=random.choice(["full", "mixed"]))

    a1_str = f"{a1:.0f}亿元" if a1 == int(a1) else f"{a1}亿元"
    a2_str = f"{a2:.0f}亿元" if a2 == int(a2) else f"{a2}亿元"

    return (
        f"{company['name']}于{date_str}分别与两家银行签署贷款协议："
        f"（1）与{bn1}签署贷款协议，"
        f"金额{a1_str}，期限{int(t1)}年，利率年化{r1:.2f}%；"
        f"（2）与{bn2}签署贷款协议，"
        f"金额{a2_str}，期限{int(t2)}年，利率年化{r2:.2f}%。"
    )


def add_html_noise(text):
    """为文本添加 HTML 标签噪音"""
    text = f"<p>{text}</p>"
    # 随机给金额加粗标签
    import re
    text = re.sub(r'(\d+(?:\.\d+)?(?:万元|亿元))', r'<b>\1</b>', text, count=1)
    return text


def to_fullwidth(text):
    """将文本中的 ASCII 数字和部分标点转为全角字符"""
    result = []
    for ch in text:
        code = ord(ch)
        # 数字 0-9 和小数点转全角
        if 0x30 <= code <= 0x39 or ch == '.':
            result.append(chr(code + 0xFEE0))
        else:
            result.append(ch)
    return result
    # 注意：这里只转换数字和小数点，保留中文字符不变


def to_fullwidth_text(text):
    """将文本中的数字转为全角"""
    result = []
    for ch in text:
        code = ord(ch)
        if 0x30 <= code <= 0x39:        # ASCII 数字
            result.append(chr(code + 0xFEE0))
        elif ch == '.':
            result.append('．')
        else:
            result.append(ch)
    return ''.join(result)


def generate_announcements(output_dir):
    """
    生成 50 条借贷公告，保存为单独的 .txt 文件 + metadata.csv。

    变体分配：
      公告 01-08: 种子模板（与素材①完全一致）
      公告 09-13: HTML 噪音（5 条）
      公告 14-18: 全角字符（5 条）
      公告 19-25: LPR 浮动利率（7 条）
      公告 26-30: 一文多笔（5 条）
      公告 31-34: 信息不完整（4 条）
      公告 35-47: 标准格式随机变体（13 条）
      公告 48-50: 精确重复（从前面随机选 3 条复制）
    """
    ensure_dir(output_dir)
    metadata = []
    texts = []  # (filename, text, stkcd, year, variant_type)

    # ────────────────────────────────────────────────────
    # 种子公告 01-08（与素材①完全一致）
    # ────────────────────────────────────────────────────

    seed_announcements = [
        # 公告 01: 标准格式（基准样本）
        {
            "stkcd": "000001", "year": 2023, "variant": "standard_seed",
            "text": (
                "本公司于2023年6月1日，与中国建设银行股份有限公司深圳市分行签署贷款协议，"
                "贷款金额为2亿元，期限3年，利率为年化4.20%。"
            ),
        },
        # 公告 02: 利率表述变体 + 银行简称
        {
            "stkcd": "000001", "year": 2023, "variant": "wording_variant",
            "text": (
                "本公司于2023年8月15日与工行广东省分行签订借款合同，"
                "借款金额15000万元，借款期限5年，年息4.50%。"
            ),
        },
        # 公告 03: LPR 浮动利率
        {
            "stkcd": "000002", "year": 2022, "variant": "float_rate_seed",
            "text": (
                "2022年3月10日，本公司与中国银行总行签署流动资金贷款协议。"
                "贷款金额人民币5亿元整，期限36个月，"
                "执行利率为一年期贷款市场报价利率（LPR）加80个基点。"
            ),
        },
        # 公告 04: 含 HTML 标签和全角字符
        {
            "stkcd": "000063", "year": 2023, "variant": "html_fullwidth_seed",
            "text": (
                "<p>本公司于２０２３年１１月２０日与中国农业银行股份有限公司珠海分行签署"
                "贷款合同，贷款金额为人民币<b>8000万元</b>，贷款期限为２年，"
                "贷款年利率为４.６０%。</p>"
            ),
        },
        # 公告 05: 期限用"月"表示
        {
            "stkcd": "600028", "year": 2023, "variant": "term_month_seed",
            "text": (
                "中国石化于2023年9月5日与交通银行股份有限公司上海市分行"
                "签订借款合同。本次借款金额为20000万元，借款期限18个月，"
                "利率为年化3.85%。"
            ),
        },
        # 公告 06: 信息不完整（利率未确定）
        {
            "stkcd": "600036", "year": 2022, "variant": "incomplete_seed",
            "text": (
                "本公司于2022年12月8日与招商银行总行营业部签署综合授信协议，"
                "获得授信额度人民币10亿元，期限2年。"
                "具体贷款利率将根据届时市场情况另行确定。"
            ),
        },
        # 公告 07: 一条公告含两笔贷款
        {
            "stkcd": "000002", "year": 2023, "variant": "multi_loan_seed",
            "text": (
                "万科企业股份有限公司于2023年4月分别与两家银行签署贷款协议："
                "（1）与中国建设银行股份有限公司深圳市分行签署贷款协议，"
                "金额3亿元，期限5年，利率年化4.10%；"
                "（2）与中信银行股份有限公司深圳分行签署贷款协议，"
                "金额2亿元，期限3年，利率年化4.35%。"
            ),
        },
        # 公告 08: 与公告 01 精确重复
        {
            "stkcd": "000001", "year": 2023, "variant": "exact_duplicate_seed",
            "text": (
                "本公司于2023年6月1日，与中国建设银行股份有限公司深圳市分行签署贷款协议，"
                "贷款金额为2亿元，期限3年，利率为年化4.20%。"
            ),
        },
    ]

    for i, seed in enumerate(seed_announcements, start=1):
        filename = f"{seed['stkcd']}_{seed['year']}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), seed["text"])
        texts.append((filename, seed["text"], seed["stkcd"], seed["year"], seed["variant"]))

    # ────────────────────────────────────────────────────
    # 公告 09-13: HTML 噪音（5 条）
    # ────────────────────────────────────────────────────

    for i in range(9, 14):
        comp = random.choice(COMPANIES)
        year = random.choice([2022, 2023])
        bank = random.choice(BANKS)
        branch = random.choice(BRANCHES)
        amount, unit = random.choice(AMOUNTS)
        rate = random.choice(RATES)
        term, term_unit = random.choice(TERMS)

        text = gen_standard_announcement(
            comp, year, bank, branch, amount, unit, rate, term, term_unit,
            bank_style=random.choice(["full", "mixed"]),
            verb_loan=random.choice(["贷款", "借款"]),
            verb_rate=random.choice(["利率为年化", "年息", "贷款年利率为"]),
        )
        text = add_html_noise(text)

        filename = f"{comp['stkcd']}_{year}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), text)
        texts.append((filename, text, comp["stkcd"], year, "html_noise"))

    # ────────────────────────────────────────────────────
    # 公告 14-18: 全角字符（5 条）
    # ────────────────────────────────────────────────────

    for i in range(14, 19):
        comp = random.choice(COMPANIES)
        year = random.choice([2022, 2023])
        bank = random.choice(BANKS)
        branch = random.choice(BRANCHES)
        amount, unit = random.choice(AMOUNTS)
        rate = random.choice(RATES)
        term, term_unit = random.choice(TERMS)

        text = gen_standard_announcement(
            comp, year, bank, branch, amount, unit, rate, term, term_unit,
            bank_style="full",
            verb_loan="贷款",
            verb_rate="贷款年利率为",
        )
        text = to_fullwidth_text(text)

        filename = f"{comp['stkcd']}_{year}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), text)
        texts.append((filename, text, comp["stkcd"], year, "fullwidth"))

    # ────────────────────────────────────────────────────
    # 公告 19-25: LPR 浮动利率（7 条）
    # ────────────────────────────────────────────────────

    for i in range(19, 26):
        comp = random.choice(COMPANIES)
        year = random.choice([2022, 2023])
        bank = random.choice(BANKS)
        branch = random.choice(BRANCHES)
        amount, unit = random.choice(AMOUNTS)
        float_expr = random.choice(FLOAT_RATES)
        term, term_unit = random.choice(TERMS)

        text = gen_float_rate_announcement(
            comp, year, bank, branch, amount, unit, float_expr, term, term_unit
        )

        filename = f"{comp['stkcd']}_{year}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), text)
        texts.append((filename, text, comp["stkcd"], year, "float_rate"))

    # ────────────────────────────────────────────────────
    # 公告 26-30: 一文多笔（5 条）
    # ────────────────────────────────────────────────────

    for i in range(26, 31):
        comp = random.choice(COMPANIES)
        year = random.choice([2022, 2023])

        text = gen_multi_loan_announcement(comp, year)

        filename = f"{comp['stkcd']}_{year}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), text)
        texts.append((filename, text, comp["stkcd"], year, "multi_loan"))

    # ────────────────────────────────────────────────────
    # 公告 31-34: 信息不完整（4 条）
    # ────────────────────────────────────────────────────

    for i in range(31, 35):
        comp = random.choice(COMPANIES)
        year = random.choice([2022, 2023])
        bank = random.choice(BANKS)
        branch = random.choice(BRANCHES)
        amount, unit = random.choice(AMOUNTS)
        term, term_unit = random.choice(TERMS)

        text = gen_incomplete_announcement(
            comp, year, bank, branch, amount, unit, term, term_unit
        )

        filename = f"{comp['stkcd']}_{year}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), text)
        texts.append((filename, text, comp["stkcd"], year, "incomplete"))

    # ────────────────────────────────────────────────────
    # 公告 35-47: 标准格式随机变体（13 条）
    # ────────────────────────────────────────────────────

    for i in range(35, 48):
        comp = random.choice(COMPANIES)
        year = random.choice([2022, 2023])
        bank = random.choice(BANKS)
        branch = random.choice(BRANCHES)
        amount, unit = random.choice(AMOUNTS)
        rate = random.choice(RATES)
        term, term_unit = random.choice(TERMS)

        text = gen_standard_announcement(
            comp, year, bank, branch, amount, unit, rate, term, term_unit,
            bank_style=random.choice(["full", "short", "mixed"]),
            verb_loan=random.choice(["贷款", "借款"]),
            verb_rate=random.choice(["利率为年化", "年息", "利率为", "贷款年利率为"]),
        )

        filename = f"{comp['stkcd']}_{year}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), text)
        texts.append((filename, text, comp["stkcd"], year, "standard_random"))

    # ────────────────────────────────────────────────────
    # 公告 48-50: 精确重复（从标准变体中随机选 3 条复制）
    # ────────────────────────────────────────────────────

    # 从公告 35-47 中随机选 3 条作为重复来源
    source_indices = random.sample(range(34, 47), 3)  # texts 列表的索引（0-based）
    for j, i in enumerate(range(48, 51)):
        src = texts[source_indices[j]]
        filename = f"{src[2]}_{src[3]}_{i:02d}.txt"
        write_text(os.path.join(output_dir, filename), src[1])  # 文本完全相同
        texts.append((filename, src[1], src[2], src[3], "exact_duplicate"))

    # ────────────────────────────────────────────────────
    # 输出 metadata.csv
    # ────────────────────────────────────────────────────

    fieldnames = ["seq", "filename", "stkcd", "year", "variant_type", "note"]
    variant_notes = {
        "standard_seed":          "种子模板-标准格式",
        "wording_variant":        "种子模板-表述变体(年息/借款/简称)",
        "float_rate_seed":        "种子模板-LPR浮动利率",
        "html_fullwidth_seed":    "种子模板-HTML标签+全角字符",
        "term_month_seed":        "种子模板-期限用月表示",
        "incomplete_seed":        "种子模板-利率未确定",
        "multi_loan_seed":        "种子模板-一文多笔",
        "exact_duplicate_seed":   "种子模板-精确重复(与公告01相同)",
        "html_noise":             "HTML标签噪音(需清洗)",
        "fullwidth":              "全角字符(需转半角)",
        "float_rate":             "LPR浮动利率(正则无法提取)",
        "multi_loan":             "一条公告含两笔贷款",
        "incomplete":             "利率或期限信息缺失",
        "standard_random":        "标准格式-随机表述变体",
        "exact_duplicate":        "精确重复(模拟爬虫重复抓取)",
    }

    rows = []
    for idx, (fn, txt, stkcd, year, variant) in enumerate(texts, start=1):
        rows.append({
            "seq": idx,
            "filename": fn,
            "stkcd": stkcd,
            "year": year,
            "variant_type": variant,
            "note": variant_notes.get(variant, ""),
        })

    write_csv(os.path.join(output_dir, "metadata.csv"), rows, fieldnames)

    print(f"  → 已生成 {len(texts)} 条借贷公告 → {output_dir}/")
    print(f"  → 变体分布:")
    from collections import Counter
    vc = Counter(t[4] for t in texts)
    for k, v in sorted(vc.items(), key=lambda x: -x[1]):
        print(f"     {k}: {v} 条")

    return texts


# ============================================================
# 第二部分：财经新闻（6 条）
# ============================================================

def generate_news(output_dir):
    """生成 6 条财经新闻，保存为 news_samples.csv"""
    ensure_dir(output_dir)

    news_list = [
        {
            "id": 1,
            "title": "宁德时代一季度净利润同比增长35%，动力电池市占率稳居全球第一",
            "text": (
                "宁德时代4月25日晚间发布2024年一季报，公司实现营业收入798亿元，"
                "同比增长12.3%；归母净利润105亿元，同比大幅增长35.4%。公司表示，"
                "受益于全球新能源汽车渗透率持续提升，动力电池出货量保持强劲增长，"
                "全球市场份额进一步扩大至37.5%。多家券商维持'买入'评级，"
                "目标价上调至280元。"
            ),
            "label": "正面",
            "note": "词典法正面基准样本",
        },
        {
            "id": 2,
            "title": "某房企未能按期偿付美元债利息，标普下调评级至CC",
            "text": (
                "受流动性持续恶化影响，某大型房地产企业未能按期偿付一笔到期美元债券利息，"
                "构成实质性违约。标普全球评级随即将该公司长期信用评级由CCC-下调至CC，"
                "展望维持'负面'。受此消息冲击，该公司港股股价单日暴跌18.3%，"
                "年内累计跌幅已超过70%。分析人士指出，公司短期内面临较大的再融资压力，"
                "债务重组方案仍存在重大不确定性。"
            ),
            "label": "负面",
            "note": "词典法负面基准样本",
        },
        {
            "id": 3,
            "title": "招商银行不良贷款率连续三个季度下降，资产质量持续改善",
            "text": (
                "招商银行2024年一季报显示，截至3月末，全行不良贷款率为0.95%，"
                "较上年末下降0.05个百分点，连续三个季度改善。拨备覆盖率维持在450%以上"
                "的较高水平。市场人士评价称，招行在房地产风险敞口可控的前提下，"
                "资产质量表现优于同业平均水平，风险管理能力得到进一步验证。"
                "该股当日上涨2.1%。"
            ),
            "label": "正面（含歧义词：不良、风险、下降）",
            "note": "通用词典可能误判为负面",
        },
        {
            "id": 4,
            "title": "某制造业上市公司负债率攀升至82%，财务费用同比大幅增长",
            "text": (
                "某制造业上市公司最新财报显示，截至报告期末，公司资产负债率已攀升至82.3%，"
                "较年初上升6.2个百分点。其中短期借款同比增加30%，财务费用同比大幅增长"
                "45.1%，对公司利润形成明显侵蚀。公司解释称负债率上升主要源于产能扩张"
                "所需的资本开支。然而在当前市场需求放缓的背景下，高杠杆经营策略面临的"
                "不确定性正在提升。"
            ),
            "label": "负面（含歧义词：增长、提升、扩张）",
            "note": "通用词典可能误判为正面",
        },
        {
            "id": 5,
            "title": "央行宣布降准0.5个百分点，释放长期资金约1万亿元",
            "text": (
                "中国人民银行宣布，自2024年2月5日起，下调金融机构存款准备金率0.5个百分点。"
                "本次降准预计释放长期资金约1万亿元，有助于降低实体经济融资成本，"
                "支持经济平稳运行。市场分析认为，此举表明当前经济下行压力仍然较大，"
                "央行有必要通过货币政策工具进行逆周期调节。降准消息公布后，"
                "A股市场反应平淡，沪指微涨0.3%，债券市场则出现小幅走强。"
            ),
            "label": "混合",
            "note": "LLM优势场景-正面政策+负面经济暗示并存",
        },
        {
            "id": 6,
            "title": "沪深交易所发布退市新规，财务类退市营收门槛上调至3亿元",
            "text": (
                "沪深交易所4月30日同步发布《股票上市规则》修订稿，进一步完善退市标准体系。"
                "主要修订内容包括：将财务类退市中的营业收入指标由1亿元调整为3亿元；"
                "新增规范类退市中对控股股东资金占用的量化认定标准；交易类退市中的"
                "市值指标维持5亿元不变。新规自2024年7月1日起施行，设置一年过渡期。"
            ),
            "label": "中性",
            "note": "三种方法的中性基准+TF-IDF文档区分",
        },
    ]

    fieldnames = ["id", "title", "text", "label", "note"]
    write_csv(os.path.join(output_dir, "news_samples.csv"), news_list, fieldnames)
    print(f"  → 已生成 {len(news_list)} 条财经新闻 → {output_dir}/news_samples.csv")


# ============================================================
# 第三部分：央行货币政策执行报告片段（4 段）
# ============================================================

def generate_pboc_reports(output_dir):
    """生成 4 段央行货币政策执行报告片段"""
    ensure_dir(output_dir)

    reports = {
        "pboc_2020Q1.txt": (
            "2020年一季度，面对新冠肺炎疫情对经济社会发展带来的严峻冲击，"
            "中国人民银行坚决贯彻党中央、国务院决策部署，加大逆周期调节力度，"
            "综合运用多种货币政策工具，保持流动性合理充裕。一季度累计开展"
            "中期借贷便利（MLF）操作11000亿元，下调MLF利率30个基点至2.95%，"
            "引导贷款市场报价利率（LPR）相应下行。通过定向降准释放长期资金"
            "5500亿元，重点支持中小微企业和民营企业。3000亿元专项再贷款和"
            "5000亿元再贴现额度精准投向疫情防控和复工复产领域。金融机构"
            "贷款加权平均利率为5.08%，同比下降0.36个百分点，企业融资成本"
            "明显降低。"
        ),
        "pboc_2017Q4.txt": (
            "2017年四季度，中国人民银行继续实施稳健中性的货币政策，"
            "切实防范化解金融风险。在保持流动性基本稳定的前提下，"
            "适当抬升货币市场利率中枢，引导金融机构合理控制杠杆水平。"
            "银行体系超额准备金率为1.3%，处于较低水平。针对部分金融机构"
            "同业业务扩张过快、期限错配加剧等问题，进一步加强宏观审慎管理，"
            "将同业存单纳入同业负债考核口径。严格规范地方政府举债融资行为，"
            "坚决遏制隐性债务增量。下一阶段，将继续把防范化解重大风险"
            "摆在更加突出的位置，坚持去杠杆的政策方向不动摇。"
        ),
        "pboc_2023Q4.txt": (
            "2023年四季度，中国人民银行实施稳健的货币政策，灵活适度、"
            "精准有效，加大宏观政策调控力度，着力扩大内需、提振信心。"
            "保持流动性合理充裕，引导金融机构加大对实体经济的信贷支持。"
            "2023年全年社会融资规模增量累计35.59万亿元，同比多增3.41万亿元；"
            "人民币贷款增加22.75万亿元，同比多增1.31万亿元。结构性货币政策"
            "工具持续发力，科技创新、普惠小微、绿色发展等重点领域和薄弱环节"
            "的信贷支持力度加大。下一阶段，将继续实施稳健的货币政策，"
            "合理把握信贷投放节奏，增强信贷增长的稳定性和可持续性。"
        ),
        "pboc_2022Q2.txt": (
            "2022年二季度，全球通胀压力持续攀升，主要发达经济体央行加快"
            "收紧货币政策步伐。国内经济恢复基础尚不牢固，外部环境更趋复杂。"
            "中国人民银行统筹兼顾稳增长与防风险，密切关注国内外物价形势变化，"
            "保持货币信贷合理适度增长，不搞大水漫灌。6月末广义货币（M2）"
            "同比增长11.4%，社会融资规模存量同比增长10.8%。下一阶段，"
            "将兼顾短期与长期、经济增长与物价稳定、内部均衡与外部均衡，"
            "坚持不搞大水漫灌，不超发货币，为实体经济提供更有力、更高质量"
            "的金融支持。"
        ),
    }

    for filename, text in reports.items():
        write_text(os.path.join(output_dir, filename), text)

    print(f"  → 已生成 {len(reports)} 段央行报告 → {output_dir}/")


# ============================================================
# 第四部分：年报 MD&A 片段（3 段）
# ============================================================

def generate_mda(output_dir):
    """生成 3 段年报 MD&A 片段"""
    ensure_dir(output_dir)

    mda_texts = {
        "mda_招商银行_2023.txt": (
            "报告期内，本行坚持'轻型银行'战略方向不动摇，持续深化零售金融"
            "护城河。全年实现营业收入3391.23亿元，同比增长5.2%；归属于股东"
            "的净利润1466.02亿元，同比增长7.8%。资产质量保持稳健，不良贷款率"
            "0.95%，较上年末下降0.05个百分点；拨备覆盖率451.5%，风险抵补能力"
            "充足。本行零售客户总数突破1.97亿户，管理零售客户总资产（AUM）"
            "达13.32万亿元。财富管理手续费及佣金收入连续三年保持两位数增长。"
            "面对复杂多变的外部环境，本行将继续坚守合规底线，强化风险管理能力，"
            "以高质量发展回报股东和社会。"
        ),
        "mda_中兴通讯_2023.txt": (
            "报告期内，全球通信设备市场竞争格局进一步分化。5G网络建设"
            "由大规模部署阶段逐步过渡至深度覆盖与行业应用拓展阶段，"
            "运营商资本开支增速有所放缓。公司实现营业收入1242.5亿元，"
            "同比下降1.8%；研发投入为243.7亿元，占营业收入的比例为19.6%，"
            "继续保持行业领先水平。在产品层面，公司第三代自研芯片已完成"
            "流片验证并进入小批量商用阶段，服务器及存储产品全球市场份额"
            "稳步提升。海外收入占比为38.2%，地缘政治风险对部分市场的拓展"
            "仍构成不确定性。公司将持续加大研发投入力度，聚焦核心技术突破。"
        ),
        "mda_万科A_2023.txt": (
            "报告期内，房地产市场深度调整态势延续，行业整体面临前所未有的"
            "挑战。受商品房销售大幅下滑影响，公司全年实现营业收入4657.4亿元，"
            "同比下降7.6%；归属于上市公司股东的净利润为121.6亿元，同比下降"
            "46.4%。公司部分城市项目去化速度不及预期，存货跌价准备计提金额"
            "较上年显著增加。流动性方面，公司通过加快销售回款、处置非核心"
            "资产、压缩资本开支等多措并举，全力保障债务的如期偿付。截至"
            "报告期末，公司有息负债总额为2750.9亿元，一年内到期债务占比为"
            "38.5%，短期偿债压力较为突出。公司将继续以'活下去'为首要目标，"
            "主动作为，积极应对行业调整带来的严峻考验。"
        ),
    }

    for filename, text in mda_texts.items():
        write_text(os.path.join(output_dir, filename), text)

    print(f"  → 已生成 {len(mda_texts)} 段年报 MD&A → {output_dir}/")


# ============================================================
# 第五部分：交易所问询函片段（3 段）
# ============================================================

def generate_inquiry_letters(output_dir):
    """生成 3 段交易所问询函片段"""
    ensure_dir(output_dir)

    letters = {
        "inquiry_营收确认.txt": (
            "【问题3】关于营业收入确认。年报显示，你公司2023年第四季度"
            "实现营业收入18.7亿元，占全年营业收入的41.3%，明显高于前三季度"
            "平均水平。请说明：（1）第四季度收入大幅增长的具体原因和合理性；"
            "（2）是否存在提前确认收入或跨期调节利润的情形。\n\n"
            "【公司回复】\n"
            "2023年第四季度营业收入较前三季度增长的主要原因如下："
            "一是公司与主要客户华为技术有限公司的年度框架协议于2023年11月"
            "完成签署，相关订单集中在四季度交付验收，确认收入12.3亿元，"
            "占四季度收入的65.8%；二是政府补助项目'新一代通信核心设备研发'"
            "于12月通过终验，一次性确认收入2.1亿元；三是海外市场印度尼西亚"
            "电信项目于10月完成系统联调测试并取得客户签收单。"
            "上述收入确认均严格按照企业会计准则第14号——收入的相关规定执行，"
            "以控制权转移为确认时点，不存在提前确认收入或跨期调节利润的情形。"
            "年审会计师已对上述事项实施了专项审计程序，出具了无保留意见的审计报告。"
        ),
        "inquiry_商誉减值.txt": (
            "【问题5】关于商誉减值。年报显示，截至2023年末你公司商誉账面"
            "价值为25.8亿元，占净资产的34.2%。其中，2021年收购深圳智联"
            "科技有限公司形成的商誉为18.6亿元，但该子公司2023年度实现"
            "净利润仅为0.8亿元，远低于收购时业绩承诺的2.5亿元。请说明："
            "（1）各项商誉对应的资产组（组合）及具体构成；"
            "（2）商誉减值测试的具体过程和关键参数假设；"
            "（3）是否存在商誉减值计提不充分的情形。\n\n"
            "【公司回复】\n"
            "一、商誉的构成及对应资产组\n"
            "截至2023年12月31日，公司商誉明细如下：（1）收购深圳智联"
            "科技有限公司形成商誉18.6亿元，对应资产组为智联科技整体经营"
            "资产；（2）收购北京云数据服务有限公司形成商誉4.7亿元，对应"
            "资产组为云数据公司数据中心业务板块；（3）收购上海芯创微电子"
            "有限公司形成商誉2.5亿元，对应资产组为芯创微电子芯片设计"
            "业务板块。\n\n"
            "二、商誉减值测试过程\n"
            "公司聘请中审众环会计师事务所对各资产组进行了减值测试，采用"
            "收益法（现金流折现法）估计可收回金额。关键参数如下："
            "（1）智联科技：预测期为2024-2028年，收入增长率假设分别为"
            "15%、18%、15%、12%、10%，永续增长率3%，折现率（WACC）为"
            "12.5%。预测期内累计自由现金流现值为16.2亿元，永续期价值"
            "现值为9.8亿元，可收回金额合计26.0亿元，高于含商誉资产组"
            "账面价值24.3亿元，未发生减值。"
            "（2）云数据公司：折现率11.8%，可收回金额6.1亿元，高于含"
            "商誉资产组账面价值5.9亿元，未发生减值。"
            "（3）芯创微电子：折现率13.2%，可收回金额2.8亿元，高于含"
            "商誉资产组账面价值2.7亿元，差额仅0.1亿元，公司已充分关注"
            "该资产组的后续经营变化。\n\n"
            "三、关于减值计提充分性\n"
            "基于上述测试结果，各资产组可收回金额均高于其账面价值，故"
            "2023年度未计提商誉减值准备。但公司注意到，智联科技2023年度"
            "实际净利润0.8亿元较业绩承诺2.5亿元存在较大差距，主要原因"
            "系下游消费电子市场需求持续疲软，导致订单量未达预期。若2024年"
            "市场环境未能显著改善，不排除未来期间存在商誉减值的风险。"
        ),
        "inquiry_关联交易.txt": (
            "【问题8】关于关联交易。年报显示，你公司2023年度向控股股东"
            "瑞丰集团有限公司及其关联方采购商品和接受劳务的金额为8.6亿元，"
            "同比增长62.3%。请说明：（1）关联交易大幅增长的原因及必要性；"
            "（2）关联交易定价是否公允，是否存在利益输送的情形。\n\n"
            "【公司回复】\n"
            "一、关联交易增长的原因及必要性\n"
            "2023年度关联采购金额增长主要系以下原因：（1）公司新建的"
            "合肥生产基地于2023年6月投产，厂房建设及设备安装工程由"
            "瑞丰集团旗下瑞丰建设工程有限公司承建，工程结算金额3.2亿元；"
            "（2）合肥基地投产后，原材料采购规模相应增加，其中向瑞丰集团"
            "旗下瑞丰材料科技有限公司采购电子级铜箔2.1亿元。上述关联"
            "交易均经公司董事会审议批准，独立董事发表了同意的独立意见。\n\n"
            "二、关联交易定价的公允性\n"
            "（1）工程建设方面：瑞丰建设承建合肥基地的工程单价为每平方米"
            "6800元，公司同期就同类型厂房向非关联方中建三局询价，报价为"
            "每平方米7200元，关联交易价格低于市场价格约5.6%。"
            "（2）原材料采购方面：公司同时向非关联供应商灵宝华鑫铜箔有限"
            "公司采购同规格电子级铜箔，瑞丰材料的供货价格为每吨7.2万元，"
            "灵宝华鑫的价格为每吨7.35万元，关联交易价格低于可比市场价格"
            "约2.0%。\n"
            "综上，公司认为上述关联交易定价公允，不存在向控股股东输送"
            "利益的情形。独立财务顾问中信证券对上述关联交易出具了核查"
            "意见，认为定价公允、程序合规。"
        ),
    }

    for filename, text in letters.items():
        write_text(os.path.join(output_dir, filename), text)

    print(f"  → 已生成 {len(letters)} 段问询函 → {output_dir}/")


# ============================================================
# 第六部分：分析师研报摘要（3 条）
# ============================================================

def generate_analyst_reports(output_dir):
    """生成 3 条分析师研报摘要"""
    ensure_dir(output_dir)

    reports = {
        "report_宁德时代_买入.txt": (
            "【中信证券·宁德时代(300750)·深度报告】\n"
            "评级：买入（维持）  目标价：280.00元（前值250.00元）\n\n"
            "核心观点：\n"
            "公司一季度业绩超出市场预期，动力电池全球市占率进一步提升至"
            "37.5%，龙头地位持续稳固。我们认为公司在技术迭代（麒麟电池、"
            "神行超充电池）和产能全球化布局（匈牙利工厂2025年投产）两个"
            "维度上具备显著的先发优势，短期内竞争格局难以被颠覆。\n\n"
            "盈利预测方面，我们上调2024-2026年归母净利润预测至435/520/610"
            "亿元（前值400/480/560亿元），对应当前股价PE分别为22/18/16倍，"
            "估值处于历史中枢偏低水平。考虑到公司在储能业务的第二增长曲线"
            "已初步兑现（一季度储能收入同比增长85%），我们认为当前估值未能"
            "充分反映公司的长期成长性。维持'买入'评级，上调目标价至280元。\n\n"
            "风险提示：新能源汽车销量不及预期；原材料价格大幅波动；海外"
            "贸易政策风险。"
        ),
        "report_中兴通讯_中性.txt": (
            "【国泰君安·中兴通讯(000063)·跟踪报告】\n"
            "评级：中性（维持）  目标价：28.00元（前值32.00元）\n\n"
            "核心观点：\n"
            "公司一季度营收同比下降1.8%，基本符合我们此前的谨慎预期。5G"
            "网络建设进入成熟期后运营商资本开支增速放缓的趋势已较为明确，"
            "公司传统运营商业务面临的增长压力短期内难以缓解。\n\n"
            "值得关注的是，公司在服务器及存储领域的布局正在逐步贡献增量，"
            "但目前体量仍较小（占营收约12%），尚不足以对冲主业的放缓。"
            "海外收入占比38.2%，地缘政治不确定性对部分市场的拓展构成"
            "持续制约。我们小幅下调2024-2025年盈利预测至65/72亿元"
            "（前值70/78亿元），对应PE分别为18/16倍。\n\n"
            "当前估值基本反映了公司的基本面状况，上行催化剂有限。维持"
            "'中性'评级，下调目标价至28元。\n\n"
            "风险提示：运营商资本开支超预期回升；AI服务器需求爆发式增长；"
            "汇率大幅波动。"
        ),
        "report_万科A_减持.txt": (
            "【华泰证券·万科A(000002)·评级下调报告】\n"
            "评级：减持（前值：中性）  目标价：8.50元（前值12.00元）\n\n"
            "核心观点：\n"
            "我们将万科评级由'中性'下调至'减持'。核心逻辑在于：公司的"
            "流动性风险已从'潜在担忧'升级为'现实挑战'。截至一季度末，"
            "一年内到期有息负债占比攀升至38.5%，而同期销售回款同比下降"
            "23.7%，经营性现金流已连续两个季度为负。公司虽已启动非核心"
            "资产处置计划，但在当前市场环境下资产变现折价率可能显著高于"
            "管理层预期。\n\n"
            "更为关键的是，行业层面的负反馈循环尚未出现拐点信号：房价"
            "下行→居民购房意愿低迷→开发商回款困难→被迫降价→房价进一步"
            "下行。在这一循环打破之前，即便是万科这样的头部企业，其信用"
            "资质的修复也缺乏坚实的基本面支撑。\n\n"
            "我们大幅下调2024-2025年归母净利润预测至45/55亿元（前值"
            "90/110亿元），下调幅度达50%。下调目标价至8.50元，对应"
            "2024年PB约0.45倍，隐含了较为悲观的资产重估预期。\n\n"
            "风险提示（上行风险）：房地产政策超预期放松；公司成功完成"
            "大规模资产处置且折价率低于预期；市场销售出现趋势性企稳。"
        ),
    }

    for filename, text in reports.items():
        write_text(os.path.join(output_dir, filename), text)

    print(f"  → 已生成 {len(reports)} 条研报摘要 → {output_dir}/")


# ============================================================
# 主函数
# ============================================================

def main():
    """生成全部文本素材"""
    print("=" * 60)
    print("生成「金融文本分析」两章的全部文本素材")
    print("=" * 60)

    base_dir = "data_raw"

    print("\n[1/6] 生成借贷公告（50 条）...")
    generate_announcements(os.path.join(base_dir, "announcements"))

    print("\n[2/6] 生成财经新闻（6 条）...")
    generate_news(os.path.join(base_dir, "news"))

    print("\n[3/6] 生成央行货币政策执行报告片段（4 段）...")
    generate_pboc_reports(os.path.join(base_dir, "pboc_reports"))

    print("\n[4/6] 生成年报 MD&A 片段（3 段）...")
    generate_mda(os.path.join(base_dir, "mda"))

    print("\n[5/6] 生成交易所问询函片段（3 段）...")
    generate_inquiry_letters(os.path.join(base_dir, "inquiry_letters"))

    print("\n[6/6] 生成分析师研报摘要（3 条）...")
    generate_analyst_reports(os.path.join(base_dir, "analyst_reports"))

    print("\n" + "=" * 60)
    print("全部素材生成完毕！")
    print(f"输出目录：{os.path.abspath(base_dir)}/")
    print("=" * 60)

    # 汇总统计
    print("\n文件统计：")
    for root, dirs, files in os.walk(base_dir):
        level = root.replace(base_dir, "").count(os.sep)
        indent = "  " * level
        print(f"{indent}{os.path.basename(root)}/")
        sub_indent = "  " * (level + 1)
        for file in sorted(files)[:5]:
            print(f"{sub_indent}{file}")
        if len(files) > 5:
            print(f"{sub_indent}... 共 {len(files)} 个文件")


if __name__ == "__main__":
    main()
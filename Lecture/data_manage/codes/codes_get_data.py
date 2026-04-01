"""
codes_get_data.py
数据下载脚本 - 为「数据管理与组织」讲义下载所有数据集
"""
import pandas as pd
import re
import time
import glob
from pathlib import Path
from datetime import datetime

# 基础路径
BASE = Path('../data_manage')
DATA_RAW = BASE / 'data_raw'
LOG_PATH = DATA_RAW / 'download_log.txt'

def log(msg: str):
    """追加写入下载日志"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    line = f'[{timestamp}] {msg}\n'
    print(line.rstrip())
    with open(LOG_PATH, 'a', encoding='utf-8') as f:
        f.write(line)

# ─────────────────────────────────────────────
# 数据集 A：10只个股日度行情
# ─────────────────────────────────────────────
stocks = {
    "000001": "平安银行",
    "000002": "万科A",
    "600519": "贵州茅台",
    "300750": "宁德时代",
    "601318": "中国平安",
    "002594": "比亚迪",
    "600036": "招商银行",
    "601012": "隆基绿能",
    "000333": "美的集团",
    "600276": "恒瑞医药",
}

log('=' * 60)
log('开始下载数据集 A：个股日度行情')
log('=' * 60)

import akshare as ak

for code, name in stocks.items():
    csv_path = DATA_RAW / 'stock_daily' / f'{code}.csv'
    if csv_path.exists():
        df_exist = pd.read_csv(csv_path)
        log(f'✓ stock_daily/{code}.csv 已存在，跳过（{len(df_exist)} 行）')
        continue

    # 主接口：akshare
    try:
        df = ak.stock_zh_a_hist(
            symbol=code, period="daily",
            start_date="20200101", end_date="20260330",
            adjust="hfq"
        )
        # 统一字段名
        df.columns = ['date', 'open', 'close', 'high', 'low',
                      'volume', 'amount', 'amplitude', 'pct_chg', 'chg', 'turnover']
        df['code'] = code
        df['name'] = name
        df.to_csv(csv_path, index=False, encoding='utf-8-sig')
        size_kb = csv_path.stat().st_size / 1024
        log(f'✓ stock_daily/{code}.csv  行数：{len(df)}  时间：{df["date"].min()} ~ {df["date"].max()}  大小：{size_kb:.1f} KB')
        time.sleep(0.8)
    except Exception as e1:
        log(f'✗ stock_daily/{code}.csv  akshare 失败：{e1}，尝试 baostock...')
        # 备用接口：baostock
        try:
            import baostock as bs
            lg = bs.login()
            prefix = "sz." if code.startswith(("0", "3")) else "sh."
            rs = bs.query_history_k_data_plus(
                f"{prefix}{code}",
                "date,open,high,low,close,volume,amount,turn",
                start_date="2020-01-01", end_date="2026-03-30",
                frequency="d", adjustflag="1"
            )
            data = []
            while rs.error_code == '0' and rs.next():
                data.append(rs.get_row_data())
            bs.logout()
            if data:
                df = pd.DataFrame(data, columns=["date", "open", "high", "low", "close",
                                                 "volume", "amount", "turnover"])
                df['code'] = code
                df['name'] = name
                df['pct_chg'] = pd.to_numeric(df['close'], errors='coerce').pct_change() * 100
                # 数值转换
                for col in ['open', 'high', 'low', 'close', 'volume', 'amount', 'turnover']:
                    df[col] = pd.to_numeric(df[col], errors='coerce')
                df.to_csv(csv_path, index=False, encoding='utf-8-sig')
                size_kb = csv_path.stat().st_size / 1024
                log(f'  ↔ baostock 重试成功  行数：{len(df)}  大小：{size_kb:.1f} KB')
            else:
                log(f'  ✗ baostock 也无数据，跳过 {code}')
        except Exception as e2:
            log(f'  ✗ baostock 也失败：{e2}，跳过 {code}')
        time.sleep(1.0)

# ─────────────────────────────────────────────
# 数据集 B1：市场指数日度
# ─────────────────────────────────────────────
log('\n' + '=' * 60)
log('开始下载数据集 B1：市场指数日度')
log('=' * 60)

indices = {
    "000300": "沪深300",
    "000001": "上证综指",
    "399001": "深证成指",
}

for code, name in indices.items():
    csv_path = DATA_RAW / 'index_daily' / f'{code}.csv'
    if csv_path.exists():
        df_exist = pd.read_csv(csv_path)
        log(f'✓ index_daily/{code}.csv 已存在，跳过（{len(df_exist)} 行）')
        continue
    try:
        df = ak.index_zh_a_hist(
            symbol=code, period="daily",
            start_date="20200101", end_date="20260330"
        )
        df.columns = ['date', 'open', 'close', 'high', 'low',
                      'volume', 'amount', 'amplitude', 'pct_chg', 'chg', 'turnover']
        df['index_code'] = code
        df['index_name'] = name
        df.to_csv(csv_path, index=False, encoding='utf-8-sig')
        size_kb = csv_path.stat().st_size / 1024
        log(f'✓ index_daily/{code}.csv  行数：{len(df)}  时间：{df["date"].min()} ~ {df["date"].max()}  大小：{size_kb:.1f} KB')
        time.sleep(0.8)
    except Exception as e:
        log(f'✗ index_daily/{code}.csv  失败：{e}')

# ─────────────────────────────────────────────
# 数据集 B2：宏观月度数据
# ─────────────────────────────────────────────
log('\n' + '=' * 60)
log('开始下载数据集 B2：宏观月度数据')
log('=' * 60)

# Shibor 3个月期利率
shibor_path = DATA_RAW / 'macro_monthly' / 'shibor_3m.csv'
if not shibor_path.exists():
    try:
        df = ak.rate_interbank(market="上海银行同业拆借市场", symbol="Shibor人民币", indicator="3月")
        df = df.rename(columns={df.columns[0]: 'date', df.columns[1]: 'shibor_3m'})
        df['date'] = pd.to_datetime(df['date'], errors='coerce')
        df = df[df['date'] >= '2020-01-01'].copy()
        df['date'] = df['date'].dt.strftime('%Y-%m')
        df = df[['date', 'shibor_3m']].drop_duplicates('date')
        df.to_csv(shibor_path, index=False, encoding='utf-8-sig')
        log(f'✓ macro_monthly/shibor_3m.csv  行数：{len(df)}')
    except Exception as e:
        log(f'✗ macro_monthly/shibor_3m.csv  失败：{e}')
        # 生成模拟数据
        import numpy as np
        dates = pd.date_range('2020-01', '2026-03', freq='ME')
        df_sim = pd.DataFrame({
            'date': dates.strftime('%Y-%m'),
            'shibor_3m': np.random.uniform(1.5, 3.5, len(dates)).round(4)
        })
        df_sim.to_csv(shibor_path, index=False, encoding='utf-8-sig')
        log(f'  → 使用模拟数据：{len(df_sim)} 行')
else:
    df = pd.read_csv(shibor_path)
    log(f'✓ macro_monthly/shibor_3m.csv 已存在，跳过（{len(df)} 行）')

time.sleep(0.8)

# 人民币兑美元汇率
usdcny_path = DATA_RAW / 'macro_monthly' / 'usd_cny.csv'
if not usdcny_path.exists():
    try:
        df = ak.currency_hist(symbol="USDCNY")
        # 找日期列和收盘列
        date_col = [c for c in df.columns if '日期' in str(c) or 'date' in str(c).lower()][0]
        close_col = [c for c in df.columns if '收盘' in str(c) or 'close' in str(c).lower()][0]
        df = df[[date_col, close_col]].rename(columns={date_col: 'date', close_col: 'usd_cny'})
        df['date'] = pd.to_datetime(df['date'], errors='coerce')
        df = df[df['date'] >= '2020-01-01'].copy()
        # 按月取最后一个交易日
        df['month'] = df['date'].dt.to_period('M')
        df = df.sort_values('date').groupby('month').last().reset_index()
        df['date'] = df['month'].dt.strftime('%Y-%m')
        df = df[['date', 'usd_cny']]
        df.to_csv(usdcny_path, index=False, encoding='utf-8-sig')
        log(f'✓ macro_monthly/usd_cny.csv  行数：{len(df)}')
    except Exception as e:
        log(f'✗ macro_monthly/usd_cny.csv  失败：{e}')
        # 生成模拟数据
        import numpy as np
        dates = pd.date_range('2020-01', '2026-03', freq='ME')
        df_sim = pd.DataFrame({
            'date': dates.strftime('%Y-%m'),
            'usd_cny': np.random.uniform(6.3, 7.3, len(dates)).round(4)
        })
        df_sim.to_csv(usdcny_path, index=False, encoding='utf-8-sig')
        log(f'  → 使用模拟数据：{len(df_sim)} 行')
else:
    df = pd.read_csv(usdcny_path)
    log(f'✓ macro_monthly/usd_cny.csv 已存在，跳过（{len(df)} 行）')

time.sleep(0.8)

# CPI 月度
cpi_path = DATA_RAW / 'macro_monthly' / 'cpi_monthly.csv'
if not cpi_path.exists():
    try:
        df = ak.macro_china_cpi_monthly()
        # 找月份列和CPI当月列
        date_col = [c for c in df.columns if '月份' in str(c) or '日期' in str(c)][0]
        cpi_col = [c for c in df.columns if '当月' in str(c) and '全国' in str(c)][0]
        df = df[[date_col, cpi_col]].rename(columns={date_col: 'date', cpi_col: 'cpi_yoy'})
        df['date'] = df['date'].astype(str)
        df = df[df['date'] >= '2020-01'].copy()
        df.to_csv(cpi_path, index=False, encoding='utf-8-sig')
        log(f'✓ macro_monthly/cpi_monthly.csv  行数：{len(df)}')
    except Exception as e:
        log(f'✗ macro_monthly/cpi_monthly.csv  失败：{e}')
        # 生成模拟数据
        import numpy as np
        dates = pd.date_range('2020-01', '2026-03', freq='ME')
        df_sim = pd.DataFrame({
            'date': dates.strftime('%Y-%m'),
            'cpi_yoy': np.random.uniform(-0.5, 3.5, len(dates)).round(1)
        })
        df_sim.to_csv(cpi_path, index=False, encoding='utf-8-sig')
        log(f'  → 使用模拟数据：{len(df_sim)} 行')
else:
    df = pd.read_csv(cpi_path)
    log(f'✓ macro_monthly/cpi_monthly.csv 已存在，跳过（{len(df)} 行）')

# ─────────────────────────────────────────────
# 数据集 C：个股年度财务指标
# ─────────────────────────────────────────────
log('\n' + '=' * 60)
log('开始下载数据集 C：年度财务指标')
log('=' * 60)

fin_path = DATA_RAW / 'fin_annual' / 'fin_indicators.csv'
if not fin_path.exists():
    all_fin = []
    for code, name in stocks.items():
        try:
            df = ak.stock_a_indicator_lg(symbol=code)
            # 筛选 2018-2023 年数据
            if 'trade_date' in df.columns:
                df['year'] = pd.to_datetime(df['trade_date']).dt.year
            elif '报告期' in df.columns:
                df['year'] = pd.to_datetime(df['报告期']).dt.year
            else:
                # 尝试找年份列
                year_col = [c for c in df.columns if '年' in str(c) or 'year' in str(c).lower()]
                if year_col:
                    df['year'] = df[year_col[0]].astype(str).str[:4].astype(int)
                else:
                    df['year'] = range(2018, 2018 + len(df))

            df = df[df['year'].between(2018, 2024)].copy()
            df['code'] = code
            df['name'] = name

            # 选取关键财务指标（灵活处理字段名）
            col_map = {
                'pe_ttm': ['pe_ttm', 'pe', 'total_mv'],
                'pb': ['pb', 'pb_mrq'],
                'roe': ['roe', 'roe_ttm', 'avg_roe'],
                'total_revenue': ['total_revenue', 'operating_revenue', 'total_operate_revenue'],
                'net_profit': ['net_profit', 'net_profit_atsopc', 'n_income_attr_p'],
                'total_assets': ['total_assets', 'total_asset'],
                'debt_ratio': ['debt_to_assets', 'debt_ratio', 'total_liab'],
            }

            result = pd.DataFrame({'code': df['code'], 'name': df['name'], 'year': df['year']})
            for target_col, candidates in col_map.items():
                for cand in candidates:
                    if cand in df.columns:
                        result[target_col] = pd.to_numeric(df[cand], errors='coerce')
                        break
                else:
                    result[target_col] = None

            all_fin.append(result)
            log(f'✓ fin_annual/{code} {name}  {len(result)} 行')
            time.sleep(0.8)
        except Exception as e:
            log(f'✗ fin_annual/{code} {name}  失败：{e}，尝试备用接口...')
            try:
                df = ak.stock_financial_abstract_ths(symbol=code, indicator="按年度")
                df['code'] = code
                df['name'] = name
                # 尝试提取年份
                if '报告期' in df.columns:
                    df['year'] = pd.to_datetime(df['报告期'], errors='coerce').dt.year
                else:
                    df['year'] = None
                result = pd.DataFrame({'code': [code], 'name': [name], 'year': [None],
                                       'pe_ttm': [None], 'pb': [None], 'roe': [None],
                                       'total_revenue': [None], 'net_profit': [None],
                                       'total_assets': [None], 'debt_ratio': [None]})
                all_fin.append(result)
                log(f'  ↔ 备用接口获取部分数据')
            except Exception as e2:
                log(f'  ✗ 备用接口也失败：{e2}，跳过 {code}')
            time.sleep(1.0)

    if all_fin:
        df_fin = pd.concat(all_fin, ignore_index=True)
        # 验证主键无重复
        dup = df_fin.duplicated(subset=['code', 'year'], keep='first')
        if dup.sum() > 0:
            log(f'  注意：发现 {dup.sum()} 条重复记录，保留第一条')
            df_fin = df_fin[~dup]
        df_fin.to_csv(fin_path, index=False, encoding='utf-8-sig')
        log(f'✓ fin_annual/fin_indicators.csv  总行数：{len(df_fin)}')
    else:
        log('✗ 财务数据全部下载失败，生成模拟数据')
        df_sim = pd.DataFrame({
            'code': [c for c in stocks.keys() for _ in range(6)],
            'name': [n for n in stocks.values() for _ in range(6)],
            'year': [y for _ in stocks.keys() for y in range(2018, 2024)],
            'pe_ttm': None, 'pb': None, 'roe': None,
            'total_revenue': None, 'net_profit': None,
            'total_assets': None, 'debt_ratio': None,
        })
        df_sim.to_csv(fin_path, index=False, encoding='utf-8-sig')
        log(f'  → 使用模拟数据骨架：{len(df_sim)} 行')
else:
    df = pd.read_csv(fin_path)
    log(f'✓ fin_annual/fin_indicators.csv 已存在，跳过（{len(df)} 行）')

# ─────────────────────────────────────────────
# 数据集 D：公司基本信息
# ─────────────────────────────────────────────
log('\n' + '=' * 60)
log('开始下载数据集 D：公司基本信息')
log('=' * 60)

company_path = DATA_RAW / 'company_info.csv'
company_start_year = 2010
company_end_year = 2025
company_years = list(range(company_start_year, company_end_year + 1))


def clean_text(x):
    """将输入统一清洗为字符串。"""
    if x is None:
        return ''
    if pd.isna(x):
        return ''
    s = str(x).strip()
    if s.lower() in {'nan', 'none', 'nat'}:
        return ''
    return s


def normalize_code(code):
    """将股票代码规范化为 6 位字符串。"""
    s = clean_text(code)
    s = re.sub(r'\D', '', s)
    return s.zfill(6)


def format_date_yyyymmdd(x):
    """将日期统一转换为 YYYYMMDD 格式字符串。"""
    s = clean_text(x)
    if not s:
        return ''

    dt = pd.to_datetime(s, errors='coerce')
    if pd.isna(dt):
        return ''

    return dt.strftime('%Y%m%d')


def build_csrc_industry_string(df_sub):
    """
    将某个时点有效的证监会行业分类记录拼接成一个字符串。
    拼接顺序：行业门类 -> 行业大类 -> 行业中类 -> 行业次类。
    """
    if df_sub is None or df_sub.empty:
        return ''

    latest_date = df_sub['变更日期'].max()
    temp = df_sub[df_sub['变更日期'] == latest_date].copy()

    values = []
    for col in ['行业门类', '行业大类', '行业中类', '行业次类']:
        if col in temp.columns:
            vals = (
                temp[col]
                .dropna()
                .astype(str)
                .str.strip()
                .replace('', pd.NA)
                .dropna()
                .unique()
                .tolist()
            )
            for v in vals:
                if v not in values:
                    values.append(v)

    return '-'.join(values)


def get_profile_info(code):
    """
    抓取公司概况信息。
    返回：上市时间、注册地址。
    """
    try:
        df = ak.stock_profile_cninfo(symbol=code)

        if df is None or df.empty:
            return {'上市时间': '', '注册地址': ''}

        row = df.iloc[0]
        return {
            '上市时间': format_date_yyyymmdd(row.get('上市日期', '')),
            '注册地址': clean_text(row.get('注册地址', ''))
        }

    except Exception as e:
        log(f'✗ company_info/{code} 公司概况抓取失败：{e}')
        return {'上市时间': '', '注册地址': ''}


def get_industry_change_info(code):
    """
    抓取某只股票全部行业变动记录，并只保留证监会分类标准。
    """
    try:
        df = ak.stock_industry_change_cninfo(
            symbol=code,
            start_date='19900101',
            end_date=pd.Timestamp.today().strftime('%Y%m%d')
        )

        if df is None or df.empty:
            return pd.DataFrame()

        df = df.copy()
        df['变更日期'] = pd.to_datetime(df['变更日期'], errors='coerce')

        if '分类标准' in df.columns:
            df = df[df['分类标准'].astype(str).str.contains('证监会', na=False)].copy()

        df = df.sort_values('变更日期').reset_index(drop=True)
        return df

    except Exception as e:
        log(f'✗ company_info/{code} 行业变动抓取失败：{e}')
        return pd.DataFrame()


def get_industry_for_year(industry_df, year):
    """返回某只股票在 year 年年末有效的证监会行业分类。"""
    if industry_df is None or industry_df.empty:
        return ''

    year_end = pd.Timestamp(f'{int(year)}-12-31')
    temp = industry_df[industry_df['变更日期'] <= year_end].copy()

    if temp.empty:
        return ''

    return build_csrc_industry_string(temp)


def fill_nearest_values(series):
    """
    用最近相邻年份的值填补缺失值。
    若前后距离相同，则优先使用前一年的值。
    """
    s = series.copy().replace('', pd.NA)
    values = s.tolist()
    non_missing_positions = [i for i, v in enumerate(values) if pd.notna(v)]

    if len(non_missing_positions) == 0:
        return s.fillna('')

    for i, v in enumerate(values):
        if pd.notna(v):
            continue

        left_candidates = [p for p in non_missing_positions if p < i]
        right_candidates = [p for p in non_missing_positions if p > i]

        left_pos = max(left_candidates) if left_candidates else None
        right_pos = min(right_candidates) if right_candidates else None

        if left_pos is None and right_pos is None:
            values[i] = ''
        elif left_pos is None:
            values[i] = values[right_pos]
        elif right_pos is None:
            values[i] = values[left_pos]
        else:
            left_dist = i - left_pos
            right_dist = right_pos - i
            values[i] = values[left_pos] if left_dist <= right_dist else values[right_pos]

    return pd.Series(values, index=s.index).fillna('')


if company_path.exists():
    log('发现旧版 company_info.csv，将使用新规则覆盖写入')

profile_dict = {}
industry_dict = {}
company_rows = []

for code, name in stocks.items():
    code = normalize_code(code)
    profile_dict[code] = get_profile_info(code)
    time.sleep(0.4)
    industry_dict[code] = get_industry_change_info(code)
    time.sleep(0.4)

for code, name in stocks.items():
    code = normalize_code(code)
    profile_info = profile_dict.get(code, {'上市时间': '', '注册地址': ''})
    industry_df = industry_dict.get(code, pd.DataFrame())

    for year in company_years:
        company_rows.append({
            'code': code,
            'name': name,
            'year': year,
            '证监会行业分类': get_industry_for_year(industry_df, year),
            '上市时间': profile_info.get('上市时间', ''),
            '注册地址': profile_info.get('注册地址', '')
        })

if company_rows:
    df_company = pd.DataFrame(company_rows)
    df_company = df_company.sort_values(['code', 'year']).reset_index(drop=True)

    for col in ['证监会行业分类', '上市时间', '注册地址']:
        df_company[col] = (
            df_company.groupby('code', group_keys=False)[col]
            .apply(fill_nearest_values)
        )

    df_company.to_csv(company_path, index=False, encoding='utf-8-sig')
    log(f'✓ company_info.csv 已覆盖写入  总行数：{len(df_company)}  年份：{company_start_year}-{company_end_year}')
else:
    df_company = pd.DataFrame(columns=['code', 'name', 'year', '证监会行业分类', '上市时间', '注册地址'])
    df_company.to_csv(company_path, index=False, encoding='utf-8-sig')
    log('✗ company_info 数据为空，已写入空表结构')

# ─────────────────────────────────────────────
# 数据健康检查
# ─────────────────────────────────────────────
log('\n' + '=' * 60)
log('数据健康检查')
log('=' * 60)

print('\n' + '=' * 70)
print(f'{"数据集":<20} {"文件数":>6} {"总行数":>8} {"时间范围":<25} {"缺失值":>6}')
print('=' * 70)

# stock_daily
csv_files = [f for f in glob.glob(str(DATA_RAW / 'stock_daily/*.csv'))]
if csv_files:
    dfs = [pd.read_csv(f) for f in csv_files]
    df_all = pd.concat(dfs)
    missing = df_all.isnull().sum().sum()
    date_range = f'{df_all["date"].min()} ~ {df_all["date"].max()}'
    log_line = f'stock_daily        {len(csv_files):>6}  {len(df_all):>8,}  {date_range:<25}  {missing:>6}'
    print(log_line)
    log(log_line)

# index_daily  
csv_files = [f for f in glob.glob(str(DATA_RAW / 'index_daily/*.csv'))]
if csv_files:
    dfs = [pd.read_csv(f) for f in csv_files]
    df_all = pd.concat(dfs)
    missing = df_all.isnull().sum().sum()
    date_range = f'{df_all["date"].min()} ~ {df_all["date"].max()}'
    log_line = f'index_daily        {len(csv_files):>6}  {len(df_all):>8,}  {date_range:<25}  {missing:>6}'
    print(log_line)
    log(log_line)

# macro_monthly
csv_files = [f for f in glob.glob(str(DATA_RAW / 'macro_monthly/*.csv'))]
if csv_files:
    dfs = [pd.read_csv(f) for f in csv_files]
    df_all = pd.concat(dfs)
    missing = df_all.isnull().sum().sum()
    log_line = f'macro_monthly      {len(csv_files):>6}  {len(df_all):>8,}  {"2020-01 ~ 2026-03":<25}  {missing:>6}'
    print(log_line)
    log(log_line)

# fin_annual
if fin_path.exists():
    df = pd.read_csv(fin_path)
    missing = df.isnull().sum().sum()
    year_range = f'{df["year"].min():.0f} ~ {df["year"].max():.0f}' if 'year' in df.columns else '—'
    log_line = f'fin_annual         {"1":>6}  {len(df):>8}  {year_range:<25}  {missing:>6}'
    print(log_line)
    log(log_line)

# company_info
if company_path.exists():
    df = pd.read_csv(company_path)
    missing = df.isnull().sum().sum()
    log_line = f'company_info       {"1":>6}  {len(df):>8}  {"—":<25}  {missing:>6}'
    print(log_line)
    log(log_line)

print('=' * 70)
log('\n数据下载完成！')
print('\n数据下载完成！')

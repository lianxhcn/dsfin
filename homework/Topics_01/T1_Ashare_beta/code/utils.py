"""
工具函数模块
包含数据收集、处理和分析的常用函数
"""

import pandas as pd
import numpy as np
import akshare as ak
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import warnings
warnings.filterwarnings('ignore')

def download_stock_data(symbol, symbol_name, start_date, end_date, is_index=False):
    """
    下载股票或指数数据
    
    Parameters:
    - symbol: 股票代码或指数代码
    - symbol_name: 股票名称
    - start_date: 开始日期
    - end_date: 结束日期  
    - is_index: 是否为指数
    
    Returns:
    - DataFrame: 包含日期和收盘价的数据
    """
    try:
        if is_index:
            # 下载指数数据
            print(f"正在下载指数数据：{symbol_name} ({symbol})")
            data = ak.index_zh_a_hist(symbol=symbol, period="daily", start_date=start_date, end_date=end_date)
        else:
            # 下载股票数据（后复权）
            print(f"正在下载股票数据：{symbol_name} ({symbol})")
            data = ak.stock_zh_a_hist(symbol=symbol, period="daily", start_date=start_date, end_date=end_date, adjust="hfq")
        
        if data.empty:
            print(f"警告：{symbol_name} 数据为空")
            return None
            
        # 统一列名和数据格式
        data['日期'] = pd.to_datetime(data['日期'])
        data = data[['日期', '收盘']].copy()
        data.columns = ['date', symbol]
        data.set_index('date', inplace=True)
        data[symbol] = pd.to_numeric(data[symbol], errors='coerce')
        
        print(f"成功下载 {symbol_name}，数据量：{len(data)} 条")
        return data
        
    except Exception as e:
        print(f"下载 {symbol_name} 数据失败：{e}")
        return None


def calculate_returns(price_data, method='log'):
    """
    计算收益率
    
    Parameters:
    - price_data: 价格数据DataFrame
    - method: 计算方法，'log'为对数收益率，'simple'为简单收益率
    
    Returns:
    - DataFrame: 收益率数据
    """
    if method == 'log':
        returns = np.log(price_data / price_data.shift(1)).dropna()
    elif method == 'simple':
        returns = (price_data / price_data.shift(1) - 1).dropna()
    else:
        raise ValueError("method参数必须为'log'或'simple'")
    
    return returns


def descriptive_statistics(returns_data, annualize=True):
    """
    计算收益率的描述性统计
    
    Parameters:
    - returns_data: 收益率数据
    - annualize: 是否年化
    
    Returns:
    - DataFrame: 描述性统计结果
    """
    stats_dict = {}
    
    for col in returns_data.columns:
        series = returns_data[col].dropna()
        
        # 基本统计量
        mean_ret = series.mean()
        std_ret = series.std()
        
        if annualize:
            mean_ret *= 252  # 年化收益率
            std_ret *= np.sqrt(252)  # 年化波动率
        
        skewness = stats.skew(series)  # 偏度
        kurt = stats.kurtosis(series)  # 峰度
        
        # 正态性检验（Jarque-Bera检验）
        jb_stat, jb_pvalue = stats.jarque_bera(series)
        
        stats_dict[col] = {
            '收益率均值': mean_ret,
            '波动率': std_ret,
            '偏度': skewness,
            '峰度': kurt,
            'JB统计量': jb_stat,
            'JB_P值': jb_pvalue
        }
    
    return pd.DataFrame(stats_dict).T


def plot_timeseries(data, title="时间序列图", figsize=(12, 8), save_path=None):
    """
    绘制时间序列图
    
    Parameters:
    - data: 时间序列数据
    - title: 图表标题
    - figsize: 图片大小
    - save_path: 保存路径
    """
    plt.figure(figsize=figsize)
    
    if isinstance(data, pd.DataFrame):
        for col in data.columns:
            plt.plot(data.index, data[col], label=col, alpha=0.8)
        plt.legend()
    else:
        plt.plot(data.index, data.values, alpha=0.8)
    
    plt.title(title, fontsize=14)
    plt.xlabel('时间', fontsize=12)
    plt.ylabel('值', fontsize=12)
    plt.grid(True, alpha=0.3)
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
    
    plt.show()


def calculate_portfolio_metrics(returns_series, rf_rate, benchmark_returns=None):
    """
    计算投资组合绩效指标
    
    Parameters:
    - returns_series: 组合收益率序列
    - rf_rate: 无风险利率
    - benchmark_returns: 基准收益率序列
    
    Returns:
    - dict: 绩效指标字典
    """
    returns_series = returns_series.dropna()
    
    # 基本收益率统计
    annual_return = returns_series.mean() * 252
    annual_volatility = returns_series.std() * np.sqrt(252)
    
    # 夏普比率
    excess_return = annual_return - rf_rate
    sharpe_ratio = excess_return / annual_volatility if annual_volatility != 0 else 0
    
    # 最大回撤
    cumulative_returns = (1 + returns_series).cumprod()
    rolling_max = cumulative_returns.expanding().max()
    drawdown = (cumulative_returns - rolling_max) / rolling_max
    max_drawdown = drawdown.min()
    
    # 计算VaR (5%)
    var_5 = returns_series.quantile(0.05)
    
    metrics = {
        '年化收益率': annual_return,
        '年化波动率': annual_volatility,
        '夏普比率': sharpe_ratio,
        '最大回撤': max_drawdown,
        'VaR(5%)': var_5,
        '总收益率': cumulative_returns.iloc[-1] - 1,
        '观测天数': len(returns_series)
    }
    
    # 如果有基准，计算相对指标
    if benchmark_returns is not None:
        aligned_data = pd.concat([returns_series, benchmark_returns], axis=1).dropna()
        if not aligned_data.empty:
            portfolio_ret = aligned_data.iloc[:, 0]
            benchmark_ret = aligned_data.iloc[:, 1]
            
            # 信息比率
            excess_ret = portfolio_ret - benchmark_ret
            tracking_error = excess_ret.std() * np.sqrt(252)
            information_ratio = (excess_ret.mean() * 252) / tracking_error if tracking_error != 0 else 0
            
            metrics['跟踪误差'] = tracking_error
            metrics['信息比率'] = information_ratio
            metrics['年化超额收益'] = excess_ret.mean() * 252
    
    return metrics


def rolling_beta_estimation(stock_excess_returns, market_excess_returns, window=60):
    """
    计算滚动Beta系数
    
    Parameters:
    - stock_excess_returns: 股票超额收益率
    - market_excess_returns: 市场超额收益率
    - window: 滚动窗口大小（天数）
    
    Returns:
    - Series: 滚动Beta系数时间序列
    """
    # 对齐数据
    data = pd.concat([stock_excess_returns, market_excess_returns], axis=1).dropna()
    
    if len(data) < window:
        return pd.Series(dtype=float)
    
    rolling_betas = []
    dates = []
    
    for i in range(window, len(data) + 1):
        # 提取滚动窗口数据
        window_data = data.iloc[i-window:i]
        y = window_data.iloc[:, 0]  # 股票收益率
        x = window_data.iloc[:, 1]  # 市场收益率
        
        # 简单线性回归计算Beta
        if len(x) == window and x.var() > 0:
            beta = np.cov(y, x)[0, 1] / np.var(x)
            rolling_betas.append(beta)
            dates.append(data.index[i-1])
    
    return pd.Series(rolling_betas, index=dates)


def create_correlation_heatmap(corr_matrix, title="相关性热力图", figsize=(10, 8), save_path=None):
    """
    创建相关性热力图
    
    Parameters:
    - corr_matrix: 相关性矩阵
    - title: 图表标题
    - figsize: 图片大小
    - save_path: 保存路径
    """
    plt.figure(figsize=figsize)
    
    # 创建mask只显示下三角
    mask = np.triu(np.ones_like(corr_matrix, dtype=bool))
    
    sns.heatmap(corr_matrix, 
                annot=True, 
                cmap='RdYlBu_r', 
                center=0,
                fmt='.3f',
                square=True,
                mask=mask,
                cbar_kws={'shrink': 0.8})
    
    plt.title(title, fontsize=14)
    plt.tight_layout()
    
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches='tight')
    
    plt.show()


def portfolio_optimization(mean_returns, cov_matrix, rf_rate, method='min_vol'):
    """
    投资组合优化
    
    Parameters:
    - mean_returns: 期望收益率向量
    - cov_matrix: 协方差矩阵
    - rf_rate: 无风险利率
    - method: 优化目标，'min_vol'为最小方差，'max_sharpe'为最大夏普比率
    
    Returns:
    - dict: 优化结果字典
    """
    from scipy.optimize import minimize
    
    num_assets = len(mean_returns)
    
    def portfolio_performance(weights):
        portfolio_return = np.sum(mean_returns * weights)
        portfolio_volatility = np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))
        return portfolio_return, portfolio_volatility
    
    def portfolio_volatility(weights):
        return portfolio_performance(weights)[1]
    
    def negative_sharpe_ratio(weights):
        p_return, p_volatility = portfolio_performance(weights)
        return -(p_return - rf_rate) / p_volatility
    
    # 约束条件
    constraints = ({'type': 'eq', 'fun': lambda x: np.sum(x) - 1})
    bounds = tuple((0, 1) for _ in range(num_assets))
    initial_guess = np.array([1/num_assets] * num_assets)
    
    if method == 'min_vol':
        result = minimize(portfolio_volatility, initial_guess,
                         method='SLSQP', bounds=bounds, constraints=constraints)
    elif method == 'max_sharpe':
        result = minimize(negative_sharpe_ratio, initial_guess,
                         method='SLSQP', bounds=bounds, constraints=constraints)
    else:
        raise ValueError("method参数必须为'min_vol'或'max_sharpe'")
    
    optimal_weights = result.x
    optimal_return, optimal_volatility = portfolio_performance(optimal_weights)
    optimal_sharpe = (optimal_return - rf_rate) / optimal_volatility
    
    return {
        'weights': optimal_weights,
        'return': optimal_return,
        'volatility': optimal_volatility,
        'sharpe_ratio': optimal_sharpe,
        'success': result.success
    }


def monte_carlo_simulation(mean_returns, cov_matrix, rf_rate, num_simulations=10000):
    """
    蒙特卡洛模拟生成随机组合
    
    Parameters:
    - mean_returns: 期望收益率向量
    - cov_matrix: 协方差矩阵
    - rf_rate: 无风险利率
    - num_simulations: 模拟次数
    
    Returns:
    - array: 模拟结果矩阵 [收益率, 波动率, 夏普比率]
    """
    num_assets = len(mean_returns)
    results = np.zeros((3, num_simulations))
    
    for i in range(num_simulations):
        # 生成随机权重
        weights = np.random.random(num_assets)
        weights = weights / np.sum(weights)
        
        # 计算组合收益率和波动率
        portfolio_return = np.sum(mean_returns * weights)
        portfolio_vol = np.sqrt(np.dot(weights.T, np.dot(cov_matrix, weights)))
        
        # 计算夏普比率
        sharpe_ratio = (portfolio_return - rf_rate) / portfolio_vol
        
        # 存储结果
        results[0, i] = portfolio_return
        results[1, i] = portfolio_vol
        results[2, i] = sharpe_ratio
    
    return results
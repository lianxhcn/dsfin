"""
CAPM模型分析模块
包含Beta系数估计、模型诊断检验等功能
"""

import pandas as pd
import numpy as np
import statsmodels.api as sm
from statsmodels.stats.diagnostic import acorr_ljungbox, het_white
from statsmodels.stats.outliers_influence import variance_inflation_factor
from scipy import stats
import matplotlib.pyplot as plt
import warnings
warnings.filterwarnings('ignore')

class CAPMAnalyzer:
    """
    CAPM模型分析器
    """
    
    def __init__(self, rf_rate=0.025):
        """
        初始化CAPM分析器
        
        Parameters:
        - rf_rate: 年化无风险利率
        """
        self.rf_rate = rf_rate
        self.rf_daily = rf_rate / 252
        self.results = {}
    
    def estimate_capm(self, stock_returns, market_returns, stock_name="Stock"):
        """
        估计CAPM模型：r_i - r_f = alpha + beta * (r_m - r_f) + epsilon
        
        Parameters:
        - stock_returns: 股票收益率序列
        - market_returns: 市场收益率序列
        - stock_name: 股票名称
        
        Returns:
        - dict: 回归结果字典
        """
        # 计算超额收益率
        stock_excess = stock_returns - self.rf_daily
        market_excess = market_returns - self.rf_daily
        
        # 对齐数据并删除缺失值
        data = pd.concat([stock_excess, market_excess], axis=1).dropna()
        if data.empty:
            return None
        
        y = data.iloc[:, 0]  # 股票超额收益率
        X = data.iloc[:, 1]  # 市场超额收益率
        X = sm.add_constant(X)  # 添加常数项
        
        # OLS回归
        model = sm.OLS(y, X)
        fitted_model = model.fit()
        
        # 提取结果
        alpha = fitted_model.params[0]
        beta = fitted_model.params[1]
        alpha_se = fitted_model.bse[0]
        beta_se = fitted_model.bse[1]
        alpha_pvalue = fitted_model.pvalues[0]
        beta_pvalue = fitted_model.pvalues[1]
        r_squared = fitted_model.rsquared
        residuals = fitted_model.resid
        
        # 进行诊断检验
        diagnostic_tests = self._diagnostic_tests(residuals, X)
        
        result = {
            'stock_name': stock_name,
            'alpha': alpha,
            'alpha_se': alpha_se,
            'alpha_tstat': alpha / alpha_se if alpha_se != 0 else np.nan,
            'alpha_pvalue': alpha_pvalue,
            'beta': beta,
            'beta_se': beta_se,
            'beta_tstat': beta / beta_se if beta_se != 0 else np.nan,
            'beta_pvalue': beta_pvalue,
            'r_squared': r_squared,
            'observations': len(y),
            'residuals': residuals,
            'fitted_model': fitted_model,
            'diagnostic_tests': diagnostic_tests
        }
        
        self.results[stock_name] = result
        return result
    
    def _diagnostic_tests(self, residuals, X):
        """
        对回归残差进行诊断检验
        """
        tests = {}
        
        # Ljung-Box自相关检验（滞后10期）
        try:
            lb_result = acorr_ljungbox(residuals, lags=10, return_df=True)
            tests['ljung_box_stat'] = lb_result['lb_stat'].iloc[-1]
            tests['ljung_box_pvalue'] = lb_result['lb_pvalue'].iloc[-1]
        except:
            tests['ljung_box_stat'] = np.nan
            tests['ljung_box_pvalue'] = np.nan
        
        # White异方差检验
        try:
            white_result = het_white(residuals, X)
            tests['white_stat'] = white_result[0]
            tests['white_pvalue'] = white_result[1]
        except:
            tests['white_stat'] = np.nan
            tests['white_pvalue'] = np.nan
        
        # 正态性检验（Jarque-Bera）
        try:
            jb_stat, jb_pvalue = stats.jarque_bera(residuals.dropna())
            tests['jb_stat'] = jb_stat
            tests['jb_pvalue'] = jb_pvalue
        except:
            tests['jb_stat'] = np.nan
            tests['jb_pvalue'] = np.nan
        
        # Durbin-Watson检验
        try:
            from statsmodels.stats.diagnostic import durbin_watson
            dw_stat = durbin_watson(residuals)
            tests['durbin_watson'] = dw_stat
        except:
            tests['durbin_watson'] = np.nan
        
        return tests
    
    def estimate_rolling_beta(self, stock_returns, market_returns, window=60):
        """
        计算滚动Beta系数
        
        Parameters:
        - stock_returns: 股票收益率序列
        - market_returns: 市场收益率序列  
        - window: 滚动窗口大小
        
        Returns:
        - Series: 滚动Beta时间序列
        """
        stock_excess = stock_returns - self.rf_daily
        market_excess = market_returns - self.rf_daily
        
        # 对齐数据
        data = pd.concat([stock_excess, market_excess], axis=1).dropna()
        
        if len(data) < window:
            return pd.Series(dtype=float)
        
        rolling_betas = []
        rolling_alphas = []
        rolling_r2 = []
        dates = []
        
        for i in range(window, len(data) + 1):
            # 提取滚动窗口数据
            window_data = data.iloc[i-window:i]
            y = window_data.iloc[:, 0]  # 股票超额收益率
            x = window_data.iloc[:, 1]  # 市场超额收益率
            
            # 计算Beta和Alpha
            if len(x) == window and x.var() > 0:
                # 简单方法
                beta = np.cov(y, x)[0, 1] / np.var(x)
                alpha = y.mean() - beta * x.mean()
                
                # 更精确的OLS方法
                try:
                    X_with_const = sm.add_constant(x)
                    model = sm.OLS(y, X_with_const).fit()
                    alpha = model.params[0]
                    beta = model.params[1]
                    r2 = model.rsquared
                except:
                    r2 = np.corrcoef(y, x)[0, 1] ** 2
                
                rolling_betas.append(beta)
                rolling_alphas.append(alpha)
                rolling_r2.append(r2)
                dates.append(data.index[i-1])
        
        result_df = pd.DataFrame({
            'beta': rolling_betas,
            'alpha': rolling_alphas,
            'r_squared': rolling_r2
        }, index=dates)
        
        return result_df
    
    def yearly_analysis(self, stock_returns, market_returns, start_year=2019, end_year=2024):
        """
        分年度Beta分析
        
        Parameters:
        - stock_returns: 股票收益率序列
        - market_returns: 市场收益率序列
        - start_year: 开始年份
        - end_year: 结束年份
        
        Returns:
        - DataFrame: 分年度Beta结果
        """
        yearly_results = []
        
        for year in range(start_year, end_year + 1):
            # 筛选年度数据
            year_stock = stock_returns[stock_returns.index.year == year]
            year_market = market_returns[market_returns.index.year == year]
            
            if len(year_stock) < 100:  # 需要至少100个交易日
                continue
            
            # 计算年度Beta
            result = self.estimate_capm(year_stock, year_market, f"Year_{year}")
            
            if result:
                yearly_results.append({
                    'year': year,
                    'alpha': result['alpha'],
                    'beta': result['beta'],
                    'r_squared': result['r_squared'],
                    'alpha_pvalue': result['alpha_pvalue'],
                    'beta_pvalue': result['beta_pvalue'],
                    'observations': result['observations']
                })
        
        return pd.DataFrame(yearly_results)
    
    def create_summary_table(self, results_dict=None):
        """
        创建汇总表格
        
        Parameters:
        - results_dict: 结果字典，如果为None则使用self.results
        
        Returns:
        - DataFrame: 汇总表格
        """
        if results_dict is None:
            results_dict = self.results
        
        summary_data = []
        
        for stock_name, result in results_dict.items():
            diag_tests = result['diagnostic_tests']
            
            summary_data.append({
                '股票名称': stock_name,
                'Alpha': result['alpha'],
                'Alpha(t值)': result['alpha_tstat'],
                'Alpha(p值)': result['alpha_pvalue'],
                'Beta': result['beta'],
                'Beta(t值)': result['beta_tstat'],
                'Beta(p值)': result['beta_pvalue'],
                'R²': result['r_squared'],
                '观测数': result['observations'],
                'LB统计量': diag_tests['ljung_box_stat'],
                'LB(p值)': diag_tests['ljung_box_pvalue'],
                'White统计量': diag_tests['white_stat'],
                'White(p值)': diag_tests['white_pvalue'],
                'JB统计量': diag_tests['jb_stat'],
                'JB(p值)': diag_tests['jb_pvalue'],
                'DW统计量': diag_tests['durbin_watson']
            })
        
        return pd.DataFrame(summary_data)
    
    def plot_regression_diagnostics(self, stock_name, figsize=(15, 10), save_path=None):
        """
        绘制回归诊断图
        
        Parameters:
        - stock_name: 股票名称
        - figsize: 图片大小
        - save_path: 保存路径
        """
        if stock_name not in self.results:
            print(f"未找到{stock_name}的回归结果")
            return
        
        result = self.results[stock_name]
        fitted_model = result['fitted_model']
        residuals = result['residuals']
        
        fig, axes = plt.subplots(2, 2, figsize=figsize)
        fig.suptitle(f'{stock_name} CAPM回归诊断图', fontsize=16)
        
        # 1. 残差vs拟合值图
        fitted_values = fitted_model.fittedvalues
        axes[0, 0].scatter(fitted_values, residuals, alpha=0.6)
        axes[0, 0].axhline(y=0, color='red', linestyle='--')
        axes[0, 0].set_xlabel('拟合值')
        axes[0, 0].set_ylabel('残差')
        axes[0, 0].set_title('残差vs拟合值')
        axes[0, 0].grid(True, alpha=0.3)
        
        # 2. QQ图
        from statsmodels.graphics.gofplots import qqplot
        qqplot(residuals, line='s', ax=axes[0, 1])
        axes[0, 1].set_title('Q-Q图（正态性检验）')
        
        # 3. 残差直方图
        axes[1, 0].hist(residuals, bins=30, density=True, alpha=0.7, edgecolor='black')
        axes[1, 0].set_xlabel('残差值')
        axes[1, 0].set_ylabel('密度')
        axes[1, 0].set_title('残差分布直方图')
        axes[1, 0].grid(True, alpha=0.3)
        
        # 添加正态分布曲线
        x = np.linspace(residuals.min(), residuals.max(), 100)
        y = stats.norm.pdf(x, residuals.mean(), residuals.std())
        axes[1, 0].plot(x, y, 'r-', label='正态分布')
        axes[1, 0].legend()
        
        # 4. 残差时序图
        axes[1, 1].plot(residuals.index, residuals.values, alpha=0.7)
        axes[1, 1].axhline(y=0, color='red', linestyle='--')
        axes[1, 1].set_xlabel('时间')
        axes[1, 1].set_ylabel('残差')
        axes[1, 1].set_title('残差时序图')
        axes[1, 1].grid(True, alpha=0.3)
        
        plt.tight_layout()
        
        if save_path:
            plt.savefig(save_path, dpi=300, bbox_inches='tight')
        
        plt.show()
        
        # 打印诊断检验结果
        diag_tests = result['diagnostic_tests']
        print(f"\n=== {stock_name} 诊断检验结果 ===")
        print(f"Ljung-Box自相关检验: 统计量={diag_tests['ljung_box_stat']:.4f}, p值={diag_tests['ljung_box_pvalue']:.4f}")
        print(f"White异方差检验: 统计量={diag_tests['white_stat']:.4f}, p值={diag_tests['white_pvalue']:.4f}")
        print(f"Jarque-Bera正态性检验: 统计量={diag_tests['jb_stat']:.4f}, p值={diag_tests['jb_pvalue']:.4f}")
        print(f"Durbin-Watson检验: 统计量={diag_tests['durbin_watson']:.4f}")
    
    def interpret_beta(self, beta_value):
        """
        解释Beta系数的含义
        
        Parameters:
        - beta_value: Beta系数值
        
        Returns:
        - str: Beta解释
        """
        if beta_value > 1.5:
            return "高Beta股票（高风险高弹性）"
        elif beta_value > 1.2:
            return "积极型股票（较高风险）"
        elif beta_value > 0.8:
            return "中等风险股票"
        elif beta_value > 0.5:
            return "防御型股票（较低风险）"
        elif beta_value > 0:
            return "低Beta股票（低风险）"
        else:
            return "负Beta股票（对冲特征）"
    
    def portfolio_beta(self, individual_betas, weights):
        """
        计算投资组合Beta系数
        
        Parameters:
        - individual_betas: 个股Beta系数列表
        - weights: 权重列表
        
        Returns:
        - float: 组合Beta系数
        """
        return np.sum(np.array(individual_betas) * np.array(weights))
    
    def beta_stability_analysis(self, rolling_beta_series):
        """
        分析Beta的稳定性
        
        Parameters:
        - rolling_beta_series: 滚动Beta时间序列
        
        Returns:
        - dict: 稳定性指标字典
        """
        return {
            '平均Beta': rolling_beta_series.mean(),
            'Beta标准差': rolling_beta_series.std(),
            '变异系数': rolling_beta_series.std() / abs(rolling_beta_series.mean()) if rolling_beta_series.mean() != 0 else np.nan,
            '最小Beta': rolling_beta_series.min(),
            '最大Beta': rolling_beta_series.max(),
            'Beta范围': rolling_beta_series.max() - rolling_beta_series.min(),
            '稳定性评级': self._stability_rating(rolling_beta_series.std() / abs(rolling_beta_series.mean()) if rolling_beta_series.mean() != 0 else np.inf)
        }
    
    def _stability_rating(self, cv):
        """
        根据变异系数评定稳定性等级
        """
        if cv < 0.1:
            return "非常稳定"
        elif cv < 0.2:
            return "稳定"
        elif cv < 0.3:
            return "中等"
        elif cv < 0.5:
            return "不稳定"
        else:
            return "极不稳定"
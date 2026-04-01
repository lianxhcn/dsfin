from pathlib import Path
from datetime import datetime

base = Path('g:/dsfin-G/Lecture/data_manage')
dirs = [
    'data_raw/stock_daily',
    'data_raw/index_daily',
    'data_raw/macro_monthly',
    'data_raw/fin_annual',
]
for d in dirs:
    (base / d).mkdir(parents=True, exist_ok=True)

print('目录创建完成：')
for d in sorted(base.rglob('*')):
    if d.is_dir():
        print(f'  {d.relative_to(base)}/')

# 写入初始下载日志
log_path = base / 'data_raw/download_log.txt'
with open(log_path, 'w', encoding='utf-8') as f:
    f.write('下载日志\n')
    f.write(f'创建时间：{datetime.now().strftime("%Y-%m-%d %H:%M:%S")}\n')
    f.write('=' * 60 + '\n\n')
print(f'日志文件已创建：{log_path}')

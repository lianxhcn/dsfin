import baostock as bs
lg = bs.login()
rs = bs.query_history_k_data_plus('sh.000300','date,open,high,low,close,volume,amount,pctChg',start_date='2020-01-01',end_date='2020-01-10',frequency='d')
data=[]
while rs.error_code=='0' and rs.next():data.append(rs.get_row_data())
bs.logout()
print('rows:', len(data))
if data: print(data[0])

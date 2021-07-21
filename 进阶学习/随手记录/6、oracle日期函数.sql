trunc()、 to_char()、 to_date() 方法的使用。

1、trunc():

	--获取当前时间 [返回：2021-06-22 14:37:22]
	select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')from dual;

	--sysdate : 2021-06-22 14:37:22

	--返回当前年月日 [返回：2021/6/22]
	select trunc(sysdate) from dual;
	--返回本年度第一天 [返回：2021/1/1]
	select trunc(sysdate, 'yyyy') from dual;
	--返回本季度第一天 [返回：2021/4/1]
	select trunc(sysdate, 'q') from dual;
	--返回本月的第一天 [返回：2021/6/1]
	select trunc(sysdate, 'month') from dual;
	--返回 空  
	select trunc(sysdate, '') from dual;
	--返回上周日的日期
	select trunc(sysdate, 'day') from dual;
	select trunc(sysdate, 'd') from dual;


	--返回当前年月日 时分秒 [返回：2021-06-22 00:00:00]
	--因为trunc(sysdate) 已经把时分秒给截取掉了，所以to_char()后得到的是
	--没有时分秒的，自然填充 00：00：00
	select to_char(trunc(sysdate), 'yyyy-mm-dd hh24:mi:ss') from dual;


2、to_char():  --将日期格式转为字符串格式
	--SQL中不区分大小写，  MM和mm认为是相同的格式   
	select to_char(sysdate, 'YYYY-mm-dd hh24:mi:ss') from dual;

	select to_char(sysdate, 'yyyy-MM-dd hh24:MI:ss') from dual;

	select to_char(sysdate, 'yyyy-mm-DD hh24:mI:SS') from dual;
	--如上三条语句，中有大写有小写，但是返回的结果都为：2021-06-22 14:51:06

	--针对时分秒的格式：
	--格式一： 以24H制返回 小时  [返回：2021-06-22 14:51:06]
	select to_char(sysdate, 'yyyy-mm-DD hh24:mI:SS') from dual;
	--格式二： 以12H制返回 小时  [返回：2021-06-22 02:52:55]
	select to_char(sysdate, 'yyyy-mm-dd hh:mi:ss') from dual;
	
	--截取 sysdate中的 年  [返回：2021]
	select to_char(sysdate, 'yyyy') from  dual;
	--截取 sysdate中的 月  [返回：06]
	select to_char(sysdate, 'mm') from  dual;
	--截取 sysdate中的 日  [返回：22]
	select to_char(sysdate, 'dd') from  dual;
	--截取 sysdate中的 时  [返回：15]
	select to_char(sysdate, 'hh24') from  dual;
	--截取 sysdate中的 时  [返回：03]
	select to_char(sysdate, 'hh') from  dual;
	--截取 sysdate中的 分  [返回：02]
	select to_char(sysdate, 'mi') from  dual;
	--截取 sysdate中的 秒  [返回：52]
	select to_char(sysdate, 'ss') from  dual;
	
	--返回当前日期是第几季度  [返回：2， 表明6月是第2季度]
	select to_char(sysdate, 'q') from dual;

	--返回当前是星期几
	select to_char(sysdate, 'day') from  dual;
	--返回 2021/1/1 - 2020/1/1 之间相差的天数，大减小为正数， 小减大为负数
	select floor(date'2021-01-01' - date'2020-01-01') from dual;
	
3、to_date(): --将字符串格式转为日期格式
	--返回 日期：2021/3/2
	select to_date('20210302', 'yyyy-mm-dd') from dual;
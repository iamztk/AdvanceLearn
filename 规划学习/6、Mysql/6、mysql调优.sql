1、MyISAM查找数据时底层的执行流程：
	select * from t where t.name = 'a';
	1、先看查询条件name是否为索引，如果不是，则全表扫描
	2、如果是索引，则去MYI文件中查找对应的索引值，这个值就是数据存放的地址值
	3、根据这个地址值，去MYD文件中查找数据。
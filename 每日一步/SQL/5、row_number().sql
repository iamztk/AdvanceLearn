row_number() over partition by 分组聚合

就是先分组，在排序，可以的话顺手标个排名

如果不想分组也可以排名，
	row_number() over( partition by col1 order by col2):
		表示根据col1分组，在分组内部根据col2排序
			该排序针对的是同组中的数据。
			
	例如：
select row_number() over(partition by t.wageno, t.agentnum, t.citycode, t.wagepooltype 
					order by t.makedate desc, t.maketime desc) last
		, t.wageno, t.agentnum, t.citycode, t.wagepooltype 
 from BAWAGEPOOLRECORD t where t.agentcode = 'BSAXA00034' and t.wageno = '202107' and t.wagepooltype = '01'
 and last = 1;
 
 
如上：在表BaWagePoolRecord中，先根据 wageno、agentnum、 citycode、 wagepooltype 分组
	再魅族中根据makedate进行倒序排序，每组会得到对应的编号 1，2，3，4，5等
last	
 1	 202107	XAD170014	SAXA	01
 2	 202107	XAD170014	SAXA	01
 3	 202107	XAD170014	SAXA	01
 4	 202107	XAD170014	SAXA	01
 5	 202107	XAD170014	SAXA	01

 得到的数据如上：
		表BAWAGEPOOLRECORD t 中根据条件t.agentcode = 'BSAXA00034' and t.wageno = '202107' and t.wagepooltype = '01'
	可以获取多条主键一样的数据，但是只取最新的那一条数据，就可以使用这个分组后排序的方法.
	最后获取last = 1 的那条最新的数据。
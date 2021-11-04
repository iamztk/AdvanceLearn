Redis特殊数据类型 -bitmap --位存储

1、使用场景：  只有两种状态的，可以用0 和 1 进行表示的，都可以使用该类型


2、常用命令：
	1、setbit key offset value  --设置key的offset 的值  例如如下给sign用户设置周一到周日的考勤数据， 0：未打卡 1：打卡
	2、get bit key offset   --得到key的某个具体的值
	3、bitcount key   --得到key中value = 1 的值的数量   统计一周的打卡次数
	
		127.0.0.1:6379> setbit sign 1 1
		(integer) 0
		127.0.0.1:6379> getbit sign 1
		(integer) 1
		127.0.0.1:6379> setbit sign 2 1
		(integer) 0
		127.0.0.1:6379> setbit sign 2 1
		(integer) 1
		127.0.0.1:6379> setbit sign 3 1
		(integer) 0
		127.0.0.1:6379> setbit sign 4 1
		(integer) 0
		127.0.0.1:6379> setbit sign 5 1
		(integer) 0
		127.0.0.1:6379> setbit sign 6 0
		(integer) 0
		127.0.0.1:6379> setbit sign 7 0
		(integer) 0
		127.0.0.1:6379> getbit sign 5
		(integer) 1
		127.0.0.1:6379> bitcount sign
		(integer) 5
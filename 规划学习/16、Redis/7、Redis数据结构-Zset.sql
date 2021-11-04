Redis基本类型之 Zset  --有序集合，可以进行排序操作
1、基本命令
	1、zadd key score member  --给key的score位置添加元素member  score：计数位
	   zrange key 0 -1 --查看所有元素
	   zrangebyscore key min max [withscores]  --对key进行从小大的排序
	   zrevrange key max min [withscores] --对key进行从大到小的排序
		127.0.0.1:6379> keys *
		(empty list or set)
		127.0.0.1:6379> zadd mykey 2500 xiaohong  --给mykey的2500的位置添加元素小红
		(integer) 1
		127.0.0.1:6379> zadd mykey 2000 xiaozhang
		(integer) 1
		127.0.0.1:6379> zadd mykey 1500 xiaocong
		(integer) 1
		127.0.0.1:6379> zrange mykey 0 -1  --获取mykey的所有的元素
		1) "xiaocong"
		2) "xiaozhang"
		3) "xiaohong"
		127.0.0.1:6379> zrangebyscore mykey 0 -1
		(empty list or set)
		127.0.0.1:6379> zrangebyscore mykey -inf +inf  --按score进行排序， -inf（负无穷大） +inf（正无穷大） 即从小到大排序
		1) "xiaocong"
		2) "xiaozhang"
		3) "xiaohong"
		127.0.0.1:6379> zrangebyscore mykey 0 2500 withscores【表明需要将数据打印】  --获取0到2500的mykey进行从小到大的排序，并答应
		1) "xiaocong"
		2) "1500"
		3) "xiaozhang"
		4) "2000"
		5) "xiaohong"
		6) "2500"
		127.0.0.1:6379> zrevrange mykey 0 -1 withscores --从大到小排序
		1) "xiaozhang"
		2) "2000"
		3) "xiaocong"
		4) "1500"
		127.0.0.1:6379>
	
		
	2、zrem key member --移除key中的某个元素	   
		127.0.0.1:6379> zrangebyscore mykey 0 2500 withscores
		1) "xiaocong"
		2) "1500"
		3) "xiaozhang"
		4) "2000"
		5) "xiaohong"
		6) "2500"
		127.0.0.1:6379> zrem mykey xiaohong
		(integer) 1
		127.0.0.1:6379> zrange mykey 0 -1
		1) "xiaocong"
		2) "xiaozhang"
		127.0.0.1:6379>  
		
	3、zcard key  --查看key中的元素个数
	   zcount key min max --查看指定区间范围内的元素个数
		127.0.0.1:6379> zadd mykey 1 hello
		(integer) 1
		127.0.0.1:6379> zadd mykey 2 world
		(integer) 1
		127.0.0.1:6379> zadd mykey 3 java
		(integer) 1
		127.0.0.1:6379> zcard mykey
		(integer) 3
		127.0.0.1:6379> zcount mykey 1 2
		(integer) 2						
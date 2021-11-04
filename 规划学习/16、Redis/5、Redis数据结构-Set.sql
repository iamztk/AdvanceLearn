Redis基本类型之Set（集合） --元素无序不重复
常用命令：
	1、sadd key value [value ...] ([value ...] 表示添加时，可以添加多个 例如： madd name k1 k2 k3)  添加元素
	   smembers key    查看该key中的所有元素
	   sismember key value  查看该key中是否存在该value
			127.0.0.1:6379> sadd name ztk
			(integer) 1
			127.0.0.1:6379> sadd age 18
			(integer) 1
			127.0.0.1:6379> sadd name k1 k2 k3 --可以add多个值，添加的值是没有顺序的
			(integer) 3
			127.0.0.1:6379> smembers name
			1) "k3"
			2) "ztk"
			3) "k2"
			4) "k1"
			127.0.0.1:6379> sismember name ztk
			(integer) 1
			127.0.0.1:6379> sismember name k6
			(integer) 0
			127.0.0.1:6379> sadd name ztk --set集合中的元素是无序且不重复的，添加重复元素，返回0，添加失败
			(integer) 0
			
	2、 scard key   查看key中的元素
		srem key value [value ...] 移除key中的一个或者多个元素
			127.0.0.1:6379> scard name
			(integer) 4
			127.0.0.1:6379> smembers name
			1) "k3"
			2) "ztk"
			3) "k2"
			4) "k1"
			127.0.0.1:6379> srem name k1 k2 k4
			(integer) 2
			127.0.0.1:6379> smembers name
			1) "k3"
			2) "ztk"

	3、srandmember key [count]  --获取key中的随机某个元素（srandmember key  2 获取key中随机的2个元素）
		127.0.0.1:6379> sadd name k1 k2 k3 k4 k5 k6 k7
		(integer) 6
		127.0.0.1:6379> smembers name
		1) "k3"
		2) "k7"
		3) "k6"
		4) "k5"
		5) "k4"
		6) "ztk"
		7) "k2"
		8) "k1"
		127.0.0.1:6379> srandmember name --获取随机的一个值
		"k6"
		127.0.0.1:6379> srandmember name
		"ztk" 
		
	4、spop key ： 随机删除元素
		127.0.0.1:6379> smembers name
		1) "k3"
		2) "k7"
		3) "k6"
		4) "k5"
		5) "k4"
		6) "ztk"
		7) "k2"
		8) "k1"
		127.0.0.1:6379> spop name
		"k7"
		127.0.0.1:6379> spop name
		"k1"
		127.0.0.1:6379> smembers name
		1) "k3"
		2) "k6"
		3) "k5"
		4) "k4"
		5) "ztk"
		6) "k2" 

	5、sdiff    差集
	   sinter   交集
	   sunion   并集
		127.0.0.1:6379> keys *
		(empty list or set)
		127.0.0.1:6379> sadd set1 a b c d
		(integer) 4		
		127.0.0.1:6379> sadd set2 c d e f
		(integer) 4
		127.0.0.1:6379> sdiff set1 set2 --set1 和 set2 的差集，返回的set1中的差集 ，以set1为主
		1) "b"
		2) "a"
		127.0.0.1:6379> sinter set1 set2 --返回set1 和 set2的交集  返回的事set1 和 set2相同的数据
		1) "c"
		2) "d"
		127.0.0.1:6379> sunion set1 set2  --返回set 和set2 的并集  返回的是set1 和 set2合并去重后的所有的数据
		1) "a"
		2) "c"
		3) "b"
		4) "f"
		5) "d"
		6) "e"

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
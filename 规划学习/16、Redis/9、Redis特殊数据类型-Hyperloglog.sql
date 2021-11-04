Redis特殊数据类型 - Hyperloglog  --基数统计的算法

1、基数是啥？--基数： 不重复的数  
	A {1,2,3,6,5,4,3} --它的基数为：6
	B {1,2,3,4,5,6,7} --它的基数为：7
	
2、Hyperloglog常用命令：
	1、pfadd key value  --添加元素
	2、pfcount key  --查看该key有多少个元素
	3、pfmerge key3 key1 key2 --将key1 和  key2取并集，赋值给key3
	127.0.0.1:6379> pfadd key1 abc, bca hdd, ggg, aaa, bbb
	(integer) 1
	127.0.0.1:6379> pfadd key2 aaa, bbb ccc ddd eee fff
	(integer) 1
	127.0.0.1:6379> pfcount key1
	(integer) 6
	127.0.0.1:6379> pfcount key2
	(integer) 6
	127.0.0.1:6379> pfmerge key3 key1 key2
	OK
	127.0.0.1:6379> pfcount key3
	(integer) 10
	
	该操作会存在一定的错误率，据不完全统计，错误率在0.81%左右！类似于统计网站的访问量，该容错是可以允许的。
	
	如果可以允许有容错，则使用hoperloglog是非常合适的！
	如果不允许容错，则可以使用set集合或者自己定义的基数方法。
	
	使用Hyperloglog的优点：
		占用的内存时固定的，2^64个不同元素的基数，也只需要占用12kb的内存。如果从内存角度Hyperloglog是首选的。
	缺点：
		会有一定的容错
		
		
	使用set之类的：
		优点：
			准确
		缺点：使用set会存储数据，占用内存较多，并且只是简单的获取网点的访问量，并不需要保存访问人的id之类的数据。
		


 
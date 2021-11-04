1、Redis有16个数据库， 默认使用的第0个， 可以通过 select 3 语句进行修改
	windows 下 打开redis客户端  redis-cli
	运行命令:
		select 3  则切换到了第四个数据库
		
		1、dbsize： 查看存储的数量 --查看当前数据库存储的数量
		没有数据存储则是： （integer）0
		
		2、set name ztk  设置数据后，再次进行查询，可得：
		dbsize
		 结果： (integer) 1
		 
		3、get name  获取key为name的值
		
		4、keys *  获取所有的key
		
		5、flushall  清空所有的库的key
		   flushdb   清空当前库所有的key
		   
		6、 exists name  判断name这个key是否存在
			存在则返回： （Integer）1
			不存在则返回：(Integer) 0
			
			127.0.0.1:6379> mset k1 v1 k2 v2  --设置 k1 k2
			OK
			127.0.0.1:6379> mget k1 k2  --获取k1 k2的值
			1) "v1"
			2) "v2"
			127.0.0.1:6379> exists k1 k2 name --判断 k1 k2 name是否存在
			(integer) 3		--存在几个则返回几
			127.0.0.1:6379> exists k1 k2 k3
			(integer) 2
			
		7、移动： move name 1  将该数据库中的key=name的数据移动到1号数据库中，移动以后，原数据库中就
	不存在该key值了。
	
		8、设置过期时间：
			expire key 设置多久以后过期，默认单位为s
			例如：
				expire name 1
				key为name的数据，在一秒钟后会过期，过期数据则会被删除，被删除以后在此进行get name 会返回-2
			ttl name  可以查看该key的剩余时间
				--返回-1， 则说明没有设置过期时间
				--返回-2， 则说明该key不存在
				注：当一个key设置了过期时间10s，通过ttl查看该key的剩余时间时，那么返回值有可能是-1，因为是从10递减到-2的，切记
			
		9、查看数据的类型：
			type key 
			例如： type name  ==> string
			
		--对于所有类型都通用的命令：
			keys *  		查看所有key
			exists key 		判断key是否存在
			move key 1 		将key从当前库中移到1号库中
			expire key time 给key设置过期时间
			ttl key  		查看key的剩余存活时间				
			type key 		查看key的类型
		   
2、为什么Redis选择 6379 作为端口号？（明星效应）	

3、为什么Redis是单线程？
	Redis是很快的，官方表示，Redis是基于内存的操作，CPU不是Redis性能的瓶颈，Redis的瓶颈是根据机器的内存和
网络带宽，既然可以使用单线程来实现，就是用单线程了！所以就使用单线程了 --没明白为什么需要使用

	Redis是使用的C语言开发的，官方提供的数据为 10万+ 的QPS， 完全不比同样是使用key-value的Memacache差。
	--QPS:每秒查询率

	Redis使用单线程为什么还能这么快？
	1、误区1:高性能的服务器一定是多线程的？
	2、误区2：多线程（CPU上下文切换）一定单线程效率高！
	执行速度：CPU>内存>硬盘
	
	Redis是将所有的数据存放在内存当中，所以说使用单线程去操作效率就是最高的，多线程（会有CPU的上下文切换，
是一个耗时的操作！！！）对于内存系统来说，如果没有上下文切换效率就是最高的！多次读写都是在一个CPU上的，
在内存情况下，这个就是最佳的方案。



		
		
		
Redis的乐观锁：

1、悲观锁： 很悲观，认为什么时候都会出问题，无论做什么都会加锁！ synchronized

2、乐观锁：
	很乐观，认为什么时都不会出现问题，所以不会上锁！ 只会在更新数据的时候去判断一下，在此期间，是否有人对
修改过这个数据。  
	步骤：1、获取version
		  2、更新的时候比较这个version  --数据库的锁
		  
3、Redis实现乐观锁，是通过watch关键字进行监听。
	--客户端1，
	127.0.0.1:6379> set money 1000
	OK
	127.0.0.1:6379> get money 0
	(error) ERR wrong number of arguments for 'get' command
	127.0.0.1:6379> set out 0
	OK
	127.0.0.1:6379> watch money  --监听money
	OK
	127.0.0.1:6379> multi  --开启事务
	OK
	127.0.0.1:6379> decrby money 100
	QUEUED
	127.0.0.1:6379> incrby out 100 --1、客户端1执行完该命令，但不执行exec命令，即入队的命令暂时没有被执行
	QUEUED
	127.0.0.1:6379> exec  --执行命令  （在这里比较money是否有被修改，如果修改，则返回nil）
	(nil)  --3、待客户端2执行完修改后，再次执行客户端1的exec命令，跑完整个事务，结果返回nil，因为监听的watch发生了变化，所以
			--事务执行失败， 这就是Redis的乐观锁
	127.0.0.1:6379> unwatch  --解锁
	OK
	
	--客户端2 修改money的值
	127.0.0.1:6379> keys *
	1) "out"
	2) "money"
	127.0.0.1:6379> set money 1000  --2、在此处修改money的值
	OK
	127.0.0.1:6379> set out 0
	OK
	
	
	没有别的事务修改watch监听的字段，正常流程如下：
		127.0.0.1:6379> keys *
		1) "out"
		2) "money"
		127.0.0.1:6379> watch money
		OK
		127.0.0.1:6379> multi
		OK
		127.0.0.1:6379> decrby money 100
		QUEUED
		127.0.0.1:6379> incrby out 100
		QUEUED
		127.0.0.1:6379> exec
		1) (integer) 900
		2) (integer) 100
		127.0.0.1:6379> unwatch  --正常执行完需要解锁吗？  不需要，正常执行完只需要exec执行完队列中的命令即可
		OK
	
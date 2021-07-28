MYSQL共享锁、排他锁、悲观锁、乐观锁及其使用场景。
	
1、共享锁
	select... lock in share mode;

2、排他锁
	select... for update;
	默认的：
		insert、 update、 delete 都会加排他锁。
		
	普通的select * from table; 加锁也可以访问，不与锁冲突。

3、悲观锁
	使用了排他锁的数据，不允许其他事务进行更改该事务

4、乐观锁
	对于需要修改的数据会保存当前版本号之类的字段：
		update table set num=num-1 where id=10 and version=23
	更新如果失败则表示有其他事务修改了该内容，则需要重新更新，会尝试多次。
	
	悲观锁和乐观锁的区别：
		悲观锁上了排他锁，对于写比较合适。
		乐观锁对于写可能会有风险，存在失败的可能，更适用于读。
	
		读用乐观锁，写用悲观锁。
		
		高并发的情况下更适用乐观锁，但是乐观锁不解决脏读。


总结：
	1 要记住锁机制一定要在事务中才能生效，事务也就要基于MySQL InnoDB 引擎。
	2 访问量不大，不会造成压力时使用悲观锁，面对高并发的情况下，我们应该使用乐观锁。
	3 读取频繁时使用乐观锁，写入频繁时则使用悲观锁。还有一点：乐观锁不能解决脏读的问题。

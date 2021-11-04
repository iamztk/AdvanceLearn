Redis基本数据类型值-List

1、在Redis里面，我们可以将list用作栈、队列、阻塞队列

2、*注 所有的list命令都是用 "L" 开头的 （命令中大小写都可以）
	1、lpush  --将一个或者多个值，插入到列表中的头部，从左侧插入数据
		127.0.0.1:6379> keys *
		(empty list or set)
		127.0.0.1:6379> lpush list one two three
		(integer) 3
		127.0.0.1:6379> lrange list 0 -1 --lrange截取数据
		1) "three"
		2) "two"
		3) "one"
		--由上可看出，先加入one在取出时，排在最后
		
		rpush --将一个或者多个值，插入到列表的尾部，从右侧插入
		127.0.0.1:6379> rpush list rfour
		(integer) 4
		127.0.0.1:6379> lrange list 0 -1
		1) "three"
		2) "two"
		3) "one"
		4) "rfour"
		--取出时，rfour是在最后，即这个在队列的尾部
		
	2、移除操作：
		Lpop:从左边开始移除，移除掉第一个
		
		Rpop:从右边开始移除，移除掉第一个		
		127.0.0.1:6379> lrange list 0 -1
		1) "three"
		2) "two"
		3) "one"
		4) "rfour"
		127.0.0.1:6379> lpop list  --移除了最左边的three
		"three"
		127.0.0.1:6379> lrange list 0 10
		1) "two"
		2) "one"
		3) "rfour"
		127.0.0.1:6379> rpop list  --移除了最右边的rfour
		"rfour"
		127.0.0.1:6379> lrange list 0 -1
		1) "two"
		2) "one"

	3、获取具体下标位置的数据
		lindex key index
		例如：
		127.0.0.1:6379> lindex list 3
		(nil)
		127.0.0.1:6379> lindex list 0
		"two"
		
	4、llen： 获取列表的元素个数（或者说是列表的长度）
	   lrem: 移除掉列表中指定个数的具体的某个值  lrem key count value --列表中可以存放相同的数据
	    127.0.0.1:6379> lpush list one two three
		(integer) 3
		127.0.0.1:6379> llen list  --来获取list的长度
		(integer) 3
		127.0.0.1:6379> lrange list 0 -1
		1) "three"
		2) "two"
		3) "one"
		127.0.0.1:6379> lrem list 1 one --移除list中的一个 one元素  
		(integer) 1
		127.0.0.1:6379> lrange list 0 -1
		1) "three"
		2) "two"
		127.0.0.1:6379> lpush list two
		(integer) 3
		127.0.0.1:6379> lrange list 0 -1
		1) "two"
		2) "three"
		3) "two"
		127.0.0.1:6379> lrem list 1 two  --移除掉一个two元素，从上到下的移除  也可以  lrem list 2 two 移除掉2个two元素
		(integer) 1
		127.0.0.1:6379> lrange list 0 -1
		1) "three"
		2) "two"
		
	5、ltrim:截取指定数量的value --数据被修改
	   ltrim key start end
	   
	   127.0.0.1:6379> flushdb
		OK
		127.0.0.1:6379> lpush list k1 k2 k3 k4 k5
		(integer) 5
		127.0.0.1:6379> lrange list 0 -1
		1) "k5" --0
		2) "k4" --1
		3) "k3" --2
		4) "k2" --3
		5) "k1" --4
		127.0.0.1:6379> ltrim list 1 3 --截取第1个到第3个value值
		OK
		127.0.0.1:6379> lrange list 0 -1
		1) "k4"
		2) "k3"
		3) "k2"
	   
	6、rpoplpush: 移除列表中的最后一个（右边的那个）添加到另外一个列表中（lpush进，即在最左边）
		--元素的转移 
		127.0.0.1:6379> lrange list 0 -1
		1) "k4"
		2) "k3"
		3) "k2"
		127.0.0.1:6379> rpoplpush list otherlist
		"k2"
		127.0.0.1:6379> lrange list 0 -1
		1) "k4"
		2) "k3"
		127.0.0.1:6379> lrange otherlist 0 -1
		1) "k2"  
		
	7、exists list： 判断该列表是否存在
	   lset key index value: 给key列表的index下标设置value值（等价于更新操作，但是只能更新已存在的数据）
		127.0.0.1:6379> flushdb
		OK
		127.0.0.1:6379> exists list  --list列表是否存在
		(integer) 0    --不存在，则返回0
		127.0.0.1:6379> lset list 0 item --把list的0号位置的值更新为item
		(error) ERR no such key   --由于list列表不存在，所以更新失败
		127.0.0.1:6379> lpush list k1 k2 k3
		(integer) 3
		127.0.0.1:6379> lrange list 0 -1
		1) "k3"
		2) "k2"
		3) "k1"
		127.0.0.1:6379> exists list
		(integer) 1
		127.0.0.1:6379> lset list 0 item  --更新存在的数据，则能成功
		OK
		127.0.0.1:6379> lrange list 0 -1
		1) "item"
		2) "k2"
		3) "k1"
		127.0.0.1:6379>  
		
		
	8、linsert: 在列表的具体的value之前或之后添加某个值
		linsert list before k1 kk:
		在列表list的k1值之前添加一个kk值
		127.0.0.1:6379> lrange list 0 -1
		1) "item"
		2) "k2"
		3) "k1"		
		127.0.0.1:6379> linsert list before k1 kk --实例
		(integer) 4
		127.0.0.1:6379> lrange list 0 -1
		1) "item"
		2) "k2"
		3) "kk"
		4) "k1"
		
	总结：
		1、List实际上是一个链表，before Node after, 左右两边都可以插入数据
		2、如果key不存在，则新增链表
		3、如果key存在，则新增内容
		4、如果移除了所有的key，空链表，也代表不存在！
		5、在两边插入是效率最高的，在中间插入，效率会低一点
	可以用作消息排队， 消息队列（Lpush Rpop） 左边进，右边出，先进先出
						栈（Lpush Lpop) 左边进，左边出， 先进后出
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
Redis基本类型之String
1、常用命令：
	1、append 字符串追加
	set key1 v1
	append key1 hello -> get key1 (查询key1的值) ==>v1hello	（结果值）
	
	2、strlen key1  获取字符串(key1)长度  返回7
	
	3、incr 自增1
	   decr 自减1  仅限于数值
	   
	   incrby age 10  key为age的数据增加10
	   decrby age 10  key为age的数据减少10
	   
	4、getrange key  start end  截取key字符串，从start位置开始到end位置结束
		getrange key1 0 3 会截取前4个字符
		getrange key1 0 -1 不会截取，反而还会将该字符串打印出来
		--这个只是截取以后返回，并不会改变原有字符串
		例如：
			set name abcdefgh
			getrange name 0  5  ==> 返回：abcdef
			getrange name 0 -1  ==> 返回：abcdefgh(该操作不会修改原字符串)
			
	5、替换 setrange
		setrange key 从哪个位置开始（偏移量） 替换成什么值
		例如：
			set name abcdef
			setrange name 1 xx ==> axxdef  --注：这个是会改变原有的字符串
			--情况一：
			127.0.0.1:6379> keys *
			1) "name"
			127.0.0.1:6379> get name
			"ztk007"
			127.0.0.1:6379> setrange name 6 xxx  --ztk007 第6个已经没有了，但是通过setrange 以后能重新将值替换成新的值
												 --它业可以做字符串的拼接
			(integer) 9
			127.0.0.1:6379>
			127.0.0.1:6379> get name
			"ztk007xxx"
			--情况二：
			127.0.0.1:6379> set name ztk
			OK
			127.0.0.1:6379> setrange name 10 xxxx
			(integer) 14
			127.0.0.1:6379> get name
			"ztk\x00\x00\x00\x00\x00\x00\x00xxxx"  --没有的应该是空格吧
			127.0.0.1:6379>
			
	6、setex (set with expire) 新增key并设置过期时间
		--如果key不存在，则新增， 如果该key存在，则修改，并设置过期时间，如果以前存在过期时间，则更新该过期时间
		例如：
			set  name ztk
			设置过期时间： expire name 60
			在进行如下操作：
				setex name ztk007 200
			--重新设置name的值为ztk007,重新设置过期时间为200s

		
	   setnx (set not exists) 如果不存在，则新增 --如果存在，则不作任何操作
	   --该命令在分布式锁中很常用！！！！！！！！！！！！！
	   例如：
			set name ztk
			在进行setnx操作：
			setnx name ztk007 --不会生效，get name 的值还是ztk
			
	7、mset： 批量设置
		mset key value [key value ...]
		例如： mset k1 v1 k2 v2 k3 v3
	  
	   mget: 批量查询
		例如： mget k1 k2 k3
		
	   msetnx: 批量设置，--都不存在则设置成功，如果有一个或多个因为已经存在，而没有设置成功，则其他的都无法设置成功
	    例如： msetnx k1 v1 k4 v4
		==> 由于k1已经存在，所以该操作失败，没有成功，即k4是没有设置进去的。
		--该操作是原子性的
		
		实战应用：
			使用Redis存放对象
			user:1{name:zhangsan, age:3} 设置一个user:1 对象， 值为json字符来保存一个对象！
			
			在使用redis时，也可以这样：
			mset user:1:name zhangdan user:1:age 3
			127.0.0.1:6379> set user:1 {name:zhangsan, age:3}  --这样设置是不可以的
			(error) ERR syntax error		
			127.0.0.1:6379> set user:1 name:zhangsan,age:3  --可以这样设置该对象的值，但是不好获取
			OK
			127.0.0.1:6379> get user:1
			"name:zhangsan,age:3"
			127.0.0.1:6379> mset user:1:name zhangsan user:1:age 3 --可以这样区分设置 user:{id}:{field}
			OK
			127.0.0.1:6379> get user:1:name
			"zhangsan"
			127.0.0.1:6379> get user:1:age
			"3"
			
	8、getset  获取值并重新设置该值
			如果原值为nil(就是为null，不存在的意思)，则执行完后返回nil，但是会设置该key的值
			例如：
				getset name ztk
				如果库中不存在key为name的数据，则会返回nil，但是在此get name时，会返回ztk，即已经设置成功了
				--在此设置
				getset name ztk007 
				==>执行完后会返回原值，即ztk， 在此查询 get name 获得 ztk007
			127.0.0.1:6379> keys *
			(empty list or set)
			127.0.0.1:6379> getset name ztk
			(nil)
			127.0.0.1:6379> get name
			"ztk"
			127.0.0.1:6379> getset name ztk007
			"ztk"
			127.0.0.1:6379> get name
			"ztk007"
			127.0.0.1:6379>

			
	   
	
			
			
			
			
			
			
			
			
			
			
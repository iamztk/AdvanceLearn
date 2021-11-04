Redis基本类型之Hash
	--可以将Hash类型理解为 key-map 类型， 之前的string、list、set都是key-value类型
1、基本命令
	1、hset key field vlaue --在key中添加一个 field-value 字段	
	   hget key filed value --取出key中的field的value	
	   hmset key field value [field value ...] --批量设置	
	   hgetall key  --获取key中所有的元素
	    127.0.0.1:6379> flushdb
		OK
		127.0.0.1:6379> hset myhash key1 v1 --设置
		(integer) 1
		127.0.0.1:6379> hget myhash key1    --获取
		"v1"
		127.0.0.1:6379> hmset myhash key1 v2 key2 v3 key4  v4  --批量设置
		OK
		127.0.0.1:6379> hgetall myhash  --获取所有
		1) "key1"  --key
		2) "v2"	   --value  相当于map中的键值对
		3) "key2"
		4) "v3"
		5) "key4"
		6) "v4"
		
	2、hdel key field  --删除key中的field
	
	3、hlen key --查看key的长度
	
	4、hexists key field --判断key是否存在field
	
	5、hkeys key --获取key中所有的field
	   hvals key --获取key中所有的value
	   
	6、hincrby key field count --给key中的某个field自增count
	   hdecrby key field count --给key中的某个field减少count
	   
	7、hsetnx key field value  --给key设置field的value值
	   --如果该field在key中不存在，则设置成功，如果存在，则设置失败
	    127.0.0.1:6379> keys *
		(empty list or set)
		127.0.0.1:6379> hsetnx myhash field1 v1  --设置成功
		(integer) 1
		127.0.0.1:6379> hsetnx myhash field1 v2  --设置失败
		(integer) 0
		127.0.0.1:6379>  
		
	8、更加适合对象的存储
	   
	   
	   
	   
	   
	   
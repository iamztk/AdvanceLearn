Redis的发布和订阅

1、订阅
	subscribe 频道

2、发布
	publish 频道 "内容"
	
	在一个客户端进行订阅操作：
		127.0.0.1:6379> subscribe kuangshenshuo   --订阅了  kuangshenshuo  频道
		Reading messages... (press Ctrl-C to quit)
		1) "subscribe"   -- 订阅了
		2) "kuangshenshuo"  --kuangshenshuo 频道
		3) (integer) 1   --表示成功了
		1) "message"    --这是频道发布了消息
		2) "kuangshenshuo"  --这是频道名称
		3) "hello redis" 		--这是频道发布的消息
	
	发布操作：
		127.0.0.1:6379> publish kuangshenshuo "hello kuangshenshuo"  --这里在 kuangshenshuo 频道发布了消息
		(integer) 1
		127.0.0.1:6379> publish kuangshenshuo "hello redis"
		(integer) 1
		127.0.0.1:6379>


	3、使用场景：
		1、实时消息系统
		2、实时聊天
		3、订阅关注系统都是可以的
		
	其他稍微复杂的场景，就需要使用消息中间件MQ（kafka, rabbitMQ ...）
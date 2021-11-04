1、微服务的四个核心问题？
	1、服务很多，客户端该怎么访问？
	2、这么多服务，服务之间是如何通信的？
	3、这么多服务，是如何治理的？
	4、服务挂了怎么办？
	
2、解决方案
	Spring Cloud 
	
	1、Spring Cloud NetFlix  一站式解决方案！
		1、api网关  zuul组件
		2、服务通信：Feign  --基于http通信方式，同步、阻塞
		3、服务注册与发现  Eureka
		4、熔断机制 Hystrix
		...
		
	2、Apache Dubbo Zookeeper  半自动，需要整合别人的！
		1、api网关: 没有的，需要第三组件，或者自己开发
		2、服务通信：Dubbo  --基于RPC通信
		3、服务注册与发现 zookeeper
		4、熔断机制： 没有
		
	
	
	3、Spring Cloud Alibaba   一站式解决方案！更简单
	
	
学完本视频，需要解决一下常见面试题：
	1、什么是微服务？
	
	2、微服务指甲你是如何独立通讯的？
	
	3、SpringCloud和Dubbo有哪些区别？
	
	4、SpringBoot和SpringCloud，请你谈谈对他们的理解？
	
	5、什么是服务熔断？什么是服务降级？
	
	6、微服务的优缺点分别是什么？说下你在项目开发中遇到的坑。
	
	7、你所知道的微服务技术栈有哪些？请列举一二
	
	8、eureka和zookeeper都可以提供服务注册与发现的功能，说说两个区别？
		
	
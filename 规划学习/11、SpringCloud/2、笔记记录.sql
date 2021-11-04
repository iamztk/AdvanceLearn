1、CAP理论，一个分布式系统不可能同时满足：C(一致性)，A(可用性)，P(分区容错性)。
	其中P(分区容错性)是必须要保证的。所以只能在C和A中做抉择。
	Zookeeper保证的是CP
	Eureka保证的是AP。
	
	C(一致性)：数据的一致性，注册中心里面的数据不是最新的。
		例：某个服务宕机后，在注册中心不会立马停止服务，而是在一段时间后才会判断该服务已经
	宕机，从而停止该服务的注册。此时，如果注册中心还是可以访问该服务的，只是会访问不通。
	A(可用性)：注册服务的可用
	P(分区容错性)：分布式系统中，不可能因为某一个服务宕机，而导致整个服务不可用。
	
	
2、springboot的多配置文件
	原配置文件：application.properties
	多配置文件：
		application-eureka8761.properties
		application-eureka8762.properties
		
	程序启动，默认使用的是原配置文件。
	如果需要使用多配置文件中的配置，则需要修改启动类的Program Arguments的配置
	右键点击启动类，选择配置，然后修改配置中的程序参数（Program Arguments）为：
	--spring.profiles.active=eureka8762  eureka8762为application-eureka8762中-后面的名称
	如果所有的配置文件都需要被配置到，则需要多个启动类
		Application8761.java
		Application8762.java
		然后就可以启动了，注意，需要在配置文件中修改端口（server port）
		
	--目前所知的，该多配置文件应用在eureka的集群上
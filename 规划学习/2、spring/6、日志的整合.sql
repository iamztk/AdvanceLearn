1、Spring5整合日志
	1、在整个Spring5框架的代码基于Java8，运行时兼容java9,许多不建议使用的类
和方法在代码库中已经删除。
	
	2、Spring5.0框架自带了通用的日志封装。
		1、Spring5中移除了Log4ConfigListener, 官方建议使用Log4j2
		2、Spring5框架整合Log4j2
		第一步：引入jar包
			log4j-api, log4j-core, log4j-slf4j, slf4j
		第二步：创建log4j2.xml配置文件：
			文件名称就是这个，固定了，不能更改。
	
	

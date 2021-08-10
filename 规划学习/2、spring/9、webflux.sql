Spring5框架新功能（Webflux）
1、SpringWebflux介绍
	a、是Spring5中添加的新的模块，用于web开发，功能和SpringMVC类似，webflux使用
当前一种比较流行的响应式编程出现的框架。 (Reactive Stack)
	b、使用传统web框架，比如SpringMVC，这些基于servlet容器，而webflux
是一种异步非阻塞的框架，异步非阻塞的框架在Servlet3.1以后才支持，核心
是基于Reactor的相关API实现的。
	c、解释什么是异步非阻塞 ？
	异步和同步针对调用者：
		调用者发送请求后，如果等着对方回应之后才去做其他事情，就是同步。
		如果发送请求之后，不等着对方回应就去做其他事情，这就是异步
	
	阻塞和非阻塞针对调用者：
		被调用者收到请求后，做完请求任务之后，才给出反馈，就是阻塞。
		收到请求后，马上给出反馈，然后再去做事情就是非阻塞。
		
	d、webflux的特点
		第一非阻塞式：在有限的资源下，提高系统吞吐量和伸缩性，以Reactor为基础实现响应式编程。
		第二函数式变成：Spring5基于java8，webflux使用java8函数式变成方式实现路由请求。
		
		
SpringMVC 和 Spring webflux的区别：
	1、两个框架都可以使用注解方式，都运行在Tomcat等容器中。
	2、SpringMVC采用命令式编程，webflux采用异步响应式编程。


Webflux:使用场景：
	网关
	
2、响应式编程
	1、什么是响应式编程
		响应式编程是一种面向数据流和变化传播的编程范式，这意味着可以再编程语言中
	很方便地表达静态或动态的数据流，而相关的计算模型会自动将变化的值通过数据流进
	性传播。
		电子表格程序就是响应式编程的一个例子。单元格可以包含字面值或者类似"=B1+C1"
	的公式，而包含公式的单元格的值会依据其他单元格的值的变化而变化。
	
	2、java8及其之前版本
		提供的观察者模式两个类Observer  和 Observable
		java9之后就不再使用这两个类，而是使用Flow类。


3、响应式编程（Reactor实现）
	1、响应式编程操作中，Reactor是满足Reactive规范的框架。
	2、Reactor有两个核心类，Mono 和 Flux，这两个类实现接口Publisher，提供丰富操作
符。Flux对象实现发布者，返回N个元素；Mono实现发布者，返回0或者1个元素。
	3、Flux和Mono都是数据流的发布者，使用Flux和Mono都可以发出三种数据信号：
		元素值、错误信号、完成信号
	其中错误信号和完成信号都代表终止信号，终止信号用于告诉订阅者数据流结束了。
	错误信号终止数据流，同时把错误信息传递给订阅者。
	
4、代码演示
	1、新建Spring-boot项目
	2、添加依赖：
		<!-- https://mvnrepository.com/artifact/io.projectreactor/reactor-core -->
		<dependency>
			<groupId>io.projectreactor</groupId>
			<artifactId>reactor-core</artifactId>
			<version>3.3.12.RELEASE</version>
		</dependency>
	3、编程代码
		public class TestReactor_01 {
			public static void main(String[] args) {
				//添加元素
				Flux.just(1,2,3,4);
				Mono.just(1);
				
				---------注意：这样写是不会有响应（输出）的--
				需要调用方法：
					Flux.just(1,2,3,4).subscribe(system.out::println);
				---------

				//添加数组 必须是对象，基本数据类型则必须要用包装类
				Integer[] i = {1,2,3,4};
				Flux.fromArray(i);

				//添加集合
				List<Integer> list = Arrays.asList(1,2,3,4);
				Flux.fromIterable(list);

				//添加流
				Stream<Integer> stream = list.stream();
				Flux.fromStream(stream);
				//错误信号
				Flux.error(new Exception());
			}
		}
		
		4、三种信号的特点
			1、错误信号和完成信号都是终止信号，不能共存。
			2、如果没有发送任何元素值，而是直接发送错误或者完成信号，表示是空数据流
			3、如果没有错误信号，也没有完成信号，表示是无限数据流。


		5、调用just或者其他方法，只是声明了数据流，并没有发出，只有进行订阅之后才会触发
	数据流，不订阅什么都不会发生的。
			Flux.just(1,2,3,4).subscribe(system.out::println);
			
		6、操作符
			对流进行一道道操作，称为操作符，比如工厂流水线。
			1、map:元素映射为新元素
			
			2、flatMap：元素映射为流
				把每个元素转换流，把转换之后多个流合并大的流。
				
5、SpringWebFlux执行流程和核心API
	SpringWebFlux基于Reactor，默认使用容器是Netty，Netty是高性能的NIO框架，异步非阻塞的框架。
	1、Netty:
		传统使用：BIO(blocking I/O)： 同步并阻塞，服务器实现模式为一个连接一个线程，即客户端有连接请求时服务器端
	就需要启动一个线程进行处理，如果这个连接不做任何事情会造成不必要的线程开销，当然可以通过线程池机制改善。
		
		Netty使用：NIO(non-blocking I/O)： 同步非阻塞，服务器实现模式为一个请求一个线程，即客户端发送的连接请求
	都会注册到多路复用器上，多路复用器轮询到连接有I/O请求时才启动一个线程进行处理。
		
		AIO(NIO.2) (Asynchronous I/O) ： 异步非阻塞，服务器实现模式为一个有效请求一个线程，客户端的I/O请求都是
	由OS先完成了再通知服务器应用去启动线程进行处理，


	2、SpringWebFlux执行过程和SpringMVC相似：
		SpringWebFlux核心控制器DispatchHandler，实现接口WebHandler。
		接口WebHandler有一个方法：
			public interface WebHandler {
				Mono<Void> handle(ServerWebExchange var1);
			}
			--其实现类DispatcherHandlerd:
			public Mono<Void> handle(ServerWebExchange exchange) { [ServerWebExchange:放的是Http请求响应信息，例如参数等]
				return this.handlerMappings == null ? this.createNotFoundError() : Flux.fromIterable(this.handlerMappings).concatMap((mapping) -> {
					return mapping.getHandler(exchange); --根据请求地址获取对应的Mapping
				}).next().switchIfEmpty(this.createNotFoundError()).flatMap((handler) -> {
					return this.invokeHandler(exchange, handler);--调用具体业务方法
				}).flatMap((result) -> {
					return this.handleResult(exchange, result); --处理结果返回
				});
			}
	
	3、SpringWebFlux里面的DispatcherHandler，负责请求的处理
		HandlerMapping：根据请求查询到处理的方法
		HandlerAdapter：真正负责请求处理
		HandlerResultHandler：响应结果处理
	
	4、SpringWebFlux实现函数是编程，两个接口：
		RouterFunction：路由处理
		HandlerFunction：处理函数
	
6、SpringWebFlux(基于注解编程模型)
	SpringWebFlux实现方式有两种：注解变成模型和函数式编程模型
	使用SpringBoot进行编程：
		SpringBoot自动配置相关运行容器，默认情况下使用Netty服务器。
	
	第一步：创建SpringBoot工程，引入webFlux依赖。
		<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>
	
	第二步：配置启动端口号
		在application.properties中配置：
			server.port=8081

















		
	
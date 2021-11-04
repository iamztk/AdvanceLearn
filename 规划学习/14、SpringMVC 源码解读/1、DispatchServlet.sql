1、DispatchServlet是SpringMVC中最重要的一个拦截器。通过它，实现路由的链接。

2、一个spring项目，一定会有web.xml配置文件，配置如下：
	<web-app>
		<listener>
			<listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
			--因为这个配置中含有ClassPathXmlApplicationContext这个，会隐式的完成初始化操作
		</listener>
		<context-param>
			<param-name>contextConfigLocation</param-name>
			<param-value>/WEB-INF/app-context.xml</param-value>
		</context-param>
		<servlet>
			<servlet-name>app</servlet-name>
			<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
			<init-param>
				<param-name>contextConfigLocation</param-name>
				<param-value></param-value>
			</init-param>
			<load-on-startup>1</load-on-startup>
		</servlet>
		<servlet-mapping>
			<servlet-name>app</servlet-name>
			<url-pattern>/app/*</url-pattern>  */
		</servlet-mapping>
	</web-app>
	
	该xml配置可以通过代码来进行实现，即不需要进行xml的配置文件，可以通过代码方式实现该配置，代码如下：
	public class MyWebApplicationInitializer implements WebApplicationInitializer {
		@Override
		public void onStartup(ServletContext servletContext) {
			--servletContext: web容器的上下文，保存了web容器中的所有的信息
			--以前如果注册一个web组件：filter、servlet、listener等都是web组件，需要在web.xml中进行配置
			--其实servletContext也可以实现web组件的注册，例如下面代码中的：servletContext.addServlet() 就是在注册一个servlet


			--用java注解的方式，去初始化Spring的上下文环境
			--为什么spring项目并没有使用这个代码进行初始化呢？答案见答案一(在上面的xml配置代码中)
			--这个是通过annotation方式来初始化
			--也可以是通过xml的方式进行初始化；ClassPathXmlApplicationContext
			AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
			context.register(AppConfig.class);

			// Create and register the DispatcherServlet
			DispatcherServlet servlet = new DispatcherServlet(context);
			ServletRegistration.Dynamic registration = servletContext.addServlet("app", servlet);
			registration.setLoadOnStartup(1);
			registration.addMapping("/app/*");
		}
	}
	通过编写类MyWebApplicationInitializer去实现WebApplicationInitializer接口，重写onStartup方法，来达到与web.xml一样的效果。
	在这个方法是由web容器来进行调用的，什么是web容器：例如tomcat等就是web容器
	
	
	
2、springMVC核心功能:请求分发，主要就是通过DispatchServlet实现。
		通过DispatchServlet拦截请求，在分发到对应的controller上去。
		

3、Spring MVC找controller的流程：
		1、扫描整个项目（Spring 已经做了，在项目启动的时候），并定义一个Map集合
		2、拿到所有加了@Controller注解的类
		3、遍历类里面所有的方法对象
		4、判断方法是否加了@RequestMapping注解
		5、把@RequestMapping注解的value作为Map集合的key，把方法对象作为Map的value；
			map.put(key,value);
		6、根据用户的请求，拿到请求中的URI
				URL：http://localhost:8080/hello/getHello
				UTI: /hello/getHello
		7、使用请求的uri作为map的key，去map里面get，看看是否会有返回值。
		。。。
		
		

4、Controller的定义：
	2种定义，3种实现
	2中定义：1)、BeanName类型
			 2)、@Controller
		--体现在HandlerMapping上，因为有两种定义，所以又两个HandlerMapping进行解析
			 
	3种实现：1)、实现HttpRequestHandler接口
			 2)、@Controller注解的类
			 3)、实现Controller接口
		--由于有3种实现，所以又3种适配器进行处理不同的定义方式。
		
4、适配器 Adapter
	1、AbstractHandlerMethodAdapter
		--基于@Controller进行适配， 因为@Controller是有@RequestMapping()
		public final boolean supports(Object handler) {
			return handler instanceof HandlerMethod && this.supportsInternal((HandlerMethod)handler);
		}

	2、HttpRequestHandlerAdapter
		--基于实现HttpRequestHandler接口的适配器
		public boolean supports(Object handler) {
			return handler instanceof HttpRequestHandler;
		}
		
	3、SimpleControllerHandlerAdapter
		--基于实现Controller接口的适配器
		 public boolean supports(Object handler) {
			return handler instanceof Controller;
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
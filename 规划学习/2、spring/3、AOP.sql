AOP概念

1、什么是AOP?
	1、面向切面编程，利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务
逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。
	
	2、通俗描述：不通过修改源代码的方式，在主干功能里面添加新功能。
	
2、AOP的底层原理：
	1、实现AOP是基于动态代理。
	
	2、而实现AOP的动态代理有两种：
		1、JDK动态代理：基于接口实现代理。
		2、CGLIB动态代理：基于代理类创建子类实现代理。
		
3、AOP术语：
	1、连接点：
		类中的那些方法可以被增强，那么这些方法就称为连接点
	
	2、切入点：
		实际被真正增强的方法，称为切入点。
	
	3、通知（增强）
		1、实际增强的逻辑部分成为通知（增强）。
			例如增加日志操作，则增加的日志就是通知（增强 ）
		
		2、通知有多种类型：
			1、前置通知
			2、后置通知
			3、环绕通知
			4、异常通知
			5、最终通知
	4、切面
		是一个具体的动作
		把通知应用到切入点的过程。
		我的理解：将需要加强的地方添加了加强的过程，就是切面
	
	5、切入点表达式：
		1、切入点表达式作用：知道对那个类里面的哪个方法进行增强。
		2、语法结构：
			execution([权限修饰符][返回类型][类全路径][方法名称]([参数列表]))
			
		举例：
			1、对com.itguigu.dao.BookDao类中的add方法做增强：
			execution(*com.it.guigu.BookDao.add(..));
			*:表示任意权限修饰符
			返回类型：可以省略
			..: 表示参数列表
			
			2、对com.itguigu.dao.BookDao类中的所有方法做增强：
			execution(*com.itguigu.dao.BookDao.*(..));
			
			3、对com.itguigu.dao包下所有的方法做增强
			execution(*com.itguigu.dao.*.*(..));
		
	6、实践
		1、在Spring的配置文件中，开启注解扫描
		需要添加名称空间：aop和context
		
		2、使用注解创建User和UserProxy对象
		
		3、在增强类上面添加注解@Aspect
		
		4、在Spring配置文件中开启生成代理对象。
		<aop:aspectj-autoproxy />
		
		5、在增强类的里面，在作为通知方法上面添加通知类型注解，
	使用切入点表达式配置：
		--表明在BookDao的add方法执行前，执行before（）方法
		@Before(value="execution(*com.itguigu.BookDao.add(..))")
		public void before(){		
			system.out.println("before ...");
		}
		
		其他的加强注解：
			@After:方法之后执行[最终通知，有异常也会执行通知]
			@AfterReturning:方法返回值之后执行[有异常不通知]【返回通知】
			@AfterThrowing
			@Around: 环绕通知
			
			@Around(value="...如上"
			public void around(ProceedingJoinPoint a){
				sout("环绕之前");
				a.proceed(); --被增强的方法
				--环绕着被增强的方法。
				sout("环绕之后");
			}
		
		代码展示：
			@Before(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public void before(){
				System.out.println("前置加强。。");
			}

			--有异常，该加强方法不执行
			@AfterReturning(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public void afterReturning(){
				System.out.println("返回值后加强。。");
			}
			
			--不论有没有异常，该加强方法都执行
			@After(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public void after(){
				System.out.println("后置加强。。。");
			}

			--需增强的add方法有异常才会执行该增强方法。
			@AfterThrowing(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public void afterThrowing(){
				System.out.println("有异常后加强。。");
			}
			
			--需加强的add()方法，无返回值，则可以这么些
			@Around(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public void around(ProceedingJoinPoint procee) throws Throwable {
				System.out.println("环绕之前。。");
				procee.proceed();
				System.out.println("环绕之后。。");
			}
			--如果需加强的add()方法，有返回值，则需这么写：
			--不然会报错：AopInvocationException
			@Around(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public Object around(ProceedingJoinPoint procee) throws Throwable {
				System.out.println("环绕之前。。");
				Object a = procee.proceed();
				System.out.println("环绕之后。。");
				return a;
			}
			
		---对于切入点的抽取:
			@Pointcut(value="execution(* com.itguigu.spring.aop.demo01.User.add(..))")
			public void pointDemo(){

			}

			@Before(value="pointDemo()")
			public void before(){
				System.out.println("UserProxy2前置加强。。");
			}
		
		--如果一个方法有多个增强类，如何设定增强类的优先级
			可以通过注解@Order(1), @Order(2) ...
			Order()中的数字越小优先级越高
		
		--完全注解方式，不再使用XML进行配置
			@Configuration
			@ComponentScan(basePackages = {"com.itguigu.spring.aop"})
			@EnableAspectJAutoProxy(proxyTargetClass = true)
			public class SpringConfig {
			}
			
	7、使用XML配置文件：
		
		    <bean id="user" class="com.itguigu.spring.aop.demo02.User"></bean>  --需增强类
			<bean id="userProxy3" class="com.itguigu.spring.aop.demo02.UserProxy3"></bean> 增强类

			<aop:config>
				<!--配置切入点-->
				<aop:pointcut id="p" expression="execution(* com.itguigu.spring.aop.demo02.User.add(..))" />
				<!--配置切面-->
				<aop:aspect ref="userProxy3">
					<aop:before method="before" pointcut-ref="p" />
				</aop:aspect>
			</aop:config>
			
		
		
		
		
		
		
		
		
		
		
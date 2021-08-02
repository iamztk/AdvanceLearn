IOC操作bean管理（基于注解）

1、Spring针对bean管理中创建对象提供注解：
	1、@Component
	2、@Service
	3、@Controller
	4、@Repository
    以上四个注解功能是一样的，都可以用来创建bean实例


2、基于注解实现对象的创建
	1、需引入AOP的依赖
		引入aop.jar。
	
	2、代码如下：
		1、XML配置：
			 xmlns:context="http://www.springframework.org/schema/context"  --context新加的
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

			--另新加配置；
			<context:component-scan base-package="com.itguigu.spring.demoanno">
			</context:component-scan>
		2、在类上加注解：
			@Service
			public class UserService {
			}
			
		3、基于注解方式实现属性注入：
			1、@Autowired：根据属性注入
			2、@Qualifier：根据名称注入，需要搭配@Autowired一起使用
			3、@Resource：可以根据类型注入，也可以根据名称注入
			
			@Autowired根据类型注入，注入如下：
				 @Autowired
				private User user;
				是根据User接口来注入的，当接口User有多个实现类时，就不能通过@Autowired来注入了，因为找对应的
			User类型时，会有多个，无法确定你需要的是哪一个，所以会报错。
			
			这个时候就需要使用类型 +名称一起来确定了
			
			@Qualifier
			编写如下：
				@Autowired
				@Qualifier(value = "userImpl01")
				private User user;
			
			相应的接口User的实现类的注解如下：
				@Service(value = "userImpl01") --根据名称查找，则value必写
				public class UserImpl01 implements User {
				}
			
			@Resource：
				1、根据类型来获取对象：
					@Resource
					private User user;
				2、根据名称来获取对象
					@Resource(name = "userImpl01")
					private User user;
					
				但是建议使用@Autowired 和 @Qualifier
				
			@Value：
				为属性设置值：
					 @Value("abc")
					private String add;	

					为add属性注入了abc的值
			
			
			4、完全注解开发：
				--使用注解后，只用在xml中配置一段<context component-scan>的配置了
				
				--可以使用下面代码，则不需要xml配置文件了											
				@Configuration
				@ComponentScan(value="com.itguigu.spring.demoanno")
				public class SpringConfig {
				}
			
			在测试时，需要解析上述SpringConfig类：
				--加载方式的区别：				
				ApplicationContext app = new AnnotationConfigApplicationContext(SpringConfig.class);
			
			
			
			
			
			
			
			
			
			
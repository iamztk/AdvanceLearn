1、IOC的概念和原理
	a、什么是IOC?
		1、控制反转，把对象创建和对象之间的调用过程，交给spring来管理。、
		2、使用IOC的目的：降低耦合度。
		
	b、IOC底层原理：
		1、XML解析、工厂模式、反射
		
		2、讲解原理：
			第一步：
				配置文件配置需要创建的对象
				<bean id="user" class="com.itguigu.spring.User"></bean>
			
			第二:工厂模式生成对应的对象
			--通过这种方式尽量降低了耦合
			class UserFactory{				
				public static UserDao getUserDao(){
					--1、通过xml解析，解析配置文件，获取User类的全路径
					String classValue = xml解析；					
					--2、通过反射获取userDao对象
					Class clzz = Class.forName(classValue);
					return (UserDao)clzz.newInstance();
				
				}
			
			}
			
	c、IOC接口
		1、IOC思想基于IOC容器完成，IOC容器底层就是对象工厂。
		2、Spring提供IOC容器实现两种方式：（两个接口）
			a、BeanFactory：IOC容器的基本实现，是Spring内部的使用接口，不提供开发人员使用
				*加载配置文件的时候，不会创建对象，在获取对象的时候才会去创建对象。
			
			b、ApplicationContext：BeanFactroy接口的子接口，提供了很多强大的功能，一般由开发
			人员进行使用。
				*加载配置文件的时候就会把配置文件对象进行创建。
				
		--一般会选择在加载配置文件的时候进行创建对象，因为文件加载一般是服务器启动的时候，
		所以选择件创建对象这种耗时的操作，在启动时完成，后续应用中，就不需要在花费时间创建
		对象了
		
		
2、IOC操作bean管理
	 
	a、什么是bean管理？
		bean管理指的是两个操作：
			1、Spring创建对象
			2、Spring属性注入
			
	b、bean管理有两种操作方式：
		1、基于XML配置文件方式实现
		2、基于注解方式实现
		
	
	c、基于XML配置文件方式：
		1、通过get/set实现属性注入
		2、通过有参构造器实现属性注入
		
		方式1、通过get/set注入：
		实体类：
			public class Book {
				public String bname;
				public String price;
				public void testDemo(){
					System.out.println(bname + "===" + price);
				}
				public String getBname() {
					return bname;
				}
				public void setBname(String bname) {
					this.bname = bname;
				}
				public String getPrice() {
					return price;
				}
				public void setPrice(String price) {
					this.price = price;
				}
			}
		XML配置：
			<bean id="book" class="com.itguigu.spring.Book">  --注意如果bean是这样写，则生成对象是调用的无参构造器
				<!--属性注入-->
				--name: 属性名称
				--value：属性值
				------这种方式是通过get/set注入
				<property name="bname" value="java语言面向对象"></property>
				<property name="price" value="22"></property>

			</bean>
		
		方式二：通过有参构造器注入：
			<!--构造器注入-->
			--通过配置参数来确定是调用该类的哪个构造方法创建对象。
			<bean id="orders" class="com.itguigu.spring.Orders">
				<constructor-arg name="oname" value="爱疯" />
				<constructor-arg name="price" value="188" />
			</bean>
			
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
--参观网址：https://www.cnblogs.com/wyq178/p/6843502.html
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
		
		3、原理：
			a、XML配置，相应的类的全限定名称，以及名称的唯一映射id。
			b、解析该xml，获取限定名称，以及其他相关配置参数，通过反射，获取类的对象。
			c、将对象存储进相应的map中。
			d、通过getBean(id)方法，获取相应的对象。
			
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
			2、Spring属性注入 （DI:依赖注入）
			
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
			
		方式一XML配置的简化版：
			P空间：
				第一步：添加p命名空间：
					xmlns:p="http://www.springframework.org/schema/p"
				第二步：<bean>配置
					<bean id="book" class="com.itguigu.spring.Book" p:bname="java语言面向对象" p:price="18"></bean>

		
		方式二：通过有参构造器注入：
			<!--构造器注入-->
			--通过配置参数来确定是调用该类的哪个构造方法创建对象。
			<bean id="orders" class="com.itguigu.spring.Orders">
				<constructor-arg name="oname" value="爱疯" />
				<constructor-arg name="price" value="188" />
			</bean>
			
		
	d、IOC中注入其他类型的属性：
			1、注入NULL
			2、注入特殊字符， 例如<< [在xml中会将< 这个符号认为是个标签]
			
			1、注入NULL值：
				<bean id="book" class="com.itguigu.spring.Book">
					<!--属性注入-->
					<property name="bname">
						-- <!--将bname的值设置为null， 不能直接value="null"吗-->
						--将属性bname设置为null：方式一：
					   <null/>
					   --方式二：也可直接在<property name="bname" value="null">
					</property>
					<property name="price" value="22"></property>
				</bean>
				
			2、注入特殊字符： << >>
				方式一：使用&lt;  == 大于号   &gt;== 小于号
					 <bean id="book" class="com.itguigu.spring.Book">
						<!--属性注入-->
					   <property name="bname" value="语言艺术"></property>
							<!--将bname的值设置为null， 不能直接value="null"吗-->

						<property name="price">
							<value>&lt;&lt;南京&gt;&gt;</value>
						</property>
					</bean>
					返回值：语言艺术===<<南京>>
				
				方式二：转义<![CDATA[<<南京>>]]>
					<bean id="book" class="com.itguigu.spring.Book">
						<!--属性注入-->
					   <property name="bname" value="语言艺术"></property>
							<!--将bname的值设置为null， 不能直接value="null"吗-->

						<property name="price">
							<value><![CDATA[<<南京>>]]></value>
						</property>
					</bean>
					
					
	e、外部bean注入对象
		public class UserService {

			public UserDao userDao;

			public void setUserDao(UserDao userDao) {
				this.userDao = userDao;
			}

			public void update(){
				System.out.println("UserService： 正在修改");
				userDao.eat();
			}
		}
		
		xml配置：
		    <!--配置UserDao-->
			<bean id="userDao" class="com.itguigu.spring.demo2.UserImpl"></bean>
			<!--配置UserService-->
			<bean id="userService" class="com.itguigu.spring.demo2.UserService">
				<property name="userDao" ref="userDao" />
			</bean>
			
			在UserService中注入对象UserDao，需要在xml配置文件中使用ref关联上，使用IOC生成相应的
		UserDao的对象和UserService的对象。
			--解析xml
			ApplicationContext app = new ClassPathXmlApplicationContext("bean2.xml");
			--获取相应的bean【即对象】
			UserService userService = app.getBean("userService", UserService.class);
			userService.update();
		
	7、内部bean的xml配置：
		 <!--内部bean配置-->
		 <bean id="userService" class="com.itguigu.spring.demo2.UserService">
				<property name="name" value="张三" />
				<property name="userDao">
					<bean id="userDao" class="com.itguigu.spring.demo2.UserImpl">
						<property name="uname" value="李四" />
					</bean>
				</property>
		 </bean>
		
		正常的在bean的内部配置bean
		
	8、级联配置：给关联的类进行属性的配置
		<!--内部bean配置的级联配置-->
			<bean id="userService" class="com.itguigu.spring.demo2.UserService">
					<property name="name" value="张三" />
					<property name="userDao">
						<bean id="userDao" class="com.itguigu.spring.demo2.UserImpl">
							<property name="uname" value="李四" />
						</bean>
					</property>
			</bean>
		 
		<!--内部bean配置的级联配置-->  
			<bean id="userDao" class="com.itguigu.spring.demo2.UserImpl"></bean>
			<!--配置UserService-->
			<bean id="userService" class="com.itguigu.spring.demo2.UserService">
				<property name="name" value="张三"/>
				<property name="userDao" ref="userDao" />
				--注：如果通过userDao.uname, 则在userService中必须要有getUserDao()方法，不然无法获取UserDao对象。
				<property name="userDao.uname" value="李四"/>
			</bean>

8、xml配置array、list、set、map属性
		<bean id="stu" class="com.itguigu.spring.demo3.Stu">
			<property name="courses">
				<array>
					<value>"语文"</value>
					<value>"数学"</value>
					<value>"英语"</value>
				</array>
			</property>
			<property name="lists">
				<list>
					<value>"list1"</value>
					<value>"list2"</value>
				</list>
			</property>
			<property name="sets">
				<set>
					<value>"set1"</value>
					<value>"set2"</value>
				</set>
			</property>
			<property name="maps">
				<map>
					<entry key="map1" value="语文"></entry>
					<entry key="map2" value="数学"></entry>
				</map>
			</property>
		</bean>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
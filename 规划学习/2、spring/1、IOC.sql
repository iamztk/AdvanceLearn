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
	
9、提取list、set、map中存储对象时：
	例如：
		list中存放的是Book对象，该如何引用：List<Book>
			<ref bean= "XXXXX">
			
	 <!--引入Book-->
    <bean id="book" class="com.itguigu.spring.demo4.Book">
        <property name="bname" value="语文" />
    </bean>

    <bean id="book2" class="com.itguigu.spring.demo4.Book">
        <property name="bname" value="数学" />
    </bean>

    <bean id="stu" class="com.itguigu.spring.demo4.Stu">
        <property name="list">
           <list>
               <ref bean="book" />
               <ref bean="book2" />
           </list>
        </property>
    </bean>
	
10、提取公共的list，复用list
	--使用<util:list>
	--需在修改约束如下：
		原约束：
		<beans xmlns="http://www.springframework.org/schema/beans"
		   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		   xmlns:p="http://www.springframework.org/schema/p"
		   xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
		修改后约束：
		<beans xmlns="http://www.springframework.org/schema/beans"
		   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		   xmlns:p="http://www.springframework.org/schema/p"
		   xmlns:util="http://www.springframework.org/schema/util"  --新增
		   xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
							   http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">
								--上一条为新增


	--2、所以定义了多个book	
    <bean id="book1" class="com.itguigu.spring.demo5.Book">
        <property name="bname" value="语文" />
    </bean>
    <bean id="book2" class="com.itguigu.spring.demo5.Book">
        <property name="bname" value="数学" />
    </bean>
    <bean id="book3" class="com.itguigu.spring.demo5.Book">
        <property name="bname" value="英语" />
    </bean>
	
	--使用List集合做抽取，是的list集合为公共的
    <util:list id="booklist">
        <ref bean="book1" />
        <ref bean="book2" />
        <ref bean="book3" />
    </util:list>

   
	--1、Stu中包含了List<Book>
    <bean id="stu" class="com.itguigu.spring.demo5.Stu">
        <property name="list" ref="booklist" />
    </bean>
	
	
	
8、工厂bean（FactoryBean）和普通bean
	
	 <bean id="stu" class="com.itguigu.spring.demo5.Stu">
        <property name="list" ref="booklist" />
    </bean>
	
	如上在xml中的bean定义，定义的事Stu类型的，则在使用时返回的就是Stu类
	
	工厂bean书写方式：
		--需事先Factor有Bean类， 并在getObject中设置返回的对象。
		public class MyBean implements FactoryBean {
			@Override
			public Object getObject() throws Exception {
			--自定义的需返回的对象
				Course course = new Course();
				course.setCname("语文");
				return course;
			}

			@Override
			public Class<?> getObjectType() {
				return null;
			}

			@Override
			public boolean isSingleton() {
				return false;
			}
		}
		
		--2、在XML中的定义还是以该实现类来定义：
			   <bean id="mybean" class="com.itguigu.spring.demo6.factorybean.MyBean">
			   </bean>
		
		--获取对象如下：
		 ApplicationContext app =
                    new ClassPathXmlApplicationContext("com\\itguigu\\spring\\demo6\\bean6.xml");
        Course mybean = app.getBean("mybean", Course.class);
        mybean.study();
		
9、bean的作用域
	bean有常用的两种：单实例bean 和 多实例bean
		--配置文件中使用scope进行bean作用域的设置。
		单实例bean：每次在加载配置文件时，就会创建对应的对象，后续每次使用对象时，都是直接获取该创建的对象，
	所以，每次获取的对象地址都是一样的。 
		--注：在配置文件中，默认就是单例bean。
		配置文件如下：
			  <bean id="stu" class="com.itguigu.spring.demo4.Stu" scope="singleton">
			  或者：
			  <bean id="stu" class="com.itguigu.spring.demo4.Stu">
		
		多实例bean，又称：原型bean, 加载配置文件的时候，不会创建对象，而是在getBean()的时候，才会创建对象。
	所以，每次获取的对象都是不一样的
		配置文件如下：
		  <bean id="stu" class="com.itguigu.spring.demo4.Stu" scope="prototype">
		
		另外还有两个不常用的作用于：
			request:存在于一次请求当中
			session:在一次会话中存在
	
	
10、bean的生命周期
	1、生命周期
		从对象的创建到对象销毁的过程
	
	2、bean的生命周期（5步）
		第一步、通过构造器创建bean实例（无参数构造器）
		第二步、为bean 的属性设置值和对其他bean 的引用（调用set方法）
		第三步、调用备案的初始化方法（需要配置初始化方法） init-metjiod
		第四步、bean可以使用了（对象获取到了）
		第五步、当容器关闭时，调用bean的销毁方法（需要进行配置销毁的方法）
			destory-method
			
	
	3、bean的生命周期（7步）
		在第"d"步的前后还有各一步，为调用spring-bean的前后置方法。
		--调用bean的前置方放弃啊
		bean可以使用了（对象获取到了）
		--调用bean 的后置方法。
		这两步需要配置才能生效，配置如下：
			编写一个额外的类，该类需事先BeanPostProcessor：
				public class Book implements BeanPostProcessor {
					实现接口内的两个方法
				}
				--进行xml的配置
				  <bean id="book" class="com.itguigu.spring.demo4.Book">
					--这个中间不需要加任何东西，只表明这个book是个前后置处理类
				  </bean>

	
11、基于XML实现自动装配：
		    <bean id="book" class="com.itguigu.spring.demo4.Book" autowire="byName">
			<bean id="book" class="com.itguigu.spring.demo4.Book" autowire="byType">
			
12、外部属性文件：
		引入属性文件：jdbc.properties
		需要在xml中配置名称空间：context
		xmlns:p="http://www.springframework.org/schema/context"
		
		<comtext:property-placeholder location="classpath:jdbc.properties"></comtext:property-placeholder>
		加载配置文件jdbc.properties

		<bean id=dataSource class="com.alibaba.druid.pool.DruidDataSource">
			<properties name="driverClassName" value="${prop.driverClass}"/>
			<properties name="url" value="${prop.url}"/>
			<properties name="username" value="${prop.username}"/>
			<properties name="password" value="${prop.password}"/>
		</bean>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
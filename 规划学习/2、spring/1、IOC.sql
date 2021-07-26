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
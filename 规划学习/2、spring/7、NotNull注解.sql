Spring5框架核心容器支持@Nullable注解
	1、@Nullable注解可以使用在方法上面，属性上面，参数上面，表示方法返回值
可以为空，属性值可以为空，参数值可以为空。

	a、用在方法上，表明返回值可以为空
	@Nullable
    String getId();
	
	b、用在参数值上，表明参数可以为空
	public ClassPathXmlApplicationContext(String[] paths, Class<?> clazz, 
			@Nullable ApplicationContext parent) throws BeansException {


函数式风格 GenericApplicationContext
--函数式风格创建对象，交给spring进行管理
	手动创建对象，并交由spring管理
	手动创建的对象，不归属spring管理，所以不会在IOC容器中，如果需要将该对象交由spring管理，
则需要将该对象注册进Spring中。
        GenericApplicationContext context = new GenericApplicationContext();
        context.refresh();
		--方式一：不指定beanName
        context.registerBean(,User.class, ()->new User());
		--不指定beanName获取对象的方式
		User user = (User) context.getBean("com.itguigu.spring.log4j.demo_02.User");
        System.out.println(user);
		--方式二：指定beanName
		context.registerBean("user1",User.class, ()->new User());
		--指定beanName获取对象的方式
        User user = (User)context.getBean("user1");

        System.out.println(user);
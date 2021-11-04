1、Spring中是支持单例的循环依赖。
   但是不支持构造器和原型bean的循环依赖。
 
2、什么是bean，什么是java对象？
	bean：bean一定是一个java对象
	java对象：java对象不一定是一个bean
	
3、bean的由来：
    class -> beanDefinition -> bean
	由class类，转为beandefinition，从而生成bean。

4、普通类和spring-bean的实例化过程：	
    1)、普通类的实例化过程：
		1、运行main方法，调用C++代码，启动虚拟机，将编译好的class字节码，加载进
	jvm的内存当中（比如方法区）。
		2、当遇到new关键字的时候，就会根据方法区中提供的模板去堆上分配一块内存去存储该对象
		   即：对象存储在堆内存中。
		   
	2)、spring-bean的实例化过程：
		1、在运行启动类的时候，会初始化很多数据
		2、对于有@service，@controller等相应注解的类，在启动时，会获取类，并解析注解
	--对于有注解@Lazy(true), 开启懒加载，则第一时间不创建该对象，只有在用的时候，再去创建对象。prototype也是用的时候在生成对象
	所以，会先去获取类的这些相关注解，并用beanDefinition（接口）对象存储这些相关信息。		
		3、用beanDefinition对象存储类的相关属性，然后通过拆分、验证、解析后放入map中
		在存入map之后，创建对象放入单例池之前，会去调用扩展类，查看是否有扩展。
		扩展接口：BeanFactoryPostProcessor（后置处理器的接口）
		会有一个for循环，循环遍历所有的归spring管理的类，
		每一个类都会创建beanDefinition对象，存储相关的信息，然后在循环遍历的时候通过map存储该BeanDefinition对象。
		map(key, value):
			key：当前类的名称
			value：beanDefinition对象
		另外还会有一个list进行存储bean的名称。
		所以在拆分、验证、解析后会有map和list集合。
		
		整个spring有一个工厂，工厂里面包含了map，当把工厂传递给某个对象时，意味着
	map也传递过来了。
	
	
4、关键方法：
		getBean();
		doGetBean();
		getSingleton();
		
		
5、Spring初始化bean，有九个地方后置处理器	
	@PostConstruct:Spring生命周期的回调方法。
	
	Spring创建bean是有步骤的，不是一步到位的，而是分层次的。
	
6、如何关闭循环依赖：
	--方式一：
	
		/**
		 * 如果需要关闭循环依赖，则就应该在初始化完成之前设置相应的参数为false
		 * 如何关闭循环依赖
		 */
		AnnotationConfigApplicationContext ac = new AnnotationConfigApplicationContext();
		ac.register(AppConfig.class);
		AbstractAutowireCapableBeanFactory ab = (AbstractAutowireCapableBeanFactory) ac.getBeanFactory();
		ab.setAllowCircularReferences(false);

		/**
		 * 在类AbstractAutowireCapableBeanFactory中，会有如下逻辑，来进行判断是否
		 * 需要进行循环依赖，如下三个条件中，只有this.allowCircularReferences\
		 * 是可以进行修改的，所以如需关闭循环依赖，则可以通过修改该参数的值
		 */
		boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
				isSingletonCurrentlyInCreation(beanName));
		
		如果需要进行循环依赖，则会第四次调用后置处理器，会判断是否需要AOP
		
7、@Autowired 和 @RESOURCE注解的区别？
		@Autowired是通过id进行属性注入的。
		@Resourde先通过name进行查找，找不到再通过id进行查找，如果指定了name，则不会在根据id进行查找。
					不推荐该方法，因为这个注解不是spring的，是javax的
				
		--从源码的角度来看，这两个注解是不同的后置处理器进行处理的
			@Autowired是通过AutowiredAnnotationBeanPostProcessor这个类进行处理的。
			@Resource是通过CommonAnnotationBeanPostProcessor这个后置处理器进行处理的。
			
8、三个map,三级缓存：
	1、一级缓存：singletonObjects 第一个map，单例池，所谓的Spring容器
			private final Map<String, Object> singletonObjects = new ConcurrentHashMap<>(256);

	2、二级缓存：singletonFactories 创建bean时，如果单例池中不存在，且又不在创建中，spring则会去创建该bean，并存放进二级缓存中。
			private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<>(16);

	3、三级缓存：earlySingletonObjects 从二级缓存中拿出，存放进三级缓存中，并把该bean对象从二级缓存中remove掉
			private final Map<String, Object> earlySingletonObjects = new ConcurrentHashMap<>(16);

	--问：一级缓存和三级缓存为什么都是线程安全的？而二级缓存不需要？
	
	
	--源码：DefaultSingletonBeanRegistry类中该缓存片段代码：
		@Nullable
		protected Object getSingleton(String beanName, boolean allowEarlyReference) {
			// Quick check for existing instance without full singleton lock
			Object singletonObject = this.singletonObjects.get(beanName);
			if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
				singletonObject = this.earlySingletonObjects.get(beanName);
				if (singletonObject == null && allowEarlyReference) {
					synchronized (this.singletonObjects) {
						// Consistent creation of early reference within full singleton lock
						singletonObject = this.singletonObjects.get(beanName);
						if (singletonObject == null) {
							singletonObject = this.earlySingletonObjects.get(beanName);
							if (singletonObject == null) {
								ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
								if (singletonFactory != null) {
									singletonObject = singletonFactory.getObject();
									this.earlySingletonObjects.put(beanName, singletonObject);
									this.singletonFactories.remove(beanName);
								}
							}
						}
					}
				}
			}
			return singletonObject;
		}
		
9、spring中的执行顺序：
	1、new
	2、注入
	3、init生命周期初始方法	
	4、代理 aop  --AbstractAutowireCapableBeanFactory 在这个类中处理aop
	5、put 进 单例池
	
	bean的生命周期完成，bean初始化完成。
	

10、Spring的初始化init方法的方式有三种：
		常用的设定方式有以下三种：
		1、通过实现 InitializingBean/DisposableBean 接口来定制初始化之后/销毁之前的操作方法；
		2、通过 <bean> 元素的 init-method/destroy-method属性指定初始化之后 /销毁之前调用的操作方法；
		3、在指定方法上加上@PostConstruct 或@PreDestroy注解来制定该方法是在初始化之后还是销毁之前调用。 
		对于这三种方式都可以一次性写上，不冲突，但是有执行顺序：
			1、@PostContruct
			2、实现InitializingBean/DisposableBean
			3、通过xml配置init-method和Destory-method
	
		--在类：AbstractAutowireCapableBeanFactory中的初始化调用顺序如下：
		if (mbd == null || !mbd.isSynthetic()) {
			--初始化注解的
			wrappedBean = applyBeanPostProcessorsBeforeInitialization(wrappedBean, beanName);
		}

		try {
			--调用接口 和 xml的
			invokeInitMethods(beanName, wrappedBean, mbd);
		}
		因为代码的执行顺序，所以存在上述的初始化方式执行顺序。
		
		在AnnotationAwareAspectJAutoProxyCreator后置处理器处理aop。
		
		
11、为什么需要三级缓存？
	从步骤9可以得到spring完成bean的生命周期的顺序。
	在注入的时候，是通过从二级缓存中获取注入的，而二级缓存中存放的是一个工厂（ObjectFactory），这个工厂含有循环依赖注入的那个
对象（该对象目前只是创建出来了，即new出来了，相应的属性还没有注入，在这一步注入）
	所以此时注入的仅仅只是对象，这个对象并没有所谓的aop，所以这里就体现出了三级缓存的作用。
	但是具体作用，需后续学习。
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
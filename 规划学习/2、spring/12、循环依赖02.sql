 1、先getSingleton(beanName)
	获取当前bean，如何获取：
		先从单例池中获取，如果获取不到，则判断该bean是否正在创建的过程中，
		如果是正在创建中，则该对象肯定是存放在二级缓存中的。
		然后从二级缓存中获取，存放进三级缓存中，在从二级缓存中移除。
		
		如果不是正在创建的过程中，则直接往下走
		
		那么在什么时候将对象存入二级缓存中的呢？

2、存放入二级缓存的肯定是个对象，所以，肯定是对象创建后再存放进二级缓存的。	
	    因为bean不存在，所以需要创建，创建完对象以后，就放入了二级缓存中
		
		if (mbd.isSingleton()) {
                    sharedInstance = this.getSingleton(beanName, () -> {
                        try {
                            return this.createBean(beanName, mbd, args);
                        } catch (BeansException var5) {
                            this.destroySingleton(beanName);
                            throw var5;
                        }
                    });
                    bean = this.getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
                }
				
		--createBean(beanName, mbd, args):	当bean不存在时，需要新建bean
		--如下代码是新建对象
		BeanWrapper instanceWrapper = null;
		if (mbd.isSingleton()) {
			instanceWrapper = (BeanWrapper)this.factoryBeanInstanceCache.remove(beanName);
		}

		if (instanceWrapper == null) {
			instanceWrapper = this.createBeanInstance(beanName, mbd, args);
		}

		Object bean = instanceWrapper.getWrappedInstance(); -- bean就是新建的对象
				
				
		//this = beanFactory	是ConfigurableListableBeanFactory（是个接口）对象
        1、beanFactory.preInstantiateSingletons();
			最终在实现类：DefaultListableBeanFactory中执行了具体的方法。
			所以，this = DefaultListableBeanFactory对象
			
			
3、为什么setAllowCircularReferences(false)就关闭了循环依赖？
		--1、判断是否支持循环依赖
			boolean earlySingletonExposure = mbd.isSingleton()  --是单例的
										  && this.allowCircularReferences --支持循环依赖的
										  && this.isSingletonCurrentlyInCreation(beanName); --这个里面是包含该bean的			
			if (earlySingletonExposure) {
				if (this.logger.isTraceEnabled()) {
					this.logger.trace("Eagerly caching bean '" + beanName + "' to allow for resolving potential circular references");
				}
				--当earlySingletonExposure=true时，则会将该bean存放进缓存中
				this.addSingletonFactory(beanName, () -> {
					return this.getEarlyBeanReference(beanName, mbd, bean);
				});
			}	
		
		--2、支持循环依赖，会有什么结果
			protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory) {
				Assert.notNull(singletonFactory, "Singleton factory must not be null");
				Map var3 = this.singletonObjects;
				synchronized(this.singletonObjects) {
					if (!this.singletonObjects.containsKey(beanName)) {
						this.singletonFactories.put(beanName, singletonFactory); --没有错，这就是二级缓存对应的map
						this.earlySingletonObjects.remove(beanName);
						this.registeredSingletons.add(beanName);
					}

				}
			}
			
		--3、一旦存放进了缓存，则在AbstractBeanFactory.doGetBean()方法中有如下 逻辑：
		protected <T> T doGetBean(String name, @Nullable Class<T> requiredType, @Nullable Object[] args, boolean typeCheckOnly) throws BeansException {
			String beanName = this.transformedBeanName(name);
			--放入缓存后，就能在这里得到相应的bean，当sharedInstance!=null为true时，则会进入到if中
			--如果sharedInstance!=null为false，则会进入到else中
			--在else中会创建bean，并存放进相应的set集合中，在存入set集合之前会判断，该集合中是否存在了该beanName
			--如果存在，又再次添加，则会报错，
			Object sharedInstance = this.getSingleton(beanName); 
			Object bean;
			if (sharedInstance != null && args == null) {
				if (this.logger.isTraceEnabled()) {
					if (this.isSingletonCurrentlyInCreation(beanName)) {
						this.logger.trace("Returning eagerly cached instance of singleton bean '" + beanName + "' that is not fully initialized yet - a consequence of a circular reference");
					} else {
						this.logger.trace("Returning cached instance of singleton bean '" + beanName + "'");
					}
				}
			
			
			
			
			
总结：
	Spring是如何解决循环依赖的：
		1、Spring只解决了单例的注解方式的循环依赖
		 对于构造器和原型bean是不支持循环依赖的
		2、场景：
			类A中注入了类B
			类B中注入了类A
		    当类A进行初始化的时候，会发现有属性依赖于类B，所以就会去初始化类B，而在初始化类B的
	    的时候，发现类A又依赖于类B，又要去初始化类A，所以就会陷入无限循环。
			
			以上情况就是循环依赖，那么Spring是如何解决单例模式下通过注解方式导致的循环依赖场景问题。
			  构建了三级缓存，即三个map存储相应数据，从而解决了该问题
			  
			  1、在Spring初始化的时候，先去判断该对象是否存在于单例池中，如果存在，则直接获取，
			如果不存在，则判断该对象是否正在创建的过程中，该创建的过程中如何判断，就是从二级缓存
			中获取该beanName，如果获取不到，则说明不在创建中，则需要后续去创建。
				如果存在于二级缓存中，则直接获取。
				--这个单例池就是所谓的一级缓存， 第一个map
				--正在创建中，则表名该对象存在于二级缓存中， 第二个map。
				
			2、不存在该对象，则创建该对象，并存放于二级缓存中。
				在第一步中，判断bean即不存在于单例池中，又不存在于二级缓存中时，就会取新建该对象。
				
			3、会将新建的对象存入到二级缓存中。
				 if (newSingleton) {
                    this.addSingleton(beanName, singletonObject); --将创建出的对象存放进二级缓存中
                }
				
				protected void addSingleton(String beanName, Object singletonObject) {
					Map var3 = this.singletonObjects;  
					synchronized(this.singletonObjects) {
						this.singletonObjects.put(beanName, singletonObject);
						this.singletonFactories.remove(beanName);
						this.earlySingletonObjects.remove(beanName);
						this.registeredSingletons.add(beanName);
					}
				}
    
			4、此时是类A的对象存入了二级缓存中，后在进行属性的注入
				注入的时候，发现有个属性是类B的对象，这个时候有需要取实例化类B
				重复上述操作，但是实例的是类B，一直到注入这一步骤。
				发现类B中有个属性是类A的对象，这个时候，又会去实例化类A，但是
				在getSingleton(beanName)时，能从二级缓存中获取到类A的实例
				所以创建B的实例时，虽然有个属性为类A，但是此时类A能从缓存中获取实例，所以类B能正常的实例
				当类B能正常实例化时，则类A也能顺利完成注入，所以循环依赖就解决了。
				

		3、从总结2中可知，解决循环依赖使用两层缓存就可以了。
			一级缓存：单例池-》存放的是spring的bean，即有完整的spring-bean生命周期的bean。
			二级缓存：存放的是创建出来的实例，即只进行了对象的构建，其他流程并未进行
				1、new
				2、注入
				3、init生命周期初始方法	
				4、代理 aop  --AbstractAutowireCapableBeanFactory 在这个类中处理aop
				5、put 进 单例池
				
			
		4、那为什么还需要第三级缓存，并且从二级缓存中获取该对象（ObjectFactory对象）时，需要将对象put进三级缓存中。
			这个操作和AOP有关？？
			 
			 
			
			
		
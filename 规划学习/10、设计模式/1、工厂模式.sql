1、工厂模式：
	工厂顾名思义就是创建产品，根据产品是具体产品还是具体工厂可分为：简单工厂模式和工厂方法模式，
	根据工厂的抽象程度可分为：工厂方法模式和抽象工厂模式。
	该模式用于封装和管理对象的创建，是一种创建型模式。

2、23中设计模式之二
	创建型模式：
		工厂方法模式		
		抽象工厂模式

		
3、作用：
		简单理解：工厂模式就是将创建对象的交由工厂类，具体调用对象时，通过工厂类进行 创建，并调用。
	a、简单工厂模式：
		public static FatherDemo getClzz(String name) {
        if ("UserDemo".equalsIgnoreCase(name)) {
            return new UserDemo();
        } else if ("EmployeeDemo".equalsIgnoreCase(name)) {
            return new EmployeeDemo();
        }
        return null;
		}
		--一个工厂类就搞定了，比较方便
			简单工厂模式的优点从上面两种方式对比可以看出，工厂角色负责产生具体的实例对象，
		所以在工厂类中需要有必要的逻辑，通过客户的输入能够得到具体创建的实例；
		所以客户端就不需要感知具体对象是如何产生的，只需要将必要的信息提供给工厂即可。
		
	b、工厂方法模式：
		--1、抽象类
			public interface AbstractFactory {
				FatherDemo getClzz();
			}
		--2、具体类的工厂
			--类1：
			public class EmployeeFactoryImpl implements AbstractFactory {
				public FatherDemo getClzz() {
					return new EmployeeDemo();
				}
			｝
			--类2：
			public class UserFactoryImpl implements AbstractFactory {
				public FatherDemo getClzz() {
					return new UserDemo();
				}
			}
		相比于第一种，第二种相对应的每个类都会增加一个抽象工厂，类的数量可能加倍了，但是在实现上比第一种方式要好。
		
	c、抽象工厂模式
		
		如果新增一个类，动物类， 则又需新增工厂类，增加的工厂类是工厂的抽象类与实现类一并添加的
		--1、抽象类
			public interface AbstractAnimalFactory {
				AnimalDemo getClzz();
			}
			public interface AbstractFactory {
				FatherDemo getClzz();
			}
		--2、具体类的工厂
			--新增类：
			public class AnimalFactoryDemo implements AbstractAnimalFactory {
				public AnimalDemo getClzz() {
					return new DogDemo();
				}
			}
			--类1：
			public class EmployeeFactoryImpl implements AbstractFactory {
				public FatherDemo getClzz() {
					return new EmployeeDemo();
				}
			｝
			--类2：
			public class UserFactoryImpl implements AbstractFactory {
				public FatherDemo getClzz() {
					return new UserDemo();
				}
			}
					
4、工厂方法模式和抽象工厂模式
		工厂方法模式和抽象工厂模式基本类似，可以这么理解：
	当工厂只生产一个产品的时候，即为工厂方法模式，而工厂如果生产两个或以上的商品即变为抽象工厂模式。	
		
		
		
		
5、工厂模式的目的：
	无论是简单工厂模式，工厂方法模式，还是抽象工厂模式，他们都属于工厂模式，在形式和特点上也是极为相似的，
	
	他们的最终目的都是为了解耦。
		
		所以，在使用工厂模式时，只需要关心降低耦合度的目的是否达到了。
	使用工厂方法后，调用端的耦合度大大降低了。
		并且对于工厂来说，是可以扩展的，以后如果想组装其他的产品，
	只需要再增加一个工厂类的实现就可以。
		无论是灵活性还是稳定性都得到了极大的提高。
		
		

6、什么情况下适用工厂模式：
	
	Spring中使用的工厂模式：
		接口类：
			FactoryBean<T>  有两个方法 getObject(),  getObjectType();
		
		接口类的实现类：
			abstract AbstractFactoryBean<T>   --抽象类
			
			对于Factory<T>有基本实现，但是还是留了两个抽象方法，给具体的子类取实现。
			  public final T getObject() throws Exception {
				if (this.isSingleton()) {
					return this.initialized ? this.singletonInstance : this.getEarlySingletonInstance();
				} else {
					return this.createInstance();
				}
			}
			分别是：
				  @Nullable
				 public abstract Class<?> getObjectType();
					
				 protected abstract T createInstance() throws Exception;
				 
		
		另在mybatis与spring整合中，有个类也实现了FactoryBean<T>接口：
			public class SqlSessionFactoryBean implements FactoryBean<SqlSessionFactory>, 
									InitializingBean, ApplicationListener<ApplicationEvent> {
			｝
			用于创建sqlSessionFactory对象。

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
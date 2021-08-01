1、代理模式分为：
	静态代理
	动态代理


2、静态代理
	代理类和真实类都必须实现同一个接口。
	--1、接口类，真实类需要做的事:
		public interface GroomDao {
			void marry();
		}
	--2、创建真实类
		public class Groom implements GroomDao {
			public void marry(){
				System.out.println("开始结婚=====");
				System.out.println("结婚中=======");
				System.out.println("结婚完成=====");
			}
		}
	--3、创建代理类
		public class GroomProxy implements GroomDao {
			--真实对象
			private Groom groom = new Groom();

			public void marry() {
				System.out.println("司机开车=====");
				System.out.println("放鞭炮=======");
				groom.marry();
				System.out.println("收拾残局=====");
			}

		}
	--测试类：
		public class GroomTest_01 {
			public static void main(String[] args) {
				GroomProxy groomProxy = new GroomProxy();
				groomProxy.marry();
			}
		}
	
		真实对象只处理marry这一件事，其他的扩展由代理类进行处理。
		
			显然静态代理的局限性很大，真实类扩展方法，必须在接口类、真实类、代理类中进行更改，直接该源代码，
		显然不符合开闭原则。
		

2、动态代理
	动态代理有两种：
			a、JDK动态代理
			b、GGLIB动态代理


3、JDK动态代理
	public static void main(String[] args) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
        --创建真实类对象
        Groom groom = new Groom();
        --根据真实类 创建代理对象
        --如果真实类实现了多个接口，就看真实类需要调用哪个方法，该方法在哪个接口中，则强转成
        --对应的接口类
        GroomDao groom_01 = (GroomDao)getProxy(groom);
        groom_01.marry();
    }
	
	--生成代理对象 方式一：
	private static Object getProxy(final Object target) throws NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
        --获取真实类的实现类数组
        Class<?>[] interfaces = target.getClass().getInterfaces();
        --通过真实类的实现类创建代理类
        Class<?> proxyClass = Proxy.getProxyClass(target.getClass().getClassLoader(), interfaces);
        --获取构造器
        --因为在代理类Proxy中存在构造器 Proxy(InvocationHandler in)
        --所以直接获取该构造器，通过该构造器创建对象
        Constructor<?> constructor = proxyClass.getConstructor(InvocationHandler.class);
        --通过构造器创建对象,因为在构造其中需要传入InvocationHandler对象
        --而InvocationHandler是个接口，所以，需要在这匿名对象
        Object proxy = constructor.newInstance(new InvocationHandler() {
                public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                    Object invoke = method.invoke(target, args);
                    return invoke;
                }
            });
        return proxy;
    }
	
	--生成代理对象 方式二：
	private static Object getProxy(final Object target){
		--方式二相当于是方式一的合并，虽然代码少一些，只是调用的方法中进行了处理。
       return  Proxy.newProxyInstance(target.getClass().getClassLoader(),
                target.getClass().getInterfaces(),
                new InvocationHandler() {
                    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                        System.out.println("开始");
                        Object invoke = method.invoke(target, args);
                        return invoke;
                    }
                });
    }
		
	JDK动态代理：
		真实类必须实现接口，代理是基于实现类创建代理类。
		
		实现方式：
			基于代理类：Proxy
				Proxy.getProxyClass();
				或者：
				Proxy.newProxyInstance();
				

2、CGLIB动态代理
		使用cglib动态代理需要有两个jar报：
			1、cglib-2.2.jar
			2、asm-3.3.1.jar
		
	代码编写：
		--1、回调类，必须要实现MethodInterceptor
		public class CglibProxy implements MethodInterceptor {
			--o: 真实类
			--method:要被拦截的方法
			--objects: 参数数组
			--methodProxy：代理类实例
			public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
				System.out.println("前置开始!");
				Object obj = methodProxy.invokeSuper(o, objects);
				System.out.println("后置结束!");
				return obj;
			}
		}
		--2、真实类编写
		public class Orders {
			public void eat(){
				System.out.println("吃饭吃饭！");
			}
			public void nomoalPeople(){
				System.out.println("干饭干饭!");
			}
		}
		--3、测试代码
		public class OrdersTest_01 {
			public static void main(String[] args) {
				--新建Enhancer对象
				Enhancer enhancer = new Enhancer();
				--设置父类，即代理的真实类
				enhancer.setSuperclass(Orders.class);
				--设置回调
				enhancer.setCallback(new CglibProxy());
				--创建代理对象
				Orders order = (Orders)enhancer.create();
				order.eat();
				order.nomoalPeople();
			}
		}
		
		
		代码解析：
			Enhancer enhancer = new Enhancer();
			1、初始化静态代码块
			
		代理对象的生成由 Enhancer 类实现. Enhancer是CGLib的字节码增强器. 可以很方便的对类进行扩展.

		Enhancer 创建代理对象的大概步骤如下:

		1. 生成代理类 Class 二进制字节码.

		2.通过 Class.forname() 加载字节码文件, 生成 Class 对象.

		3.通过反射机制获得实例构造, 并创建代理类对象.
		
		
		底层大致原理：
			原理一：CGLIB包的底层是通过使用一个小而快的字节码处理框架ASM，来转换字节码并生成新的类。
			原理二：CGLib采用了非常底层的字节码技术，其原理是通过字节码技术为一个类创建子类，
		并在子类中采用方法拦截的技术拦截所有父类方法的调用，顺势织入横切逻辑。
			JDK动态代理与CGLib动态代理均是实现Spring AOP的基础。
			
			代理类开始是不存在的，都是通过cglib自动是生成的代理类。
			生成的该代理类是真实类的子类，继承与真实类。

	总结：
		经测试，jdk创建对象的速度远大于cglib，这是由于cglib创建对象时需要操作字节码。
	cglib执行速度略大于jdk，所以比较适合单例模式。另外由于CGLIB的大部分类是直接对Java字节码进行操作，
	这样生成的类会在Java的永久堆中。如果动态代理操作过多，容易造成永久堆满，触发OutOfMemory异常。
	spring默认使用jdk动态代理，如果类没有接口，则使用cglib。

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
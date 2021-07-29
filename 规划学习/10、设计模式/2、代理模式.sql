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
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
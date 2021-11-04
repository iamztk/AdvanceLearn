1、synchronized特性：
	从不同的角度来划分的话，synchronized是独占锁、非公平锁、悲观锁、可重入锁、不可中断锁。
这里重点介绍下synchronized的可重入和不可中断性。


	synchronized是锁的对象
		A a = new A(); 一个对象，能有什么好锁的，锁的是什么东西？

	对象包含的信息：
		1、对象头 （mark word + klass point）
		2、实例数据 
		3、对齐填充
			
	1、对象头：
		HotSpot虚拟机的对象头分为两部分信息，第一部分用于存储对象自身运行时数据，如哈希吗、GC分代年龄等，
	这部分数据的长度在32位和64位虚拟机中分别是32为和64位。官方称为： Mark Word.
		另一部分用于存储指向对象类型数据的指针，如果是数组对象的话，还有有一个额外的部分存储数组长度。
	这部分官方称为：Klass Point【类的所在地址的指针】
		
	2、实例数据：
		存放类的属性数据信息,包括父类的属性信息，如果是数组的实例部分还包括数组的长度，这部分内存按4字节对齐。

	3、对齐填充：
		由于虚拟机要求对象起始地址必须是8字节的整数倍。填充数据不是必须存在的，仅仅是为了字节对齐。
		
	在jdk 1.6之前，synchronized是重量级锁，为什么？
		因为在jdk 1.6之前，无论是一个线程还是多个线程访问，只要是通过synchronized来实现同步的话，都是会
	调用os(操作系统)的函数metux(),调用该方法会设置到cpu状态的切换，用户态切换成内核态。这个切换很好性能，
	所以synchronized在 1.6 之前都是重量级锁。
	
	1、mark word是什么？？分别在对象头中占用多大的空间？
	2、klass point又是什么？？
		对象头分为两部分，一部分是mark word,另一部分是 klass pointer
		存储的的类型在1中有说到，并且在64位操作系统中，对象头占12个byte,共96位，其中：
			mark word： 占8byte
			klass pointer： 占4byte
		-- class信息存放于 klass pointer中
		--age：gc分代年龄， hashcode, synchronized的state 信息存放于 mark word
	
	3、空对象命名是占8个字节？为什么
		mark word 占64位， 而klass占32位？ 这样的话不就是12字节了吗？那不就是空对象至少有12字节，外加
	对齐填充，不就是16字节码？
		没有问题，就是12个字节，妥妥的，但是这是64位操作系统才是这样的
	
	
	
	
		
	
	synchronized中的几种锁状态：
		1、无锁
		2、偏向锁
		3、轻量级锁
		4、重量级锁
		
	JVM基于进入和退出Monitor对象来实现方法同步和代码块同步。









	1)、可重入锁：
			通俗点说就是：线程获取锁进入一个synchronized方法/代码块，又调用了一个synchronized方法/代码块，
		在进入第二个synchronized方法/代码块时，不需要先释放进入第一个synchronized时获取的锁，也不需要再次争抢锁，
		而是直接进入。所以可重入锁也叫递归锁。
			synchronized的可重入性不需要两个synchronized方法是同一个方法、也不需要是同一个类中的方法，
		仅仅要求是同一个线程。
		同一个方法中：
			public class ObjectLockDemo {

				private static int count = 0;

				public static void main(String[] args) {
					new ObjectLockDemo().display();
				}

				public synchronized void display() {
					System.out.println("display():count=" + count);
					if (count++ == 0) {
						display();
					}
				}
			}
		不同的方法中：
			public class ObjectLockDemo {
				
				public static void main(String[] args) {
					new ObjectLockDemo().displayA();
				}

				public synchronized void displayA() {
					System.out.println("displayA()");
					displayB();
				}

				public synchronized void displayB() {
					System.out.println("displayB()");
				}
			}
			
		不同的类中：
			。。。
		
			可重入性的优点：避免死锁和提高封装性。避免死锁在上面三个例子中已经有了很好的体现。
		可重入性避免了使用了同一把锁时，反复的加锁解锁，提高了封装性，简化了锁的使用难度。	
		
	2)、不可中断锁：
		一旦锁被某个线程获得了，别的线程想要获得锁，只能选择等待或者阻塞，直到那个线程释放了这个锁。
	如果那个线程永远不释放，其他线程只能永远等下去。
	

2、synchronized的缺点：
		1、试图获得锁时，不能设置超时时间，不能中断正在等待获取锁的线程
		2、加锁和解锁条件单一，加锁仅仅有单一条件（对象或者类）
		3、早期版本效率低下（重量级锁）
	
	重量级锁是什么意思？？
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		


java中的锁的作用：
	线程同步

锁是jdk内置的，是sun公司写的

synchronized 在jdk 1.6 之前是重量级的锁

涉及到操作系统，cpu的切换，从内核态切换成用户态，

在1.6之后，进行了优化
虽然业设计到cpu的切换，但是尽量会将同步操作在jvm中处理完成，不到操作系统级别。

线程的执行模式有两种：
		1、交替执行
			在1.6执行，sync都会调用操作系统（os）的函数去解决同步的问题。都是重量级锁
			如果是reentrantlock,则是通过java代码直接解决同步问题，是个轻量级的锁。
		2、竞争执行
		
		
(ReetrantLock)aqs：
  自旋
  park -> unpark 也是阻塞，但是他没有具体的阻塞时间，而是配合unpark来唤醒之类的
        线程a抢占锁，则后需线程b会 b.park(), 知道线程a释放锁，则线程b就会unpark()
		从而往后执行。
  CAS  源码中有一段：compareAndSetState(0, acquires) 就是所谓的cas加锁
  
  
  ReetrantLock:	
    可重入锁：
		原理：是源码中有一段逻辑是判断当前线程与持有锁的线程是否为同一个线程。
			如果是同一个，则将锁的计数器+1，并设置，然后返回true，相当于已经加锁，
		程序继续往下跑。
-------------------------------------------------------------------------------------------

synchronized：
		锁的对象。
		通过锁住对象的对象头实现加锁。
		
		如何查看对象的大小：
			<groupId>org.openjdk.jol
			<artifactId>jol-core
			
			
JVM 是个概念，是个标准

市面上有很多实现了这个标准的虚拟机：
例如现在在用的windows： hotspot sun公司实现的
C:\Users\12742>java -version
java version "1.8.0_191"
Java(TM) SE Runtime Environment (build 1.8.0_191-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.191-b12, mixed mode)

同步是java的说法
操作系统的说法是：线程互斥
java不能操作线程
线程只能有操作系统（os）调用某些操作系统中的函数和代码来操作线程。
		
	在jdk 1.6之前有函数metux函数 可以实现 线程互斥
	但是它是调用内核
	
	系统状态分为：用户状态和内核状态
	java代码运行时可以理解为时用户状态，当调用metux函数后，cpu需要切换到内核状态
	cpu在用户状态 与 内核状态切换是很耗性能的。
	
	所以为什么说synchronized在jdk 1.6之前是重量级锁，是因为无论是几个线程过来访问，都会调用操作系统的函数
就意味着需要进行cpu的切换，完成线程的互斥


	hashcode：是对象存在于内存中的地址，是唯一标识
	
	对象头存的是二进制，而这个二进制，使用的小端存储模式。
		小端存储模式是：高位存高字节
		00000000： 可以理解为第一位存的是第七位，即高位是高字节，从后前看，低位是开始，高位是结束。
		
		hashcode：是从第一个到第56个，代表着hashcode。第一个是从最后算。
		00000001 01000110 10111000 11101111 00001000 00000000 00000000 00000000【这个0代表第一位】
		
   问题：当没有加hashcode 的时候
   --对象头展示：当xxx.hashcode()后，展示对象头如下：
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 46 b8 ef (00000001 01000110 10111000 11101111) (-273136127)
      4     4        (object header)                           08 00 00 00 (00001000 00000000 00000000 00000000) (8)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253) 

   --对象头展示：当没有xxx.hashcode()后，展示对象头如下：
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 00 00 00 (00000001 00000000 00000000 00000000) (1)
      4     4        (object header)                           00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253)	  


锁的几种状态：【问：为什么是默认不可偏向。】
	1、无锁不可偏向
	2、无锁可偏向
	3、轻量级锁
	4、重量级锁
	5、GC回收标志
	
		XXX xxx = new XXX();
        xxx.hashCode();
        System.out.println(ClassLayout.parseInstance(xxx).toPrintable());
	
	1、无锁不可偏向
		XXX xxx = new XXX();
        xxx.hashCode(); --因为它，所以无锁不可偏向
        System.out.println(ClassLayout.parseInstance(xxx).toPrintable());
		--01 46 b8 ef (00000001
		如下：当对象的hashcode被计算出来了以后，则markword中记录hashcode的位置用来记录当前对象的hashcode
	所以没有办法记录偏向线程的地址，所以就不能偏向，但是此时是没有锁的，所以是无锁不可偏向。	
	 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 46 b8 ef (00000001 01000110 10111000 11101111) (-273136127)
      4     4        (object header)                           08 00 00 00 (00001000 00000000 00000000 00000000) (8)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253)
     12     4        (loss due to the next object alignment)
	Instance size: 16 bytes
		
		2、无锁可偏向（由于默认为不可偏向，所以锁标识为01）
		XXX xxx = new XXX();
        System.out.println(ClassLayout.parseInstance(xxx).toPrintable());
		-- 01 00 00 00 (00000001 这个最后的001代表无锁不可偏向  0：不可偏向  01：无锁
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 00 00 00 (00000001 00000000 00000000 00000000) (1)
      4     4        (object header)                           00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253)
     12     4        (loss due to the next object alignment)
Instance size: 16 bytes	

		3、轻量级锁（由于默认不可偏向，所以当加锁后，只能转为轻量级锁）
		XXX xxx = new XXX();
        System.out.println(ClassLayout.parseInstance(xxx).toPrintable());
        synchronized (xxx){ --加锁操作
            System.out.println(ClassLayout.parseInstance(xxx).toPrintable());
        }
		由于默认为不可偏向，所以只能转为轻量级锁
		--f8 f7 47 03 (11111000   000：轻量级锁且不可偏向 0： 不可偏向，  00：轻量级锁
		
		因为如果是偏向锁，则mark word的记录hashcode的位置是存储偏向锁的线程的地址
		
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           f8 f7 47 03 (11111000 11110111 01000111 00000011) (55048184)
      4     4        (object header)                           00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253)
     12     4        (loss due to the next object alignment)
Instance size: 16 bytes		
		
		
		为什么默认为不可偏向？
		   答：以为jdk对偏向默认有延迟。
				jdk偏向延迟如何查看：-XX:+PrintFlagsInitial
				在虚拟机参数配置中，将虚拟机选项一栏填入：-XX:+PrintFlagsInitial
				在运行程序，会得到一系列的配置，其中有表示偏向默认延迟的配置如下：
				intx BiasedLockingStartupDelay  = 4000  {product}
				可以通过设置取消这个偏向延迟。
					-XX:BiasedLockingStartupDelay=0 --还是在虚拟机选项一栏中填入 vm options:
				
				这个不可偏向是延迟，什么是延迟，为什么需要延迟？
					所谓的延迟，就是晚一点才开启这个偏向。因为当锁总是被一个线程
				持有时，如果存在偏向，那么一直就是这个线程获取锁，肯定会超级快。
					但是，如果是不同的线程来获取锁，如果存在偏向，那么第一个线程肯定
				是偏向锁，但是第二个就不是了（第一二个线程不是同一个），此时就需要将
				偏向锁撤销，在升级为轻量级锁，这个是比较耗费性能的。
					项目启动的时候，运行所谓的main方法，或者启动类，可能在启动期间有
				比较多的线程需要同步访问，如果存在偏向，那么很有可能造成启动变得更慢。
				所以，jdk就设置了这个偏向延迟，默认是4000，即启动4秒之后就不再默认为
				禁止偏向锁了。为了提速。
		
		
		
		
		
		
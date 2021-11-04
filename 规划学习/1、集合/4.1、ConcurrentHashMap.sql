1、hashMap多线程并发访问的情况下，线程不安全的体现：
	a、JDK1.7时：
		hashMap采用的数组 + 链表
		同时在扩容时，链表的扩容采用的是：头插法
		链表的从尾部取值，再进行索引的计算与存值。
		
		正因为：头插法，所以在多线程访问的情况下可能造成死循环。
			例如：链表 A-> B-> C
				线层A： 扩容时 获取锁： 此时拿到B元素，这时 B.next = C
										此时CPU时间耗尽，释放锁
				线程B： 扩容时，获取锁， 并且顺利跑完：则应得到链表： C -> B -> A
										线程结束，释放锁
				线程A 获取锁，继续执行：
							在线程A中，此时B.next = C, 继续往下执行又是  C -> B
							就会陷入死循环。
							
	
	b、JDK1.8中：
		hashMap采用的是：数组+ 链表 + 红黑树
		同时，在扩容的时候，链表的扩容方式是：尾差法
		
		
2、线程安全：
	a、HashTable：
		使用的是:synchronized
		
	b、ConcurrentHashMap:
		1.7以前：
			使用的是分段锁： Segment数组
			
			底层使用的是数组 + 链表
			
			此时的数组，就是Segment数组
			
		1.7以后：
			使用的是： CAS + synchronized
			
			锁由轻转重。
			
			CAS是轻量级锁
			
			synchronized是重量级锁
			
	在JDK1.8以后，对synchronized进行了优化，性能提高了。
	
	
3、为什么hashmap的键值可以为null， 但是hashtable和concurrentHashMap的键值却不可以为null?
		
		因为当map的值为null时，null有可能是key值映射为null，也有可能是不存在该key值。
		但是当hashmap里面存在key为null时，可以通过map.contains(key)来查看，该集合中是否存在为null。
		而在多线程环境下，就算能通过contains(key)来判断，该key是否存在，但是也不能确定是否有其他线程
	更改，导致该线程包含了该key。
	
		因为hashMap和hashtable的迭代器不同，HashMap中的Iterator迭代器是fail-fast(快速失败)的，
	而 Hashtable 的 Enumerator 不是 fail-fast 的，是fail-safe(安全失败)。
	
		java.util包下的集合类都是fail-fast(快速失败的)不能在迭代的过程中进行数据的下修改。
		
		java.concurrent包下的容器都是fail-safe(安全失败)，允许在多线程并发使用下修改。
	
		
	
	
	
	
hashmap为什么会出现线程不安全？
	当一个新节点想要插入hashmap的链表时，在jdk1.8之前的版本是插在头部，在1.8后是插在尾部
	(JDK1.8之前使用头插法， JDK1.8以后使用的是尾插法)
	
	1.在jdk1.7中，在多线程环境下，扩容时因为采用头插法，会造成环形链或数据丢失。
	
	2.在jdk1.8中，在多线程环境下，会发生数据覆盖的情况。
	
	
	
	
在jdk1.7之前的ConcurrentHashMap:

	1、是由 Segment 数组、HashEntry 组成，和 HashMap 一样，仍然是数组加链表。
	
		Segment:
		static class Segment<K,V> extends ReentrantLock implements Serializable {
			private static final long serialVersionUID = 2249069246763182397L;
			final float loadFactor;
			Segment(float lf) { 
				this.loadFactor = lf; 
			}
		}
		
		HashEntry:
		static class Node<K,V> implements Map.Entry<K,V> {
			final int hash;
			final K key;
			volatile V val;
			volatile Node<K,V> next;
			
			...
		}
		和 HashMap 非常类似，唯一的区别就是其中的核心数据如 val ，以及链表都是 volatile 修饰的，保证了获取时的可见性。
		
		--问:用volatile修饰是为什么 ？
			1、禁止指令重排
			2、保证可见性
		
			1、禁止指令重排：
				创建对象要经过如下几个步骤
					a. 分配内存空间
					b. 调用构造器，初始化实例
					c. 返回地址给引用
				但是JVM具有指令重排的特性，执行的顺序有可能变成 a-c-b,指令重排在单线程下不会出现问题，但是在多线程下会
			导致一个线程获得还没有初始化的实例。例如：线程T1执行了a，b，此时线程T2调用getInstance()方法发现INSTANCE不为
			null，因此返回INSTANCE，但此时INSTANCE还未被初始化。
			
			2、保证可见性：
				由于可见性问题，线程T1在自己的工作线程内创建了实例，但此时还未同步到主内存中，此时线程T2判断INSTANCE还是null，
			那么线程T2又将在自己的工作线程创建一个实例，这样就创建了多个实例。			
				如果加上了volatile修饰INSTANCE之后，保证了可见性，一旦线程T1返回了实例，线程T2可以立即发现INSTANCE不为null。
				
				主内存与线程的工作内存。
				线程的工作内存只有该线程可见。
				
		总结：
			原理上来说：ConcurrentHashMap 采用了分段锁技术，其中 Segment 继承于 ReentrantLock。不会像 HashTable 
		那样不管是 put 还是 get 操作都需要做同步处理，理论上 ConcurrentHashMap 支持 CurrencyLevel (Segment 数组
		数量)的线程并发。每当一个线程占用锁访问一个 Segment 时，不会影响到其他的 Segment。
				
		concurrentHashMap的put（）源码：
		
		final V putVal(K key, V value, boolean onlyIfAbsent) {
				if (key == null || value == null) throw new NullPointerException();
					-------------------------------------------------
						ConcurrentHashMap的键和值不能为空。
					-------------------------------------------------
				int hash = spread(key.hashCode());
					-------------------------------------------------
					--spread(key.hashCode())的详解：
						 static final int HASH_BITS = 0x7fffffff;
						 Integer.MAX_VALUE = 0x7fffffff;
						 转成十进制为：2147483647
						 转为二进制：01111111111111111111111111111111
						  首位：0表示正数， 1表示负数
						 
						 static final int spread(int h) {
							return (h ^ (h >>> 16)) & HASH_BITS;
						}
						高16位 与 低16位进行异或 运算， 在与  HASH_BITS 进行 & 运算
						为什么要在与 HASH_BITS 进行 & 运算 ?
							答：&运算，只有都为1才返回1，该HASH_BITS是个正数，高位肯定为0，所以，不论传入的key值的hashcode
						是个正数还是负数，转换后，都会的到一个正数的hash值。
							spread(int h) 的作用其实就是避免hash值是负数，大概是因为ConcurrentHashMap内置了MOVED、
						TREEBIN、RESERVED这3个hash，是负数，为了避免冲突吧。
						
						如下，内置了三个负数：
						static final int MOVED     = -1; // hash for forwarding nodes
						static final int TREEBIN   = -2; // hash for roots of trees
						static final int RESERVED  = -3; // hash for transient reservations
						static final int HASH_BITS = 0x7fffffff; // usable bits of normal node hash
						--问；这三个内置负数的作用？
					-------------------------------------------------
				int binCount = 0;
				for (Node<K,V>[] tab = table;;) {
						--table：初始化的数组
					Node<K,V> f; int n, i, fh;
					if (tab == null || (n = tab.length) == 0)
						--如果初始化的数组是空的，或者没有存放过元素，则需初始化该数组
						tab = initTable();
						-------------------------------------------------
							private final Node<K,V>[] initTable() {
								Node<K,V>[] tab; int sc;
								while ((tab = table) == null || tab.length == 0) {
									if ((sc = sizeCtl) < 0)
									------------------------------------------------
										--sizeCtl是什么
											答：数组初始容量
											问：在什么情况下会成为负数？
									------------------------------------------------
										Thread.yield(); // lost initialization race; just spin
									else if (U.compareAndSwapInt(this, SIZECTL, sc, -1)) {
										--------------------------------------------------------------------------
										这个U是什么？
											private static final sun.misc.Unsafe U;
											U = sun.misc.Unsafe.getUnsafe();
											sun.misc.Unsafe 是JDK内部用的工具类，该类不应该在JDK核心类库之外使用。
											this:当前对象
											SIZECTL:偏移量
											sc:期望值
											-1：期望值修改后的值
											该方法的在作用是：
												compareAndSwap是个原子方法,原理是CAS,即将内存中的值与期望值进行比较，如果相等，
											就将内存中的值修改成新值并返回true。
												--但是在此处并没有修改成-1，当SIZECTL为16时，才会修改？？为什么？
										--------------------------------------------------------------------------
										try {
											if ((tab = table) == null || tab.length == 0) {
												int n = (sc > 0) ? sc : DEFAULT_CAPACITY;
												--------------------------------------------------------------------------
													如果sc>0, 则该数组长度为sc
													如果sc不大于0, 则数组长度为DEFAULT_CAPACITY = 16
												--------------------------------------------------------------------------
												@SuppressWarnings("unchecked")
												Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
												table = tab = nt;
												sc = n - (n >>> 2);
												--------------------------------------------------------------------------
													因为concurrentHashMap的长度会在定义时，转化为2^n次幂，所以每个n转化为2进制，
												其实都是： 4：0010  8：0100  16：1000
												无条件右移2位时，其实都是 除2再除2，即除4；
												所以此时的sc = n*0.75 
												看上像是当前数组的扩容临界值，但是实在扩容因子为0.75的情况下。
												如果将扩容因子改成1， 那么该值就不是这样的解释了。
												那么该值的作用是啥？？
												--------------------------------------------------------------------------
												
											}
										} finally {
											sizeCtl = sc;
										}
										break;
									}
								}
								return tab;
							}
						-------------------------------------------------
					else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
						----------------------------
							通过hash，获取索引值
						----------------------------
						if (casTabAt(tab, i, null,
									 new Node<K,V>(hash, key, value, null)))
								-----------------------------------
									查看tab数组中的 i 位置是为null。就直接casTabAt(tab, i, null, new Node<K,V>(hash, key, value, null))
								使用CAS向tab中的第i个位置存入一个node类型的键值对然后退出循环。如果casTabAt失败了，后面还会再循环
								到这一步，也就是使用CAS自旋的往这个位置放入节点。
								-----------------------------------
							break;                   // no lock when adding to empty bin
					}
					else if ((fh = f.hash) == MOVED)
						tab = helpTransfer(tab, f);
					else {
						V oldVal = null;
						synchronized (f) {
							if (tabAt(tab, i) == f) {
								if (fh >= 0) {
									binCount = 1;
									for (Node<K,V> e = f;; ++binCount) {
										K ek;
										if (e.hash == hash &&
											((ek = e.key) == key ||
											 (ek != null && key.equals(ek)))) {
											oldVal = e.val;
											if (!onlyIfAbsent)
												e.val = value;
											break;
										}
										Node<K,V> pred = e;
										if ((e = e.next) == null) {
											pred.next = new Node<K,V>(hash, key,
																	  value, null);
											break;
										}
									}
								}
								else if (f instanceof TreeBin) {
									Node<K,V> p;
									binCount = 2;
									if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
																   value)) != null) {
										oldVal = p.val;
										if (!onlyIfAbsent)
											p.val = value;
									}
								}
							}
						}
						if (binCount != 0) {
							if (binCount >= TREEIFY_THRESHOLD)
								treeifyBin(tab, i);
							if (oldVal != null)
								return oldVal;
							break;
						}
					}
				}
				addCount(1L, binCount);
				return null;
			}	

put方法的总结：
	1、先传入一个k和v的键值对，不可为空（HashMap是可以为空的），如果为空就直接报错。
	2、接着去判断table是否为空，如果为空就进入初始化阶段。
	3、如果判断数组中某个指定的桶是空的，那就直接把键值对插入到这个桶中作为头节点，而且这个操作不用加锁。
	4、如果这个要插入的桶中的hash值为-1，也就是MOVED状态（也就是这个节点是forwordingNode），那就是说明有线程正在进行扩容操作，
那么当前线程就进入协助扩容阶段。
	5、需要把数据插入到链表或者树中，如果这个节点是一个链表节点，那么就遍历这个链表，如果发现有相同的key值就更新value值，如果遍历完了都没有发现相同的key值，就需要在链表的尾部插入该数据。插入结束之后判断该链表节点个数是否大于8，如果大于就需要把链表转化为红黑树存储。
	6、如果这个节点是一个红黑树节点，那就需要按照树的插入规则进行插入。
	7、put结束之后，需要给map已存储的数量+1，在addCount方法中判断是否需要扩容
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
				
		
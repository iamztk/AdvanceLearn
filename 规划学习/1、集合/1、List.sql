1、List 继承的类：
	public interface List<E> extends Collection<E>
	Collection是集合类的顶尖接口

2、常用的List实现类：
	a、ArrayList
	b、LinkedList
	c、vector
-----------------------------------------------------------------ArrayList------------------------------------------------------
3、ArrayList
	a、ArrayList继承和实现的类：
		public class ArrayList<E> extends AbstractList<E>
			implements List<E>, RandomAccess, Cloneable, java.io.Serializable
		
		--AbStractList继承实现的类
		public abstract class AbstractList<E> extends AbstractCollection<E> implements List<E> 
	
	b、ArrayList的存储结构：
		底层使用的是动态数组。
		
	c、ArrayList添加数据流程：
		1、构造函数：
			new ArrayList();				
			new ArrayList(int);
			new ArrayList(Collection<? extends E>);
			
		2、new ArrayList();讲解：
			初始化ArrayList对象，此时该对象是个空对象（null）,只有在第一次添加数据时，会自动扩容到10。
			--该空数组，在第一次add的时候会进行赋值。
			private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};
			
			public ArrayList() {
				this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
			}
			
			--在第一次add时：
			private void ensureCapacityInternal(int minCapacity) {
				if (elementData == DEFAULTCAPACITY_EMPTY_ELEMENTDATA) {
					--第一次add,肯定会走这里，因为在构造方法中已经对elementData赋值了。
					--private static final int DEFAULT_CAPACITY = 10;  对DEFAULT_CAPACITY初始化
					--所以，在第一次add时，会变成长度为10的数组
					minCapacity = Math.max(DEFAULT_CAPACITY, minCapacity);
				}
				ensureExplicitCapacity(minCapacity);
			｝
		3、new ArrayList(int)详解：
			public ArrayList(int initialCapacity) {
				if (initialCapacity > 0) {
					this.elementData = new Object[initialCapacity];
				} else if (initialCapacity == 0) {
					-- private static final Object[] EMPTY_ELEMENTDATA = {};
					--传入参数为0时，会将elementData默认为EMPTY_ELEMENTDATA
					this.elementData = EMPTY_ELEMENTDATA;
				} else {
					throw new IllegalArgumentException("Illegal Capacity: "+
													   initialCapacity);
				}
			}
		
			问：当传入的参数为0时，则elementData=EMPTY_ELEMENTDATA，那么在add的时候就是会扩容？扩容成多大？
			
				答： 是会扩容，会扩容成1的大小。
				--如果初始化有参构造器，则在添加第一个数据时：minCapacity = 1
				--由于传参为0，则oldCapacity = elementData.length = 0
				--经过计算，那么newCapacity = 0
				--此时newCapacity  - minCapacity = 0 - 1 = -1 < 0 所以，是扩容到了1
				private void grow(int minCapacity) {
					int oldCapacity = elementData.length;
					int newCapacity = oldCapacity + (oldCapacity >> 1);
					if (newCapacity - minCapacity < 0)
						newCapacity = minCapacity;
					if (newCapacity - MAX_ARRAY_SIZE > 0)
						newCapacity = hugeCapacity(minCapacity);
					// minCapacity is usually close to size, so this is a win:
					elementData = Arrays.copyOf(elementData, newCapacity);
				}

		--总结：
			1、ArrayList的底层结构是动态数组，所以，有数组的特定属性，其内存储的元素有序可重复，该有序是指会记录元素存入时的添加顺序。
			同时由于是数组，所有在进行数据操作时；查询和更新都比较快，而新增和删除都比较慢。
			2、初始化的方式有三种，常用一二种。
			3、扩容方式：
				原数组长度的1.5倍。
				--小技巧：
					oldCapacity >> 1  任何数据项左移一位，相当于除2  oldCapacity >> 1 = oldCapacity/2
					
-----------------------------------------------------------------LinkedList------------------------------------------------------			
4、LinkedList:
		a、继承和实现的类：
			public class LinkedList<E>
				extends AbstractSequentialList<E>
				implements List<E>, Deque<E>, Cloneable, java.io.Serializable
			
			public abstract class AbstractSequentialList<E> extends AbstractList<E> 
			
			可知LinkedList和ArrayList都是继承自AbstractList抽象类
		
		b、LinkedList底层存储结构：
			LinkedList底层使用的是双向链表
			
			其内数据用节点对象存储：
				--正因为有上下节点的存在，才让链表实现了双向
				    private static class Node<E> {
						E item; --元素
						Node<E> next; --上一节点
						Node<E> prev; --下一节点

						Node(Node<E> prev, E element, Node<E> next) {
							this.item = element;
							this.next = next;
							this.prev = prev;
						}
					}
		
		c、LinkedList添加数据流程：
			a、构造函数：
				new LinkedList();
				new LinkedList(Collection<? extends E>);
			
			b、new LinkedList() 讲解：
				1、创建LinkedList对象：
					 public LinkedList() { }
				
				2、调用add()方法添加元素：
				
					 public boolean add(E e) {
						linkLast(e);
						return true;
					}
				
					void linkLast(E e) {
						final Node<E> l = last;
						final Node<E> newNode = new Node<>(l, e, null);
						--将链表中的最后一个元素赋值给变量：l
						--新建一个节点： 同时将节点e的上一个节点赋值给：l， 则新添加的元素的上一个节点就是原先链表的最后一个元素
						--在将链表的last指针指向新添加的节点
						--如果l==null，则原先链表就是空的，再讲first指针指向新添加的节点
						--如果l!=null, 则将l节点的下一个节点的指针指向新添加的节点。
						last = newNode;
						if (l == null)
							first = newNode;
						else
							l.next = newNode;
						size++;
						modCount++;
					}
					
		总结：
			1、LinkedList底层是双向链表，所以其内存储的数据有序且可重复。
			2、由于是双向链表，所以对于数据操作的新增和删除都比较快，因为只需要改变节点指针指向。
			
-----------------------------------------------------------------Vector------------------------------------------------------			
5、Vector:
	a、继承和实现的类：
		public class Vector<E>
			extends AbstractList<E>
			implements List<E>, RandomAccess, Cloneable, java.io.Serializable
			
		Vector与ArrayList继承实现的类一致
	
	b、构造函数：
		1、new Vector();
			public Vector() {
				this(10); --无参构造器调用了有一个参数的构造器
			}
			
		2、new Vector(int);
			public Vector(int initialCapacity) {
				this(initialCapacity, 0);  --有一个参数的构造器调用了有两个参数的构造器
			}
			
		3、new Vector(int, int); --第一个int是初始化数组大小。第二个int是扩容的大小。
			public Vector(int initialCapacity, int capacityIncrement) {
				super();
				if (initialCapacity < 0)
					throw new IllegalArgumentException("Illegal Capacity: "+
													   initialCapacity);
				this.elementData = new Object[initialCapacity];  --初始化数组大小
				this.capacityIncrement = capacityIncrement;	--设置扩容量
			}
	
	c:new Vector()添加数据的流程：
		public synchronized boolean add(E e) {  --请注意，add方法含有synchronized关键字修饰，是个线程安全的方法
			modCount++;
			ensureCapacityHelper(elementCount + 1);
			elementData[elementCount++] = e;
			return true;
		}
		
		 private void ensureCapacityHelper(int minCapacity) {
			--判断是否需要扩容
			if (minCapacity - elementData.length > 0)
				grow(minCapacity);
		}
		
		--扩容的方法
		private void grow(int minCapacity) {
			int oldCapacity = elementData.length;
			int newCapacity = oldCapacity + ((capacityIncrement > 0) ?   --capacityIncrement：这就是初始化的时候赋的值
											 capacityIncrement : oldCapacity);
			if (newCapacity - minCapacity < 0)
				newCapacity = minCapacity;
			if (newCapacity - MAX_ARRAY_SIZE > 0)
				newCapacity = hugeCapacity(minCapacity);
			elementData = Arrays.copyOf(elementData, newCapacity);
		}
		
	
	d：总结
		1、Vector 与 ArrayList类似，底层也是动态数组，但是由于是线程安全的，所以想能都较低。
		2、扩容方式：
			扩容长度是原长度的两倍，及原来长度为10的数组，扩容后成长度为20的数组。
			
			
综上比较三种方式的区别：
	1、ArrayList：
		a、动态数组,其内元素有序，可重复。
		b、未初始化长度，则在第一次添加元素时调用扩容机制。
		c、1.5倍扩容。
		d、非线程安全。
	2、LinkedList:
		a、双向链表，其内元素有序，可重复。
		b、元素存储在Node对象中，LinkedList有静态的内部内Node。
		c、非线程安全。
	3、Vector:
		a、动态数组，其内元素有序可重复。
		b、未初始化长度，其数组初始容量则为10。
		c、如果没有指定每次扩容打下， 则默认2倍扩容。也可指定每次的扩容大小
		d、其内大多数方法是线程安全的，使用了synchronized修饰。
	
		
6、ArrayList和LinkedList哪个更占内存？
	答：一般情况下，是LinkedList，因为其内每个节点都要维护上下两个节点的指针。
		但也不是绝对的，因为ArrayList存在扩容机制，当刚好ArrayList扩容后，而数组又没有什么数据时，
	ArrayList可能更占内存。
		但是由于ArrayList的元素是由transient关键字修饰的，如果集合本身要做序列化的话，在ArrayList
	中多余的部分是不会被序列化的。
		所以ArrayList的设计者将elementData设计为transient，然后在writeObject方法中手动将其序列化，
	并且只序列化了实际存储的那些元素，而不是整个数组。
	
7、ArrayList中的transient elementData[]:
		
	Serializable:
		序列化：将 Java 对象转换成字节流的过程。
		反序列化：将字节流转换成 Java 对象的过程。
		
		当 Java 对象需要在网络上传输 或者 持久化存储到文件中时，就需要对 Java 对象进行序列化处理。
		序列化的实现：类实现 Serializable 接口，这个接口没有需要实现的方法。实现 Serializable 接口是为了告诉 jvm 这个类的对象可以被序列化。

		注意事项：
			某个类可以被序列化，则其子类也可以被序列化
			声明为 static 和 transient 的成员变量，不能被序列化。static 成员变量是描述类级别的属性，transient 表示临时数据
			反序列化读取序列化对象的顺序要保持一致

		
			java的serialization提供了一个非常棒的存储对象状态的机制，说白了serialization就是把对象的状态存储到硬盘上 去，
		等需要的时候就可以再把它读出来使用。有些时候像银行卡号这些字段是不希望在网络上传输的，
		transient的作用就是把这个字段的生命周期仅存于调用者的内存中而不会写到磁盘里持久化，
		意思是transient修饰的age字段，他的生命周期仅仅在内存中，不会被写到磁盘中。
			
			
		在ArrayList中存在 transient elementData[];
			ArrayList集合中的元素是transient修饰的。
			并且对于该字段有专门的方法：
				ArrayList.writeObject()进行处理，从而使得在扩容时，尽量降低内存空间的浪费。
			对于在数组中没有值的索引不予以分配内存空间。
			
		问题：请问集合的底层是数组，经过扩容后，数组大小为：34， 目前有元素23个，那么
		请问该集合所占的内存空间是多少，比23大吗？为什么？
		
		
8、CopyOnWriteArrayList： 线程安全的list		

			
			
	
































	
			
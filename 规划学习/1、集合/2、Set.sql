1、Set继承的类：
	public interface Set<E> extends Collection<E>
	
2、常用的Set实现类：
	a、HashSet
	b、LinkedHashSet
	c、HashTable
	d、TreeSet
	
3、HashSet：
	a、继承实现的类：
		public class HashSet<E>
			extends AbstractSet<E>
			implements Set<E>, Cloneable, java.io.Serializable
		
		--相比于ArrayList少了RandomAccess
	
	b、HashSet的存储结构：
		哈希表（数组+链表+红黑树）【在jdk1.7之前哈希表的数据结构为：数组+链表】
		
	c、HashSet添加数据流程：
		
		1、常用构造函数：
		
			a、new HashSet();
				public HashSet() {
					map = new HashMap<>();
				}
						
			b、new HashSet(int);
				 public HashSet(int initialCapacity) {
					map = new HashMap<>(initialCapacity);
				}
				
		2、new HashSet()添加数据流程：
					
			public boolean add(E e) {
				return map.put(e, PRESENT)==null;
			}
			a、调用add方法，实际上是调用了Map的put方法，添加的值作为key进行存储
				 PRESENT：是一个空对象 private static final Object PRESENT = new Object();
			
			--调用HashMap的方法：
			public V put(K key, V value) {
				return putVal(hash(key), key, value, false, true);
			}
			b、该方法中调用了hash(key)，是获取hash值的方法，为的是获取数组中的随机索引值，即添加的该元素存储在哈希表中的哪个位置。
			
			--真正的处理方法：
			final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
				Node<K,V>[] tab; Node<K,V> p; int n, i;
				if ((tab = table) == null || (n = tab.length) == 0)
					n = (tab = resize()).length;
					--如果table【数组】为空，则进行扩容
				if ((p = tab[i = (n - 1) & hash]) == null)
					tab[i] = newNode(hash, key, value, null);
					--数组相应索引位置的值为空，则直接将节点数据插入该数组索引位置
				else {
					--如果数组相应索引位置不为空，则需要进行各项判断
					Node<K,V> e; K k;
					if (p.hash == hash &&
						((k = p.key) == key || (key != null && key.equals(k))))
						--判断1：该索引位置原来的值是否与我现在add的值相同，如果相同，则直接替换。
						e = p;
					else if (p instanceof TreeNode)
						--判断2：不相同，则需要判断当前节点是否是个树节点，如果是，则走红黑树的新增逻辑。
						e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
					else {
						--判断3：如果不是一棵数，则说明还是个链表，则需要走链表的逻辑：
						for (int binCount = 0; ; ++binCount) {
							if ((e = p.next) == null) {
								--判断4：当前索引位置的下一个节点是否为空，如果为空，则直接插入该节点的后面
								p.next = newNode(hash, key, value, null);
								if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
									treeifyBin(tab, hash);
								break;
							}
							--判断5：当前索引位置的下一个节点，不为空，则判断，该节点的值是否与add的值相同，如果相同则直接break循环。
							if (e.hash == hash &&
								((k = e.key) == key || (key != null && key.equals(k))))
								break;
							--否则就将e复制给p，即指针指向下一个节点，再往后轮询判断。
							p = e;
						}
					}
					if (e != null) {
						V oldValue = e.value;
						if (!onlyIfAbsent || oldValue == null)
							e.value = value;
						afterNodeAccess(e);
						return oldValue;
					}
				}
				++modCount;
				if (++size > threshold)
					--整个HashSet的长度是否超过了 threshold = 数组长度 * 扩容因子  例如：默认的数组长度为：16， 默认的扩容因子为：0.75
					resize();
				afterNodeInsertion(evict);
				return null;
			}
			总结：
				该方法主要逻辑：
					1、HashSet在jdk1.8以后是数组 + 链表 + 红黑树
					2、在进行数据存储前，会计算该key值的哈希值
					3、数据存储时先判断该HashSet中的数组是否为空 或者 数组的长度为空
					4、为空则需要扩容
					5、扩容后则数组就不在为空，这时通过第2步的哈希值与[数组长度-1]进行位运算，计算出一个值，该值则为数组的索引值。
					6、判断该索引出是否存在数据
					7、存在，则需要判断目前的存储结果是否为树结构，如果是，则要走红黑树的 存储逻辑
					8、如果是链表结构，则需要判断该索引出的原来的值是否与现在add的值相同，如果相同则替换
					9、如果不同，则需要依次循环判断，该add的值与该链表上的每个元素是否相同，如果相同，则替换
					10、如果整个链表都没有相同的，则将该值添加在结尾
					11、添加完以后，还需要进行判断：
						当前数组长度是否超过了限定值【限定值 = 数组长度 * 扩容因子】
						是：则需要进行扩容，默认两倍扩容
			
			
			--相应的扩容方法：
			final Node<K,V>[] resize() {
				Node<K,V>[] oldTab = table;
				int oldCap = (oldTab == null) ? 0 : oldTab.length;
				int oldThr = threshold;
				int newCap, newThr = 0;
				if (oldCap > 0) {
					if (oldCap >= MAXIMUM_CAPACITY) {
						threshold = Integer.MAX_VALUE;
						return oldTab;
					}
					else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
							 oldCap >= DEFAULT_INITIAL_CAPACITY)
						newThr = oldThr << 1; // double threshold
				}
				else if (oldThr > 0) // initial capacity was placed in threshold
					newCap = oldThr;
				else {               // zero initial threshold signifies using defaults
					newCap = DEFAULT_INITIAL_CAPACITY;
					newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
				}
				if (newThr == 0) {
					float ft = (float)newCap * loadFactor;
					newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
							  (int)ft : Integer.MAX_VALUE);
				}
				threshold = newThr;
				@SuppressWarnings({"rawtypes","unchecked"})
					Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
				table = newTab;
				if (oldTab != null) {
					for (int j = 0; j < oldCap; ++j) {
						Node<K,V> e;
						if ((e = oldTab[j]) != null) {
							oldTab[j] = null;
							if (e.next == null)
								newTab[e.hash & (newCap - 1)] = e;
							else if (e instanceof TreeNode)
								((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
							else { // preserve order
								Node<K,V> loHead = null, loTail = null;
								Node<K,V> hiHead = null, hiTail = null;
								Node<K,V> next;
								do {
									next = e.next;
									if ((e.hash & oldCap) == 0) {
										if (loTail == null)
											loHead = e;
										else
											loTail.next = e;
										loTail = e;
									}
									else {
										if (hiTail == null)
											hiHead = e;
										else
											hiTail.next = e;
										hiTail = e;
									}
								} while ((e = next) != null);
								if (loTail != null) {
									loTail.next = null;
									newTab[j] = loHead;
								}
								if (hiTail != null) {
									hiTail.next = null;
									newTab[j + oldCap] = hiHead;
								}
							}
						}
					}
				}
				return newTab;
			}
			
		总结：	
			HashSet:
				1、底层是数组+链表+红黑树， 所以元素不可重复，且无序，存入和读取的顺序是不一致的	
					因为存入的时候，插入的位置是通过HashCode来确定的。
					而取出的顺序是通过数组来获取的。所以存入和读取的顺序不一定一致。
					例如：存入 b, c, d, a   取出的顺序为：a, b, c, d
					因为通过计算其HashCode后，存放在数组中的位置就是：a,b,c,d，所以取出时也是按这个顺序。
					
				2、两倍扩容，但不想List，达到集合长度了才扩容，set是达到了集合长度*扩容因子后就扩容
				3、扩容的不同情况 ：
					a、其内元素达到限定值后，数组长度扩容两倍。
					b、当链表长度达到8时，扩容
					c、当链表长度达到8，且数组长度为64时，链表转为红黑树
					d、当HashSet中存入数据不发生哈希冲突时，则，一直就是一个数组
			
4、LinkedHashSet
	a、继承实现的类：
		public class LinkedHashSet<E>
			extends HashSet<E>
			implements Set<E>, Cloneable, java.io.Serializable 
	
		--继承与HashSet
	
	b、底层存储结构：
		由于是继承自HashSet，所以其存储结构与HashSet一致，底层都是数组+链表+红黑树
		
	c、LinkedListSet添加数据流程：
		1、new LinkedHashSet();
				public LinkedHashSet() {
					super(16, .75f, true);
				}
				
				--super调用的HashSet中的方法：
				 HashSet(int initialCapacity, float loadFactor, boolean dummy) {
					map = new LinkedHashMap<>(initialCapacity, loadFactor);
				}
				
				--再调用LinkedHashMap中的方法：
				public LinkedHashMap(int initialCapacity, float loadFactor) {
					super(initialCapacity, loadFactor);
					accessOrder = false;
				}
		
				--最后又来到了HashMap中
				public HashMap(int initialCapacity, float loadFactor) {
					if (initialCapacity < 0)
						throw new IllegalArgumentException("Illegal initial capacity: " +
														   initialCapacity);
					if (initialCapacity > MAXIMUM_CAPACITY)
						initialCapacity = MAXIMUM_CAPACITY;
					if (loadFactor <= 0 || Float.isNaN(loadFactor))
						throw new IllegalArgumentException("Illegal load factor: " +
														   loadFactor);
					this.loadFactor = loadFactor;
					this.threshold = tableSizeFor(initialCapacity);
				}
		
		总结：	
			1、元素不重复，但有序，存入和读取的顺序是一致的。
				例如：存入 b, c, a, b 取出的数据为： b, c, a
			2、为什么有序？
				因为每一个节点之间都是由
				
	
5、TreeSet

6、HashTable



















			
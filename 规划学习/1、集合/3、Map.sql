1、继承和实现的类：
	public interface Map<K,V> {}  
	map是顶级接口，上面不再有实现或继承别的接口或类
	
2、	常用的Map类：
	a、HashMap
	b、LinkedHashMap
	c、HashTable
	d、TreeMap
	
3、HashMap：
	a、继承和实现的类：
		public class HashMap<K,V> extends AbstractMap<K,V>
				implements Map<K,V>, Cloneable, Serializable {}
	
	b、HashMap的存储结构：
		底层使用:数组+链表+红黑树
		
	c、HashMap添加数据流程：
		与HashTable一致，只是HashSet在调用HashMap的构造方法时，传入的value=空对象
		二HashMap存储的键值对数据时，对value的值不做要求，只要符合其数据类型就行，主要对key值有要求
		HashMap的key和value都可以为null，但key只允许一个为null;
		
		另由于HashMap特有的存储结构，所以，其获取value有多种方式，获取方式日下：
			1、已知key直接获取value
				map.get(key);
			2、通过keySet()方法。获取key的集合
				Set<String> set = map.keySet();
				Iterator<String> iterator = set.iterator();
				while (iterator.hasNext()){
					--因为通过迭代获取的是map的key，所以还需要通过get方法获取value的值
					System.out.println(map.get(iterator.next()));
				} 
			3、通过entrySet()方法，获取其内数据对象：
				 static class Node<K,V> implements Map.Entry<K,V> {
					final int hash;
					final K key;
					V value;
					Node<K,V> next;
				｝

				--将map中的每个元素存入set中  【元素是以Map.Entry对象存储的】
				Set<Map.Entry<String, String>> entry = map.entrySet();
				Iterator<Map.Entry<String, String>> it = entry.iterator();
				while (it.hasNext()){
					--因为存入的是Map.Entry对象，所以取出的也是其对象
					Map.Entry<String, String> next = it.next();
					--Map.Entry特有的方法，getKey()获取key, getValue()获取value
					String key = next.getKey();
					String value = next.getValue();
					System.out.println("方式三：" + key + "-" + value);
				}
	
	总结：
		1、底层是数组+链表+红黑树 【单向链表】
		2、存储的元素中key不能重复，value无所谓
		3、存储元素无序，不重复
		4、扩容：
			默认数组长度为16，2倍扩容，附加扩容因子
			
	补充：
		1、new Map(int),原则上传入的参数必须是2的n次幂， 但是当new Map(5)也是可以的？
				---创建对象，传入初始长度
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
					--在此处会对传入的数据做处理
					this.threshold = tableSizeFor(initialCapacity);
				}
				
				--这个处理会保证将传入的数据转为大于参数的最小的2的n次幂			
				static final int tableSizeFor(int cap) {
					int n = cap - 1;
					n |= n >>> 1;  -- 等价于  n = n | n >>> 1
					n |= n >>> 2;
					n |= n >>> 4;
					n |= n >>> 8;
					n |= n >>> 16;
					return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;					
				}
		2、为什么需要设置成这样呢？保证每次扩容后，数组的长度都为素数？
				这样可以降低哈希冲突，冲突越少，HashMap效率越高。
		
4、LinkedHashMap:
		a、实现和继承的类：
			public class LinkedHashMap<K,V>
				extends HashMap<K,V>
				implements Map<K,V>
		
		b、底层数据结构：
			数组+链表+红黑树 + 【保证有序的：双向链表】			
			
		
		
5、TreeMap
		a、实现和继承的类：	
			public class TreeMap<K,V>
				extends AbstractMap<K,V>
				implements NavigableMap<K,V>, Cloneable, java.io.Serializable
			{
			
		b、底层存储结构：
			红黑树
			
			
6、HashTable:
		a、实现和继承的类：
			public class Hashtable<K,V>
				extends Dictionary<K,V>
				implements Map<K,V>, Cloneable, java.io.Serializable 
		
		b、底层数据结构：
			与HashMap一致， 数组 + 链表 + 红黑树
				
		c、特点：
			1、线程安全， 但是效率过于低下，目前都是采用ConcurrentHashMap
			2、扩容量： 2 * table.length + 1
			
		
		
		
		
		
		
		
		
		
			
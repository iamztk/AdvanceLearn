1、数组转集合
		String[] str = {"a", "b", "c"};
        
		--数组转集合方式一：
        List<String> arrayList = new ArrayList(str.length);
        for (int i = 1; i <= str.length; i++){
            arrayList.add(str[i-1]);
        }
       System.out.println(arrayList);  --返回[a,b,c]
	   
	   --数组转集合方式二：	   	   
	    List<String> list = Arrays.asList(str);  --通过Arrays集合工具类进行转换
        list.add("d");
        Iterator<String> iterator = list.iterator();
        while(iterator.hasNext()){
            System.out.println(iterator.next());
        }
		
		使用方式二进行转换时，有几点需注意：
			1、Arrays.asList(T...str), 该参数不可以是基本数据类型
				因为参数是可变参数，并且还有应用了类似泛型的数据类型，该参数的实际类型T 是继承了 object 的，所以传递的参数是一个对像。
				所以当基本数据类型为参数传递进去时，会默认基本数据类型为一个对象，所以得到的结果只有一个值。
			
			2、List<Integer> integers = Arrays.asList(1, 2, 3, 4);
				看上去返回值是一个List,实际上该ArrayList是Arrays中的一个内部类，虽然也继承了AbstractList,但是它没有重写add等方法，所以相应
				的调用add方法时，会报如下错误：【java.lang.UnsupportedOperationException】
				 public static <T> List<T> asList(T... a) {
					return new ArrayList<>(a);
				}
	
				 private static class ArrayList<E> extends AbstractList<E>
					implements RandomAccess, java.io.Serializable
				{
					private static final long serialVersionUID = -2764017481108945198L;
					private final E[] a;

					ArrayList(E[] array) {
						a = Objects.requireNonNull(array);
					}
					.....
				}
			3、因为没有重写add(), remove()方法，所以不能修改数组的长度。当不需要更改数组长度时，可以使用asList();
			 但是也尽量不要使用。
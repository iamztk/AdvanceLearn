1������ת����
		String[] str = {"a", "b", "c"};
        
		--����ת���Ϸ�ʽһ��
        List<String> arrayList = new ArrayList(str.length);
        for (int i = 1; i <= str.length; i++){
            arrayList.add(str[i-1]);
        }
       System.out.println(arrayList);  --����[a,b,c]
	   
	   --����ת���Ϸ�ʽ����	   	   
	    List<String> list = Arrays.asList(str);  --ͨ��Arrays���Ϲ��������ת��
        list.add("d");
        Iterator<String> iterator = list.iterator();
        while(iterator.hasNext()){
            System.out.println(iterator.next());
        }
		
		ʹ�÷�ʽ������ת��ʱ���м�����ע�⣺
			1��Arrays.asList(T...str), �ò����������ǻ�����������
				��Ϊ�����ǿɱ���������һ���Ӧ�������Ʒ��͵��������ͣ��ò�����ʵ������T �Ǽ̳��� object �ģ����Դ��ݵĲ�����һ������
				���Ե�������������Ϊ�������ݽ�ȥʱ����Ĭ�ϻ�����������Ϊһ���������Եõ��Ľ��ֻ��һ��ֵ��
			
			2��List<Integer> integers = Arrays.asList(1, 2, 3, 4);
				����ȥ����ֵ��һ��List,ʵ���ϸ�ArrayList��Arrays�е�һ���ڲ��࣬��ȻҲ�̳���AbstractList,������û����дadd�ȷ�����������Ӧ
				�ĵ���add����ʱ���ᱨ���´��󣺡�java.lang.UnsupportedOperationException��
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
			3����Ϊû����дadd(), remove()���������Բ����޸�����ĳ��ȡ�������Ҫ�������鳤��ʱ������ʹ��asList();
			 ����Ҳ������Ҫʹ�á�
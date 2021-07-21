问：算法中的O(1), O(,), O(logn), O(nlogn)分别是什么意思？
	答：O(1):最低的时空复杂度，也就是耗时/耗空间与输入数据大小无关。无论数据输入增大多少倍，所耗费的时间/空间都是不变的。
			Hash(哈希算法)就是典型的O(1)时间复杂度。无论数据量有多大，都能在一次计算后找到目标（不考虑冲突的情况下）。
		
		O(n):表示数据量增大几倍，所耗费的时间也增大几倍。比如常见的遍历算法就是O(n)。
			再比如O(n2)[此处是n的平方]：表明数据量增大几倍，耗费的时间就增加几倍的平方。冒泡排序就是典型的O(n2)时间复杂度。
			
		O(logn):表示数据量增大几倍，所耗费的时间也增大logn倍(此处的log是以2为底的，例如当数据增大256倍时，所耗费的时间增大8倍) 2的8次方 = 256
			二分法就是O(logn)的时间复杂度，每次排除一半的可能。
		
		O(nlogn):表示数据量增大n倍，所耗费的时间增大n*logn倍。数据量增大256倍时，所耗费的时间为：256*8 = 2048
			该时间复杂度高于线性，低于平方
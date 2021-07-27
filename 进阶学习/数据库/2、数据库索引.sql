1、索引是什么？有什么用？优缺点？
	答：索引是对数据库表中一或多个列的值进行排序的结构，是帮助mysql高效获取数据的数据结构。

	你也可以这样理解：索引就是加快检索表中数据的方法。数据库的索引类似于书籍的索引。
	在书籍中，索引允许用户不必翻阅完整个书就能迅速地找到所需要的信息。
	在数据库中，索引也允许数据库程序迅速地找到表中的数据，而不必扫描整个数据库。

	MySQL数据库几个基本的索引类型：普通索引、唯一索引、主键索引、全文索引

    a、索引加快数据库的检索速度
	b、索引降低了插入、删除、修改等维护任务的速度
	c、唯一索引可以确保每一行数据的唯一性
	d、通过使用索引，可以在查询的过程中使用优化隐藏器
	e、提高系统的性能索引需要占物理和数据空间。
	
	
	
	2、数据库索引的作用：		
		数据库索引其实就是为了使查询数据效率快。
		
	
	3、数据库的索引有哪些?
		1、聚集索引（主键索引）：数据库中所有的行数都会按照主键索引进行排序
		2、非聚集索引：给非主键的普通列添加索引		
		3、联合索引：多列组成的索引，即为联合索引
		
	4、联合索引遵循最左前缀原则，例如表中有联合索引：key 'idx_age_name_sex' ('age','name','sex')
	    如下有5段查询语句，看下列语句是否会走联合索引
		A:select * from student where age = 16 and name = '小张'
		B:select * from student where name = '小张' and sex = '男'
		C:select * from student where name = '小张' and sex = '男' and age = 18
		D:select * from student where age > 20 and name = '小张'
		E:select * from student where age != 15 and name = '小张'
		F:select * from student where age = 15 and name != '小张'
	解答：
		A:走索引
		B:因为索引最左是age，所以不走索引
		C：虽然查询语句中，最左边是name，但是由于查询的条件中含有age,所以数据库会先优化查询条件：
			select * from student where age = 18 and name = '小张' and sex = '男'
		   优化后会走索引
		D:按最左原则，是走age 和 name的索引的，但是因为age>20是范围，而范围字段会结束索引对范围后面索引字段的使用，
			所以结果是走索引，但是只走age这个索引
		E:不走索引，因为！= （不等于） 不走索引
		F：只走索引age，不走索引name，原因同E
		
	5、另外部分不走索引的情况：
		a、Like：%在前面的不走索引，在后面的走索引
			两个非聚集索引：
				key 'idx_age' ('age'),
				key 'idx_name' ('name')
			查询语句：
				A:select * from student where 'name' like '王%'
				B:select * from student where 'name' like '%小'
			
			A走索引，B不走索引
		
		b、用索引列进行计算的，不走索引		
		
			A:select * from student where age = 10+8
			B:select * from student where age + 8 = 18
			
			A走索引，B不走索引
			
		c、对索引列用函数了，不走索引
		
			A:select * from student where  concat('name','哈') ='王哈哈';
			B:select * from student where name = concat('王哈','哈');
			
			A不走索引，B走索引
			
		d、使用了!= 不走索引
		
			select * from student where age != 18
			
			不走索引
			
			
问题2. 哈希(hash)比树(tree)更快，索引结构为什么要设计成树型？
				
	加快查找速度的数据结构，常见的有两种：
		a、哈希，例如HashMap，查询、插入、修改、删除的平均时间复杂度都是O(1);
		b、树， 例如平衡二叉搜索数，查询、插入、修改、删除平均时间复杂度是O(logn);
		可以看到，不管是读请求还是写请求，哈希类型的索引，都要比树型的索引更快一些。
		那为什么索引结构要设计成树型，而不设计成哈希类型。
		答：索引设计成树型，是和SQL的需求相关。
			对于单行查询的SQL需求，使用哈希确实会更快，因为每次只查询一条记录。
			但是对于其他的，例如：
				分组：group by
				排序：order by
				大于小于等范围相关的查询，哈希型的索引的时间复杂度会退化为O(n)
				而树型的有序特性，依然能保持O(logn)的时间复杂度。
			并且，MYSQL的InnoDB不支持手动创建哈希索引。
			但是其内部会自调优：
				如果建立自适应的哈希索引，能够提高查询效率，InnoDB就会自己建立相关的哈希索引。
			
			但是由于是MYSQL自判断的，所以有可能误判：
				1、很多单行记录查询
				2、索引范围查询，此时AHI可以快速定位首行记录。
				3、所有记录内存放得下
			这几种情况下，自建立的哈希索引能够提高速度
			
			但是在：
				当业务有大量like或者join等操作时
			自建立的哈希索引反而会降低系统效率，所以需程序员自判断是否需要关闭AHI功能。	



问题3. 数据库索引为什么使用B+树？			
	
	为了保持知识体系的完整性，简单介绍下几种树。
	
	第一种：二叉搜索树
		它为什么不适合用作数据库索引？
		(1)当数据量大的时候，树的高度会比较高，数据量大的时候，查询会比较慢；
		(2)每个节点只存储一个记录，可能导致一次查询有很多次磁盘IO；
	
	第二种：B树
		(1)不再是二叉搜索，而是m叉搜索；
		(2)叶子节点，非叶子节点，都存储数据；
		(3)中序遍历，可以获得所有节点；
			非根节点包含的关键字个数j满足，(┌m/2┐)-1 <= j <= m-1，节点分裂时要满足这个条件。
			
		B树被作为实现索引的数据结构被创造出来，是因为它能够完美的利用“局部性原理”。
		
		什么是局部性原理？
			局部性原理的逻辑是这样的：
			(1)内存读写块，磁盘读写慢，而且慢很多；
			(2)磁盘预读：磁盘读写并不是按需读取，而是按页预读，一次会读一页的数据，
				每次加载更多的数据，如果未来要读取的数据就在这一页中，
				可以避免未来的磁盘IO，提高效率；通常，一页数据是4K。
			(3)局部性原理：软件设计要尽量遵循“数据读取集中”与“使用到一个数据，大概率会使用其附近
	
	第三种：B+树
		B+树，仍是m叉搜索树，在B树的基础上，做了一些改进：
		(1)非叶子节点不再存储数据，数据只存储在同一层的叶子节点上；
		   画外音：B+树中根到每一个节点的路径长度一样，而B树不是这样。
		(2)叶子之间，增加了链表，获取所有节点，不再需要中序遍历；
		这些改进让B+树比B树有更优的特性：
		   (1)范围查找，定位min与max之后，中间叶子节点，就是结果集，不用中序回溯；
		        画外音：范围查询在SQL中用得很多，这是B+树比B树最大的优势。
		   (2)叶子节点存储实际记录行，记录行相对比较紧密的存储，适合大数据量磁盘存储；非叶子节点存储记录的PK，用于查询加速，适合内存存储；
		   (3)非叶子节点，不存储实际记录，而只存储记录的KEY的话，那么在相同内存的情况下，B+树能够存储更多索引；
		   最后，量化说下，为什么m叉的B+树比二叉搜索树的高度大大大大降低？大概计算一下：
		   (1)局部性原理，将一个节点的大小设为一页，一页4K，假设一个KEY有8字节，一个节点可以存储500个KEY，即j=500
		   (2)m叉树，大概m/2<= j <=m，即可以差不多是1000叉树
		   (3)那么：一层树：1个节点，1*500个KEY，大小4K
					二层树：1000个节点，1000*500=50W个KEY，大小1000*4K=4M
					三层树：1000*1000个节点，1000*1000*500=5亿个KEY，大小10001000*4K=4G
			画外音：额，帮忙看下有没有算错。可以看到，存储大量的数据（5亿），并不需要太高树的深度（高度3），索引也不是太占内存（4G）。	
			
			
	总结:
		数据库索引用于加速查询,虽然哈希索引是O(1)，树索引是O(log(n))，但SQL有很多“有序”需求，故数据库使用树型索引。
		InnoDB不支持哈希索引数据预读的思路是：磁盘读写并不是按需读取，而是按页预读，一次会读一页的数据，
	每次加载更多的数据，以便未来减少磁盘IO局部性原理：软件设计要尽量遵循“数据读取集中”与“使用到一个数据，
	大概率会使用其附近的数据”，这样磁盘预读能充分提高磁盘IO。
		数据库的索引最常用B+树：
			(1)很适合磁盘存储，能够充分利用局部性原理，磁盘预读；
			(2)很低的树高度，能够存储大量数据；
			(3)索引本身占用的内存很小；
			(4)能够很好的支持单点查询，范围查询，有序性查询；
			
			
问题四：聚集索引和非聚集索引有什么区别？（聚集索引又称为聚簇索引、聚类索引）
		聚集索引：索引和对应的数据值存放在起。
		非聚集索引：索引和对应的数据值是分开的， 索引处存放的是数据值对应的磁盘空间？
		
		问：非聚集索引中树的关键字存储的是什么数据？索引对应的值的磁盘空间地址，还是索引对应的聚集索引值？
			答：如果建表没有主键，那么该表数据就是无序的存放在磁盘存储器上，一行一行排列整齐。
		如果再给这个表添加主键，那么表数据就从排列整齐的一列一列转为树状结构排列，整个表就变成了一个索引，这就是聚集索引。
		主键的其中一个作用就是将表数据从无序的结构转为索引结构的格式存放。
				虽然索引能让查询的速度提高，但是也降低了写入的速度。
				因为，平衡树需要一直维持一个正确的状态。增删改数据都会改变平衡树节点中索引数据的内容，破坏树结构。所以，每次
			有数据变更时，DBMS都会重新梳理树的结构，以达到一个正确的状态。这势必就会带来性能的开销。
			
			非聚集索引与聚集索引差不太多，每建一个非聚集索引，字段中的数据就会被复制一份，用于生成索引，因此，给表添加索引，
		就会增加表的体积，占用磁盘空间。
			
		两者的不同点：
			a、聚集索引一张表只能有一个，而非聚集索引一张表可以有多个。
			b、通过聚集索引可以一次查到需要查找的数据。
			c、而通过非聚集索引第一次只能查到记录对应的主键值 ，再使用主键的值通过聚集索引查找到需要的数据。
		
		那如果没有主键， 只建立索引呢？？
			oracle存储数据使用的是B-Tree，索引和数据是分开的
			Mysql的存储引擎：
				MYISAM: 索引和数据是分开存放的
				InnoDB: 索引和数据是放在一块的
			
			
			
			
			
			
			
			
			
			
			
			
			
			
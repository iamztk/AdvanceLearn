ReentrantLock：

-----------------------------------------------------
	ReentrantLock 实现了接口Lock	
	对于synchronized来说，可以使用wait()使线程休眠，使用notify(),notifyAll()唤醒休眠的线程
	而在reentrantLock中，可以使用Lock中的newCondition()方法，获取Condition对象：
		该对象有：
			condition.await()方法，使线程阻塞
			condition.signl(), condition.singlAll()唤醒线程。
			
		同时condition还能精准唤醒线程。
		例如： condition1.await(), 则可以通过condition1.notifyAll()唤醒线程。
-----------------------------------------------------		


	1、背景
		在jdk 1.6之前，java的内置锁synchronized是备受争议的， 是重量级锁且性能太差。
		Doug Lea 主要成就编写了 java.util.concurrent包
		ReentrantLock所在包：java.util.concurrent.locks下
		
		优点：
			1、性能高
			2、丰富的api
		
		在jdk 1.6后，对synchronized进行了优化，性能与ReentrantLock不相上下，甚至在高并发的情况下，
		synchronized性能会更好，毕竟是亲儿子。
	
	
	2、默认是是非公平锁，什么是默认，即：
		new ReentrandLock();   	 -> 调用默认构造器，则适用的是非公平锁。
		new ReentrantLock(true); -> 调用有参构造器，并且传入参数为true，则调用的是公平锁。
		
		--无参构造器：
		  public ReentrantLock() {
			sync = new NonfairSync();
		}
		--有参构造器：
		  public ReentrantLock(boolean fair) {
			sync = fair ? new FairSync() : new NonfairSync();
		}
		
	3、公平锁与非公平锁
		公平锁：多线程并发情况下，如果有竞争关系，则当有线程持有锁，则后续线程需要进队列，等待锁的释放，
	锁在释放后，需要按照一定的顺序，将队列中的某个线程唤醒，进行后续操作。
		优点：所有线程都能得到资源，都能跑完，不会有饿死在队列中的情况。
		缺点：吞吐量会下降很多，队列中除了第一个下线程外，其他的线程都会阻塞，cpu唤醒阻塞线程的开销会很大。
		
		非公平锁：多线程并发情况下，如果有竞争关系，则当有线程持有锁，后续线程会尝试去获取锁，获取不到则
	进队列排队，如果获取到了，则直接获取锁。
		优点：可以减少CPU唤醒线程的开销，整体的吞吐效率会有所提高，CPU不必唤醒所有线程，会较小唤醒线程
	的开销。
		缺点：有可能导致线程队列中的线程一致获取不到锁，或者长时间获取不到锁，导致饿死。
	
		
	4、ReentrantLock源码分析上锁过程
		AQS(AbstractQueuedSynchronized)类的设计主要代码：
		
		1、加锁过程
			多线程执行模式：交替执行
			线程1：t1
			线程2：t2
			当t1.lock()时：
				场景一：锁是自由的，且无其他线程在排队，即线程队列为空
					当t1.lock()时，首先t1先去试图获取锁:tryAcquire(1)
					在试图获取锁的操作中涉及到一个特别重要的状态值： 
						--The synchronization state. 同步状态
						private volatile int state;
						
						当state == 0时，则表明当前锁没有被占用，则线程就会去查看是否需要排队（即队列中是否有线程在排队）。
						
						
						 public final void acquire(int arg) {
							--试图获取锁的入口： 当tryAcquire(arg)返回true，即获取到了锁之后!tryAcquire(arg)为false，不会进if()方法
							if (!tryAcquire(arg) &&
								acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
								selfInterrupt();
						}
						
						--1、试图获取锁的过程
						protected final boolean tryAcquire(int acquires) {
								final Thread current = Thread.currentThread();
								int c = getState();
								if (c == 0) {
									--2、当同步状态为0时，则会产看是否需要排队，调用hasQueuedPredecessors()方法
									--5、由于hasQueuedPredecessors()方法返回false,所以!hasQueuedPredecessors() 应为true
										--则继续走compareAndSetState(0, acquires)，将state的值从0修改成1，因为tryAcquire(1)，传入的参数是1
										
									--7、当compareAndSetState()方法能修改state的值则返回true，则修改占有锁的线程为当前线程。
									--返回true，则所有方法都能正常执行，直到执行完lock()方法，继续往后执行业务逻辑代码。
									if (!hasQueuedPredecessors() &&
										compareAndSetState(0, acquires)) {
										setExclusiveOwnerThread(current);
										return true;
									}
								}
								else if (current == getExclusiveOwnerThread()) {
									int nextc = c + acquires;
									if (nextc < 0)
										throw new Error("Maximum lock count exceeded");
									setState(nextc);
									return true;
								}
								return false;
							}
						}
						
						--3、当同步状态为0时，则进入该方法
						public final boolean hasQueuedPredecessors() {
							// The correctness of this depends on head being initialized
							// before tail and on head.next being accurate if the current
							// thread is first in queue.
							Node t = tail; // Read fields in reverse initialization order
							Node h = head;
							Node s;
							return h != t &&
								((s = h.next) == null || s.thread != Thread.currentThread());
							--当线程1是第一次进入时，很明显目前tail 和 head 都是为null的，所以 h!= t 应返回false
							--4、所以整个方法返回false。
						}
						
						--6、compareAndSetState: 比较state的值，并修改
						 protected final boolean compareAndSetState(int expect, int update) {
							// See below for intrinsics setup to support this
							return unsafe.compareAndSwapInt(this, stateOffset, expect, update);
							--sun.misc.Unsafe 是JDK内部用的工具类，该类不应该在JDK核心类库之外使用。
								参数详解：
									this：当前对象 【由于是在ReentrantLock中调用的方法，所以此处对象指代ReentrantLock对象】
									stateOffSet：偏移量【不知道是个啥】
										stateOffset = unsafe.objectFieldOffset(AbstractQueuedSynchronizer.class.getDeclaredField("state"));
									expect：期望值【此处是0】
									update：希望修改成的值 【此处是1】
									
								整个方法的意思就是：
									当this的state与期望值expect相等时，即state == expect, 则将state修改成 update的值，即1，并返回true;
									--即能修改成功，就返回true
									当this的state与期望值expeict不想等时，则无法修改state，并返回false；
									--即修改不成功，就返回false；
						}
						
				场景二：锁被占有，但是线程队列中无线程在等待
						当锁被占有时，代表所状态的状态值state != 0, 由于分析场景简单，所以设定为state=1，只由线程t1改变过一次。
						
						
						static final Node EXCLUSIVE = null;
						
						 public final void acquire(int arg) {
							--试图获取锁的入口：
							--3、当tryAcquire(arg)方法返回false，则!tryAcquire(arg) 为true, 往后走，进入acquireQueued(addWaiter(Node.EXCLUSIVE), arg))方法。
							--11、addWaiter(Node.EXCLUSIVE)方法会返回一个新建的node节点，这个节点会包含当前线程，即t2
							if (!tryAcquire(arg) &&
								acquireQueued(addWaiter(Node.EXCLUSIVE), arg))
								selfInterrupt();
						}
						
							--1、试图获取锁的过程
						protected final boolean tryAcquire(int acquires) {
								final Thread current = Thread.currentThread();
								int c = getState();
								if (c == 0) {									
									if (!hasQueuedPredecessors() &&
										compareAndSetState(0, acquires)) {
										setExclusiveOwnerThread(current);
										return true;
									}
								}
								--2、由于state = 1, 所以走的是else if()
									--很显然，current代表的是当前线程t2，而	getExclusiveOwnerThread()获得的是获取锁的线程t1
									--所以肯定是不相等的，即返回false，则最后该方法返回false
								else if (current == getExclusiveOwnerThread()) {
									int nextc = c + acquires;
									if (nextc < 0)
										throw new Error("Maximum lock count exceeded");
									setState(nextc);
									return true;
								}
								return false;
							}
						}
				
							--4、方法acquireQueued(addWaiter(Node.EXCLUSIVE), arg))，会先执行addWaiter(Node.EXCLUSIVE), arg)方法，arg=1
							--5、addWaiter(Node mode)：接受的参数是一个node，返回的值也是一个node						
						private Node addWaiter(Node mode) {
								--创建一个Node，存放的是当前线程t2
							Node node = new Node(Thread.currentThread(), mode);
							// Try the fast path of enq; backup to full enq on failure
								--将等待队列的头部tail赋值给prep
								--由于等待队列中并没有线程，所以该头部的引用肯定是为null的
								--6、所以不会进入if()方法中
							Node pred = tail;
							if (pred != null) {
								node.prev = pred;
								if (compareAndSetTail(pred, node)) {
									pred.next = node;
									return node;
								}
							}
							 --7、再进行enq()方法，参数node为保存了当前线程的节点
							enq(node);
							return node;
						}
										
						在AbstractQueuedSynchronizer（AQS）类中有两个Node节点
							 private transient volatile Node head;  --等待队列的头部
							 private transient volatile Node tail;  --等待队列的尾部
							 
							 可以将这两个参数理解为指针，即head指向的是链表的头部， tail指向的是链表的尾部
							 
							--8、跑enq（）方法							
						 private Node enq(final Node node) {
							for (;;) {
							
									--指向链表尾部的指针tail赋值给节点t
									--节点t肯定为null，所以会进入到if()方法中
									--进行比较和设置：
								Node t = tail;
								if (t == null) { // Must initialize
									if (compareAndSetHead(new Node()))
										tail = head;
										--9、经过此步骤，则指向头部和尾部的指针head，tail都会指向新new的Node【此时该Node内应是空的，没有内容的】
								} else {
									node.prev = t;
									if (compareAndSetTail(t, node)) {
										t.next = node;
										return t;
										--10、由于是个死循环，当tail节点不为空时，则会走else代码块
										--将新建的包含线程t2的node 与第9步的空node串联起来，形成一个双向的链表
										--该双向链表应包含： 空Node 和 包含线程t2的Node
										--且：head指向的是空Node，tail指向的是包含了线程t2的Node
										--并将包含了线程t2的Node返回，继续执行acquireQueued(addWaiter(Node.EXCLUSIVE), arg))方法
									}
								}
							}
						}
						
							--enq()方法中的compareAndSetHead（）设置头部的方法， 如果头部为null，则设置为 new Node();
						 private final boolean compareAndSetHead(Node update) {
							return unsafe.compareAndSwapObject(this, headOffset, null, update);
						}
						
							--enq()方法中的compareAndSetHead（）设置尾部的方法
						private final boolean compareAndSetTail(Node expect, Node update) {
							return unsafe.compareAndSwapObject(this, tailOffset, expect, update);
						}
						

							--12、执行acquireQueued(addWaiter(Node.EXCLUSIVE), arg)中的acquireQueued(node,arg) 此时arg还是等于1
						final boolean acquireQueued(final Node node, int arg) {
							boolean failed = true;
							try {
								boolean interrupted = false;
								for (;;) {
										--13、node.predecessor()方法解析
									final Node p = node.predecessor();
										--经过第14步可知，p就是head，所以，表明线程t2是队列中的第一个排队的线程，所以会试图去获取锁。
										--15-1、如果此时恰好线程t1释放了锁，t2此时又去获取锁，这个时候，就能获取得到锁，则tryAcquire(arg)
											--方法会返回true；
											--即线程t2获取到了锁，获取锁，则队列中就不能再包含t2了，所以就需要将t2剔除掉
											--这个再次调用tryAcquire(arg)方法获取锁，就是自旋
									if (p == head && tryAcquire(arg)) {
										setHead(node);
										p.next = null; // help GC
										failed = false;
										return interrupted;
									}
										--15-2：当t1的锁还未释放，则不会进入上面那个if，走下面if()逻辑。shouldParkAfterFailedAcquire(p,node)方法
										--15-2-2：有15-2-1可知，shouldParkAfterFailedAcquire()方法返回的是false，继续死循环
										--15-2-4： 由15-2-3可知，此时shouldParkAfterFailedAcquire()方法返回的是true,继续执行parkAndCheckInterrupt()方法。
									if (shouldParkAfterFailedAcquire(p, node) &&
										parkAndCheckInterrupt())
										interrupted = true;
								}
							} finally {
									--16-1：对应15-1，由于failed为false，所以不进该方法
									--16-2：对应15-2，什么时候failed = true,从而进入该cancelAcquire()方法？唤醒后？
								if (failed)
									cancelAcquire(node);
							}
						}
						
							
							--14、node.predecessor()方法详解
						final Node predecessor() throws NullPointerException {
								--由于是node.predecessor()调用的方法，该node是值包含了线程t2的那个node
								--prev指的是，获取node.prev,即获取该节点的上一个节点，即那个head指向的空Node
								--虽然是个空Node，但是是指向的一个空节点Node，对象不为空，所以不会走if()代码块。
								--直接返回p，即head，指向的空Node
							Node p = prev;
							if (p == null)
								throw new NullPointerException();
							else
								return p;
						}
						
							
							
							--15-2-1：线程t2，获取锁失败走该方法：
								--Node pred: 表示的是head指针指向的头节点
								--Node node: 表示的是包含了线程t2的节点	
						 volatile int waitStatus;
						 private static boolean shouldParkAfterFailedAcquire(Node pred, Node node) {
								--第一次：显然ws = 0; 所以会跑else代码块
								--15-2-3：第一次跑完后，waitStatus变为了-1， 所以第二次跑，该方法返回的是 true
							int ws = pred.waitStatus;
							if (ws == Node.SIGNAL)								
								return true;
							if (ws > 0) {								
								do {
									node.prev = pred = pred.prev;
								} while (pred.waitStatus > 0);
								pred.next = node;
							} else {	
									--compareAndSetWaitStatus()方法详解见下：
								compareAndSetWaitStatus(pred, ws, Node.SIGNAL);
							}
							return false;
						}
				
							--判断头部head所指向的node的waitStatus是不是等于expect（此处是0），如果等于，则将该值修改成update(此处是-1)
						private static final boolean compareAndSetWaitStatus(Node node, int expect, int update) {
							return unsafe.compareAndSwapInt(node, waitStatusOffset, expect, update);
						}
						
							--15-2-5、由此可知，线程t2在没有获取锁的情况下，会进入队列，经过一系列的操作，最后，线程t2会被park(),即陷入休眠
								--直到被其他线程唤醒，唤醒后继续从这里执行下去
						private final boolean parkAndCheckInterrupt() {
							LockSupport.park(this);
							return Thread.interrupted();
						}
						
						
						

为什么在当队列中只有一个线程节点的时候，是需要进行获取锁的操作？
	答;为了尽量不去park(),如果只有这么一个线程在排队，那么需要
		  UNSAFE.park(false, 0L);
		  public native void park(boolean var1, long var2);
		  有可能是调用操作系统的函数来进行线程的阻塞操作
						
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
	
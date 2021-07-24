1、fail-fast机制：
	快速失败机制。是java集合（Collection）中一种错误检查机制。
	当在迭代集合的过程中该集合在结构上发生改变的时候，就有可能会发生fail-fast,即跑出：
		java.util.ConcurrentModificationException
	fail-fast机制并不保证在不同步的修改下一定会跑出异常，它只是尽最大的努力去抛出，所以这种机制一般仅用于检测bug。
	
	所以在集合中使用迭代器迭代数据时，无法操作集合的增删，否则会报错。
	但是可以调用迭代器自身的remove方法。
	
	java.util包下的集合类都是快速失败的，不能在多线程下发生并发修改（迭代过程中被修改）算是一种安全机制吧。 

	
2、以ArrayList为例，进行分析：
	
	a、调用 arrayList.iterator():
		public Iterator<E> iterator() {
			return new Itr();
		}

	b、分析new Itr()方法；
	/**
     * An optimized version of AbstractList.Itr
     */
    private class Itr implements Iterator<E> {
	
        int cursor;       // index of next element to return
        int lastRet = -1; // index of last element returned; -1 if no such
		
		--很重要的赋值，关系到检测所集合有所修改而报错的关键
		--modCount： 集合内元素个数
        int expectedModCount = modCount;

        public boolean hasNext() {
            return cursor != size;
        }

        @SuppressWarnings("unchecked")
        public E next() {
			--检查集合是否修改过：
            checkForComodification();
            int i = cursor;
            if (i >= size)
                throw new NoSuchElementException();
            Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length)
                throw new ConcurrentModificationException();
            cursor = i + 1;
            return (E) elementData[lastRet = i];
        }

		final void checkForComodification() {
			--判断集合的长度是否已变更
			--原 modCount = 10
			--在增加或者删除元素后， modCount都会变化，所以就会导致不一致，从而报错
			--但是可以发现，如果只是更新的话，这个就不会报错了！！！！
            if (modCount != expectedModCount)
                throw new ConcurrentModificationException();
        }
		
		--迭代器自身的删除方法
        public void remove() {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
				--调用remove方法
                ArrayList.this.remove(lastRet);
                cursor = lastRet;
                lastRet = -1;
				--会重新对expectedModCount赋值，保证两个值相等。
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }

        @Override
        @SuppressWarnings("unchecked")
        public void forEachRemaining(Consumer<? super E> consumer) {
            Objects.requireNonNull(consumer);
            final int size = ArrayList.this.size;
            int i = cursor;
            if (i >= size) {
                return;
            }
            final Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length) {
                throw new ConcurrentModificationException();
            }
            while (i != size && modCount == expectedModCount) {
                consumer.accept((E) elementData[i++]);
            }
            // update once at end of iteration to reduce heap write traffic
            cursor = i;
            lastRet = i - 1;
            checkForComodification();
        }
        
    }
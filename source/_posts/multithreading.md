---
title: Java多线程基础
date: 2021-04-20 19:22:20
updated:
tags: 
- Java
- 多线程
categories:
- Java
index_img: https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3231005548,635944634&fm=26&gp=0.jpg
banner_img: https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3231005548,635944634&fm=26&gp=0.jpg
---
# Java多线程
## 1.程序，进程，线程
> * 程序：（可以执行的静态代码，是保存在硬盘上的一个文件）是为完成特定任务，用某种语言编写的一组指令的集合。即***一段静态的代码***，静态对象.
> * 进程：（正在执行中的一个程序，在内存中处于激活状态，有生命周期）是程序的一次执行过程，或是***正在运行的一个程序***。动态过程：有它自身的产生、存在和消亡的过程
> * 线程：（进程中的子任务）进程可以进一步细化为线程，是一个程序内部的一条执行路径
>

## 2.Java中多线程的创建和使用
> * 实现Runnable接口与继承Thread类
> * ### Thread类的主要方法
>> * 每个线程都是通过某个特定Thread对象的run()方法来完成操作的，经常把run()方法的主题称为线程体
>> * 通过该Thread对象的start()方法来调用这个线程
>> * static Thread currentThread(),返回当前方法正在执行此方法所压入的栈的线程对象
>> * void join()它的作用是调用此方法的另一个线程阻塞，当前线程执行完再执行另一个线程
>> * static void sleep(long millis)作用是让当前线程（正在执行此方法的栈的线程）进入睡眠状态
>>> * 两种方式结束sleep状态：1.时间到了。2.被其他进程打断 interrupt() 方法
### 创建并启动线程的方式
#### 实现Runnable的方式
>> 1. 写一个具体类，实现Runnable接口，并实现接口中的抽象方法run(),这个run方法就是线程体
>> 2. 创建这个具体类对象，并把这个对象作为实参，创建Thread线程对象
>> 3. 调用Thread线程对象的start方法
>> * 代码示例
````Java
package multi_thread;

public class Counter implements Runnable {
	private int cnt = 200;

	@Override
	public void run() {
		System.out.println(cnt);
		for (int i = 0; i < 50; i++) {
			synchronized ("") {// ()中是一个锁对象，任意对象都可以做锁，称为互斥锁，作用是只允许一个线程进入执行，其他线程等待

				cnt -= 2;
				try {
					Thread.sleep(10);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				System.out.println(Thread.currentThread().getName() + ": " + cnt);
			}
		}
	}

}

````
***
````Java
package multi_thread;

public class CounterTest {

	public static void main(String[] args) {
		Runnable counter = new Counter();
		Thread thread1 = new Thread(counter);
		Thread thread2 = new Thread(counter);
		thread1.start();
		thread2.start();
	}

}

````
#### 继承Thread的方式
>> 1. 写一个类，继承Thread,并重写run方法，此方法就是线程体
>> 2. 创建这个类的对象，相当于创建了线程对象
>> 3. 调用这个线程对象的start方法
>> * 代码示例
````Java
package multi_thread;
class MyThread extends Thread{
	@Override
	public void run() {
		for(int i=0;i<100;i++) {
			System.out.println(currentThread().getName()+" "+i);
		}
	}
}
public class ThreadTest2 {

	public static void main(String[] args) {
		Thread myThread1 = new MyThread();
		myThread1.start();
		for(int i=0;i<100;i++) {
			System.out.println("-----main "+i);
		}
	}

}

````
#### 使用callable接口创建多线程
> * 落地方法call()
> * Callable接口作为JDK1.5新增的接口，与使用Runnable相比其功能更强大些。
> * 相比run()方法，可以有返回值
> * 方法可以抛出异常
> * 支持泛型的返回值
> * 需要借助FutureTask类，比如获取返回结果。
> * Callable接口一般用于配合ExecutorService使用
##### Feture接口
> * 可以对具体Runnable、Callable任务的执行结果进行取消、查询是否完成、获取结果等。
> * FutrueTask是Futrue接口的实现类
> * FutureTask 同时实现了Runnable, Future接口。它既可以作为Runnable被线程执行，又可以作为Future得到Callable的返回值。
> * 多个线程同时执行一个FutureTask，只要一个线程执行完毕，其他线程不会再执行其call()方法。
> * get()方法会阻塞当前线程！
实例代码:
````
class MyThread implements Callable<Integer> {
	@Override
	public Integer call() throws Exception {
		System.out.println(Thread.currentThread().getName()+" Come in call");
		//睡5秒
		TimeUnit.SECONDS.sleep(5);
		//返回200的状态码
		return 200;
		
	}
}

public class CallableTest {
	public static void main(String[] args) throws InterruptedException, ExecutionException {
		MyThread myThread = new MyThread();
		FutureTask<Integer> futureTask = new FutureTask<>(myThread);
		new Thread(futureTask, "未来任务").start();
        System.out.println("主线程结束！");
		Integer integer = futureTask.get();
		System.out.println(integer);
		
	}
}
````
#### 线程池创建多线程

> * 线程池：经常创建和销毁、使用量特别大的资源，比如并发情况下的线程，对性能影响很大。因此提前创建好多个线程，放入线程池中，使用时直接获取，使用完放回池中。可以避免频繁创建销毁、实现重复利用。
> * 优点
>> 1. 提高响应速度（减少了创建新线程的时间）
>> 2. 降低资源消耗（重复利用线程池中线程，不需要每次都创建）
>> 3. 便于线程管理	
> * ExecutorService：真正的线程池接口。常见子类ThreadPoolExecutor。
> * void execute(Runnable command) ：执行任务/命令，没有返回值，一般用来执行Runnable
> * <T> Future<T> submit(Callable<T> task)：执行任务，有返回值，一般用来执行Callable
> * void shutdown() ：关闭连接池
> * 创建线程池的方式：
>> 1. 直接通过ThreadPoolExecutor实现类new
>> 2. 通过工厂类Executors的静态方法创建，本质上也是通过1)创建的线程池
````
public static void main(String[] args) {
		//创建一个包含10个线程的线程池
		ExecutorService executorService = Executors.newFixedThreadPool(10);
//		ExecutorService executorService = Executors.newSingleThreadExecutor();
		for (int i = 0; i < 12; i++) {
			executorService.execute(()->{
				System.out.println(Thread.currentThread().getName());
			});
		}
		executorService.shutdown();
	}
````
## 3.线程的同步
> * synchronized (lock){}
> * ()中是一个锁对象，任意对象都可以做锁，称为互斥锁，作用是只允许一个线程进入执行，其他线程等待
> * 具有原子性，不可分割
> * synchronized()可重入锁（同一个线程可以无限次获取同一个锁）
> * 避免死锁：不要嵌套synchronized，即使有嵌套，锁对象尽量少
### synchronized和Lock的区别
> * synchronized不需要手动上锁和解锁，lock需要手动上锁和解锁
> * synchronized能实现的功能lock都可以实现，且lock更加强大

## JUC工具类
### ReentrantReadWriteLock
````
package com.atguigu.juc;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

class MyQueue {
	// 创建读写锁
	ReadWriteLock rwl = new ReentrantReadWriteLock();

	private Object obj;

	public void readObj() {
		// 上读锁
		rwl.readLock().lock();
		try {
			System.out.println(Thread.currentThread().getName() + "当前线程读到的内容是：" + obj);

		} finally {
			// 解读锁
			rwl.readLock().unlock();
		}
	}

	public void writeObj(Object obj) {
		// 上写锁
		rwl.writeLock().lock();
		try {
			this.obj = obj;
			System.out.println(Thread.currentThread().getName() + "当前线程写入的内容是：" + obj);
		} finally {
			// 解写锁
			rwl.writeLock().unlock();
		}
	}

}

/**
 * 
 * @Description: 一个线程写入,100个线程读取
 * 
 */
public class ReadWriteLockDemo {
	public static void main(String[] args) throws InterruptedException {
		// 创建资源对象
		MyQueue mq = new MyQueue();
		// 一个线程写入
		new Thread(() -> {
			mq.writeObj("写入的内容");
		}, "AA").start();
		// 100个线程读取
		ExecutorService executorService = Executors.newFixedThreadPool(100);
		for (int i = 0; i < 100; i++) {
			executorService.execute(() -> {
				mq.readObj();
			});
		}
		executorService.shutdown();
	}
}
````
### CountDownLatch
````
package com.atguigu.juc;

import java.util.concurrent.CountDownLatch;


/**
 * 
 * @Description:
 *  *让一些线程阻塞直到另一些线程完成一系列操作后才被唤醒。
 * 
 * 
 * 解释：6个同学陆续离开教室后值班同学才可以关门。
 * 
 * main主线程必须要等前面6个线程完成全部工作后，自己才能开干 
 */
public class CountDownLatchDemo
{
	public static void main(String[] args) throws InterruptedException
	{
		CountDownLatch cd = new CountDownLatch(6);
		//6个同学离开教室
		for (int i = 1; i <= 6; i++) {
			new Thread(()->{System.out.println(Thread.currentThread().getName()+"号同学离开教室");}, String.valueOf(i)).start();
		//减少计数
			cd.countDown();
		}
		//等待		
		cd.await();
		//班长锁门
		System.out.println(Thread.currentThread().getName()+"班长锁门");
	}


}
````
### CyclicBarrier
````
package com.atguigu.juc;

import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

/**
 * 
 * @Description: TODO(这里用一句话描述这个类的作用)  
 *
 * CyclicBarrier
 * 的字面意思是可循环（Cyclic）使用的屏障（Barrier）。它要做的事情是，
 * 让一组线程到达一个屏障（也可以叫同步点）时被阻塞，
 * 直到最后一个线程到达屏障时，屏障才会开门，所有
 * 被屏障拦截的线程才会继续干活。
 * 线程进入屏障通过CyclicBarrier的await()方法。
 * 
 * 集齐7颗龙珠就可以召唤神龙
 */
public class CyclicBarrierDemo
{
	private static final int NUMBER = 7;
	
	public static void main(String[] args)
	{
		//CyclicBarrier(int parties, Runnable barrierAction) 
		CyclicBarrier cb = new CyclicBarrier(NUMBER, ()-> {System.out.println("可以召唤神龙了");});
		for(int i=1;i<=NUMBER;i++) {
			new Thread(()->{System.out.println(Thread.currentThread().getName()+"号被收集");
			try {
				cb.await();
			} catch (Exception e) {
				e.printStackTrace();
			} 
			},String.valueOf(i) ).start();
		}
	}
}
````
### Semaphore
````
package com.atguigu.juc;

import java.util.Random;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

/**
 * 
 * @Description: TODO(这里用一句话描述这个类的作用)
 * 
 *               在信号量上我们定义两种操作： acquire（获取）
 *               当一个线程调用acquire操作时，它要么通过成功获取信号量（信号量减1）， 要么一直等下去，直到有线程释放信号量，或超时。
 *               release（释放）实际上会将信号量的值加1，然后唤醒等待的线程。
 * 
 *               信号量主要用于两个目的，一个是用于多个共享资源的互斥使用，另一个用于并发线程数的控制。
 * 
 *               情景：3个停车位，6部汽车争抢车位
 */
public class SemaphoreDemo {
	public static void main(String[] args) {
		// 3个停车位
		Semaphore semaphore = new Semaphore(3);
		// 6部汽车抢车位
		for (int i = 1; i <= 6; i++) {
			new Thread(() -> {
				// 获取资源
				try {
					semaphore.acquire();
					System.out.println(Thread.currentThread().getName() + "号驶入停车位");
					// 停车3秒
					TimeUnit.SECONDS.sleep(3);
					System.out.println(Thread.currentThread().getName() + "号驶出停车位");
					// 释放资源
					semaphore.release();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}, String.valueOf(i)).start();
		}
	}
}

````

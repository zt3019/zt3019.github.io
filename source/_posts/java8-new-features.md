---
title: java8新特性
date: 2021-04-23 11:09:21
tags:
- Java
categories: 
- Java
index_img: data:image/jpeg;base64,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
banner_img: data:image/jpeg;base64,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
---
# Java8新特性
## Lambda表达式与函数式接口
### 函数式接口
> 1. Consumer<T> 消费器, 作用是消费一个T类型的对象, 并没有返回.
> * void accept(T t) : 有输入无输出
***
> 2. Supplier<T> 供给器, 作用是供给一个T类型的对象, 不需要参数.
> * T get() : 无输入有输出
***
> 3. Function<T, R> 转换器, 作用是输入一个T类型对象, 经过处理, 返回的是R类型对象.
> * R apply(T t) : 有输入有输出
***
> 4. Predicate<T> 判定器, 作用是输入一个T类型对象, 经过某种判断, 返回true或false
> * boolean test(T t) : 有输入有固定输出布尔
````Java
package java8;

import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

import org.junit.Test;

import javabean.Student;


/**
 * 函数式接口
 * 		只有一个抽象方法的接口, 可以用@FunctionalInterface修饰
 * 
 * Consumer<T> 消费器, 作用是消费一个T类型的对象, 并没有返回.
 * 		void accept(T t) : 有输入无输出
 * 
 * Supplier<T> 供给器, 作用是供给一个T类型的对象, 不需要参数.
 * 		T get() : 无输入有输出
 * 
 * Function<T, R> 转换器, 作用是输入一个T类型对象, 经过处理, 返回的是R类型对象.
 * 		R apply(T t) : 有输入有输出
 * 
 * Predicate<T> 判定器, 作用是输入一个T类型对象, 经过某种判断, 返回true或false
 * 		boolean test(T t) : 有输入有固定输出布尔
 * 
 * 方法引用 : 接口中的抽象方法的模式(输入和输出) 和 Lambda体中的方法调用是一致时, 就可以简化写法.
 * 类或对象 :: 方法名
 * 
 */

public class FunctionTest {
	
	@Test
	public void exer22() {
		//Supplier<Student> supplier2 = () -> new Student();
		Supplier<Student> supplier2 = Student::new;
		System.out.println(supplier2.get());
	}
	
	@Test
	public void test42() {
		//Function<Integer, String> function2 = t -> String.valueOf(t);
		Function<Integer, String> function2 = String::valueOf;
		System.out.println(function2.apply(1112));
	}
	
	@Test
	public void test32() {
		//Supplier<Double> supplier2 = () -> Math.random();
		Supplier<Double> supplier2 = Math::random;
		System.out.println(supplier2.get());
	}
	
	@Test
	public void test12() {
		//Consumer<String> consumer2 = t -> System.out.println(t);
		Consumer<String> consumer2 = System.out::println;
		consumer2.accept("lkjxlkcjccc");
	}
	
	// 写一个判定器, 判断一个学生是否及格
	@Test
	public void exer4() {
		Predicate<Integer> predicate1 = new Predicate<Integer>() {
			@Override
			public boolean test(Integer t) {
				return t>= 60;
			}
		};
		boolean test = predicate1.test(100);
		System.out.println(test);
		
		Predicate<Integer> predicate2 = t -> t >= 60;
		System.out.println(predicate2.test(100));
	}
	
	@Test
	public void test5() {
		Predicate<Integer> predicate1 = new Predicate<Integer>() {
			@Override
			public boolean test(Integer t) {
				return t % 2 == 0;
			}
		};
		boolean test = predicate1.test(83);
		System.out.println(test);
		
		Predicate<Integer> predicate2 = t -> t % 2 == 0;
		System.out.println(predicate2.test(20));
	}
	
	// 写一个转换器, 把学生对象转换成字符串, 内容是姓名+分数
	@Test
	public void exer3() {
		Function<Student, String> function1 = new Function<Student, String>() {
			@Override
			public String apply(Student t) {
				return t.getName() + ":" + t.getScore();
			}
		};
		String apply = function1.apply(new Student(2, "小刚", 5, 80));
		System.out.println(apply);
		
		Function<Student, String> function2 = t -> t.getName() + ":" + t.getScore();
		System.out.println(function2.apply(new Student(1, "小花", 2, 100)));
	}
	
	@Test
	public void test4() {
		Function<Integer, String> function1 = new Function<Integer, String>() {
			@Override
			public String apply(Integer t) {
				return String.valueOf(t);
			}
		};
		
		String apply = function1.apply(9238);
		System.out.println(apply);
		
		Function<Integer, String> function2 = t -> String.valueOf(t);
		System.out.println(function2.apply(1112));
	}
	
	// 写一个供给器, 每调用一次供给一个学生对象
	@Test
	public void exer2() {
		Supplier<Student> supplier1 = new Supplier<Student>() {
			@Override
			public Student get() {
				return new Student();
			}
		};
		Student student = supplier1.get();
		System.out.println(student);
		
		Supplier<Student> supplier2 = () -> new Student();
		System.out.println(supplier2.get());
	}
	
	@Test
	public void test3() {
		Supplier<Double> supplier = new Supplier<Double>() {
			@Override
			public Double get() {
				return Math.random();
			}
		};
		System.out.println(supplier.get());
		
		Supplier<Double> supplier2 = () -> Math.random();
		System.out.println(supplier2.get());
	}
	
	@Test
	public void test2() {
		Supplier<Integer> supplier1 = new Supplier<Integer>() {
			@Override
			public Integer get() {
				return 100;
			}
		};
		Integer integer = supplier1.get();
		System.out.println(integer);
		
		Supplier<Integer> supplier2 = () -> 100;
		Integer integer2 = supplier2.get();
		System.out.println(integer2);
	}
	
	// 写一个消费器, 消费一个Student对象.
	@Test
	public void exer1() {
		Consumer<Student> consumer1 = new Consumer<Student>() {
			@Override
			public void accept(Student t) {
				System.out.println(t);
			}
		};
		consumer1.accept(new Student());
		
		Consumer<Student> consumer2 = t -> System.out.println(t);
		consumer2.accept(new Student(1, "小花", 2, 50));
	}
	
	@Test
	public void test1() {
		Consumer<String> consumer1 = new Consumer<String>() {
			@Override
			public void accept(String t) {
				System.out.println(t);
			}
		};
		consumer1.accept("alsdkjfalksdjf");
		
		Consumer<String> consumer2 = t -> System.out.println(t);
		consumer2.accept("lkjxlkcjccc");
	}
}
````
## Stream流
````Java
package java8;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.junit.Test;

import javabean.Student;
import javabean.StudentTest;
/**
 * Stream : 
 * 	1) 不保存数据, 只负责处理数据
 * 	2) 处理数据不会造成原始数据的变化 , 每次处理都会产生新的流
 * 	3) 所有操作都是延迟执行的, 只有终止操作执行时才执行中间操作
 * 	4) 每个流只能"消费"一次, 消费过后就作废.
 * 	5) 单向, 一次性使用, 可以支持高并发...
 * 
 * 典型的操作 :
 * 	1) 创建流(获取流) 
 * 		1) 从集合获取流, 集合.stream();
 * 		2) 从数组获取流, Arrays.stream(Xxx[] arr);
 * 		3) 基于散数据, Stream.of(T... objs)
 * 		4) 使用供给器, 无限流
 * 	2) 中间操作, 多个中间操作就形成流水线, 是延迟执行的, 中间操作可以省略
 * 		***filter(Predicate p) : 让流中的每个对象都经过判定器, 如果结果为true留下, 如果是false丢弃. 产生新流
 * 		distinct(); 把流中的数据去重并产生新流, 依据对象的hashCode和equals
 * 		limit(long maxSize) 限制流中的最大数据量
 * 		skip(long n) 跳过前n个元素
 * 		***map(Function f) 让流中的每个对象都转换为新对象, 所以它的结果的流全变了.
 * 		sorted() 把流中的对象排序 , 自然排序
 * 		*sorted(Comparator c) 定制排序
 * 
 * 	3) 终止操作, 一旦中止, 所有的中间操作就开始执行, 终止操作是必须的.
 * 		***forEach(Consumer c) : 让流中的每个对象都经过消费器消费一下.
 * 		findFirst() 返回流中的第一个对象
 * 		**count() 计数
 * 		**collect(采集器) 可以把结果集采集到一个新的容器中.
 * 		***reduce(BinaryOperator op) 把流中的对象两两处理最后产生一个结果
 *	
 *	Optional是一容器, 里面放一个引用, 如果引用为空, 获取时直接抛异常.
 *	防止空指针.
 */
public class StreamTest {
	@Test
	public void exer6() {
		List<Student> collect = StudentTest.getList()
					.stream()
					.distinct()
					.filter(t -> t.getGrade() == 3)
					.filter(t -> t.getScore() < 60).sorted((o1, o2) -> -(int)(o1.getScore() - o2.getScore()))
					.collect(Collectors.toList());
		for (Student student : collect) {
			System.out.println(student);
		}
	}
	
	// 找出全校最高分
	@Test
	public void exer5() {
		Optional<Double> reduce = StudentTest.getList().stream().distinct().map(t -> t.getScore()).reduce((d1, d2) -> d1 > d2 ? d1 : d2);
		Double orElse = reduce.orElse((double) 999);
		System.out.println(orElse);
	}
	
	@Test
	public void exer4() {
		long count = StudentTest.getList().stream().distinct().count();
		System.out.println(count);
	}
	
	@Test
	public void exer3() {
		Optional<Student> findFirst = StudentTest.getList()
												.stream()
												.distinct()
												.filter(t -> t.getGrade() == 4)
												.filter(t -> t.getScore() < 60).sorted((o1, o2) -> -(int)(o1.getScore() - o2.getScore()))
												.limit(2).findFirst();
		//Student student = findFirst.get();
		Student student = findFirst.orElse(new Student()); // 最大化减少空指针
		System.out.println(student);
	}
		
	// 3年级没有及格的同学倒序, 取出前2个.
	@Test
	public void exer2() {
		StudentTest.getList()
					.stream()
					.distinct()
					.filter(t -> t.getGrade() == 3)
					.filter(t -> t.getScore() < 60).sorted((o1, o2) -> -(int)(o1.getScore() - o2.getScore()))
					.limit(2).forEach(System.out::println);
	}
	
	@Test
	public void test9() {
		StudentTest.getList().stream().distinct().sorted((t1, t2) -> (int)(t1.getScore() - t2.getScore())).forEach(System.out::println);
	}
	
	@Test
	public void test8() {
		StudentTest.getList().stream().distinct().map(t -> t.getScore()).forEach(System.out::println);
	}
	
	@Test
	public void Test7() {
		// 第6个到第10个
		StudentTest.getList().stream().distinct().skip(10).limit(5).forEach(System.out::println);
	}
	
	// 找出5年级姓张的同学
	@Test
	public void exer1() {
		List<Student> list = StudentTest.getList();
		list.stream().filter(t -> t.getGrade() == 5).filter(t -> t.getName().startsWith("张")).forEach(System.out::println);
	}
	
	@Test
	public void test62() {
		List<Student> list = StudentTest.getList();
		list.stream().filter(t -> t.getGrade() == 3).filter(t -> t.getScore() >= 60).forEach(System.out::println);
	}
	
	@Test
	public void test6() {
		List<Student> list = StudentTest.getList();
		Stream<Student> stream = list.stream();
		Stream<Student> stream2 = stream.filter(t -> t.getGrade() == 3);
		Stream<Student> stream3 = stream2.filter(t -> t.getScore() >= 60);
		stream3.forEach(System.out::println);
	}
	
	@Test
	public void test5() {
		Stream.generate(Math::random).limit(10).forEach(System.out::println);// 无限流
	}
	
	@Test
	public void test4() {
		Stream<Integer> generate = Stream.generate(() -> 200); // 无限流
		generate.forEach(System.out::println);
	}
	
	@Test
	public void test3() {
		Stream<Number> of = Stream.of(3.22, 9.33, 4.88, 4.2, 8, 9);
		of.forEach(System.out::println);
	}
	
	@Test
	public void test2() {
		String[] arr = {"kjsf", "qqa", "cv", "XXX"};
		Stream<String> stream = Arrays.stream(arr);
		stream.forEach(System.out::println);
	}
	
	@Test
	public void test1() {
		List<Integer> list = new ArrayList<Integer>();
		for (int i = 0; i < 10; i++) {
			list.add((int)(Math.random() * 20));
		}
		System.out.println(list);
		
		Stream<Integer> stream = list.stream();
		stream.forEach(System.out::println);
		
	}
}

````

---
title: Java杂记
date:2021-4-31 11:28:48
updated:
tags:
- Java
- 异常
- Java关键字
- 排序算法
categories:
- Java
index_img: https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3225163326,3627210682&fm=26&gp=0.jpg
banner_img: https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3225163326,3627210682&fm=26&gp=0.jpg
---
# Java杂记

## 异常
 * ### 异常定义
 * 程序在运行时有可能出现的非正常状况，会导致程序崩溃 
 * ### 分类：
 * #### 按程度分：
 * Error：虚拟机都无法处理的错误状况
 * Exception：一般性的问题 	
 * #### 按照处理方式为分： 
 * 受检异常，在程序中必须对其进行处理的异常，如果不处理，编译出错
 * Exception及其子类，RuntimeException及其子类除外：问题程序不容忽视         
 * 非受检异常 在程序中不是必须对其进行处理的异常
 * Error及其子类：太严重了 
 * RuntimeException及其子类：太轻微了
 * ### 异常处理：
 * ### 1）捕获 try catch try{ 可能抛出异常的语句 }catch(可能的异常类型 引用){ 通过异常处理异常对象 }
 * ### 2）异常抛出 在方法中使用throw异常对象，方法一旦执行了throw和执行return效果是一样的，都会导致方法结束
 * return时正常结束返回，throw时异常结束返回 
 * 在签名中使用throws，可能的异常类型列表，警告调用者，调用此方法有风险，请考虑清楚
 * 方法中的throw作用是真的产生破环
 * ### 3）先捕获再抛出
 * 在方法中先尝试执行某代码，如果真的出现了异常，再把这个异常关联到自定义异常对象中，再抛出自定义异常对象       
 * 异常处理的选择：
 * 入口方法尽量捕获（这个方法出问题会不会影响栈）
 * 普通方法尽量抛出
 * 如果代码中有潜在风险，尽量先捕再抛
 * 如果代码中没有风险，但是有时不满足方法继续的条件时，直接抛出
 ## 关键字
 * volatile :提醒子线程，此主存中的属性不要制作副本...

 

 ## 排序算法
 ### 冒泡排序：
 ````java
public class MaopaoSort {
    public static void main(String[] args) {
        int[] data=new int[20];
        for (int i = 0; i <data.length ; i++) {
            data[i]=(int)(Math.random()*20);
        }
        for (int d : data) {
            System.out.print(d+" ");
        }
        System.out.println();
        System.out.println("===================================");
        maopaoSort(data);
        for (int i : data) {
            System.out.print(i+" ");
        }
    }
    public static void maopaoSort(int[] arr){
        for (int i = 0; i <arr.length ; i++) {
            for(int j=1;j<arr.length-i;j++){//每一次循环，最大的数以及到了数组末尾，所以每一轮都可以少遍历一个数据
                if(arr[j]<arr[j-1]){
                    int tmp=arr[j];
                    arr[j]=arr[j-1];
                    arr[j-1]=tmp;
                }
            }
        }
    }
}
 ````
### 选择排序
````java
		int[] arr1=new int[10];
		for(int i=0;i<arr1.length;i++) {
			arr1[i]=(int)(Math.random()*20);
		}
		for(int tmp:arr1) {
		System.out.print(tmp+" ");
		}
		System.out.println();
		//选择排序
		int minindex;
		for(int i=0;i<arr1.length-1;i++) {//从0开始到倒数第二个位置
			minindex=i;//最小下标先默认等于i
			for(int j=i+1;j<arr1.length;j++) {//遍历从i+1开始到数组长度的所有数
				if(arr1[j]<arr1[minindex]) {//找最小值
					minindex=j;//更新最小下标
				}
			}
			//交换元素，实现最小值赋值到基准位置i
			int tmp=arr1[i];
			arr1[i]=arr1[minindex];
			arr1[minindex]=tmp;
		}
		for(int tmp:arr1) {
		System.out.print(tmp+" ");
		}
		System.out.println();
````

### 快速排序
````java
public class QuickSort {
    public static void main(String[] args) {
        //int[] data = {3,18,13,3,3};
        int[] data=new int[20];
        for (int i = 0; i < data.length; i++) {
            data[i] = (int) (Math.random() * 20);
        }
        //排序前
        for (int i = 0; i < data.length; i++) {
            System.out.print(data[i] + " ");
        }
        //排序后
        System.out.println();
        System.out.println("====================================");
        quickSort(data, 0, data.length-1);
        for (int i : data) {
            System.out.print(i + " ");
        }
    }
    public static void quickSort(int[] arr, int begin, int end) {
        if (end - begin <= 0) {//当一直递归后只剩下一个元素了，说明不用排序了递归结束
            return;
        }
        //分区，分三个部分，中间是键值，左边比键值小，右边比键值大
        //定位索引最关键
        int key = arr[begin];//总是取第一个元素为键值
        int keyIndex = begin;//键值索引，用于动态保存比键值小的值的索引
        //来找比key小的元素，放到左边
        //默认取第一个元素作为键值，第一个元素不用遍历
        for (int i = begin + 1; i <= end; i++) {
            if (arr[i] < key) {
                keyIndex++;//只要找到比key小的元素，keyIndex就往右移一个，因为肯定就有一个元素在键值的左边
                //交换keyIndex和i的位置
                //当keyIndex和i之间有大于key时，交换位置
                if(i!=keyIndex) {
                    int tmp = arr[keyIndex];
                    arr[keyIndex] = arr[i];
                    arr[i] = tmp;
                }
            }
        }
        //此时keyIndex处的值与begin交换，因为从keyIndex开始到begin的值肯定是比键小的值
        arr[begin] = arr[keyIndex];
        arr[keyIndex] = key;
        //左递归
        quickSort(arr, begin, keyIndex - 1);
        //右递归
        quickSort(arr, keyIndex + 1, end);

    }
````
## 注解
````java
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import javax.lang.model.element.Element;

import jdk.jfr.Registered;

/**
 * 注解的处理只能通过反射，要想反射，必须使用元注解@Retention
 * @author Hasee
 *注解：是一种特殊的注释，不参与程序的执行，特殊之处在于编译器和JVM都可以识别它.
 *@Override 作用是告诉编译器，它修饰的方法要完成方法覆盖，请帮助做条件检查，只能修饰方法
 *@Deprecated 作用是警告使用者，它修饰的目标过期了，可以修饰类，属性，方法，构造器，形参，局部变量
 *@SuppressWarnings 作用是抑制编译器警告，并且可以传递参数，参数可以是一个值也可以是一个数组
 *注解：
 *1）没有属性的，称为标记型注解
 *2）有属性的，可以进一步传递数据
 */
//@Target({ElementType.TYPE})
//自定义注解,默认可以修饰类，属性，构造器，方法，形参，局部变量
@Retention(RetentionPolicy.RUNTIME)//只有注解的停留期定义在运行时才可以被反射
@interface MyAnnotation{
	public abstract int id()default 10;
	String name() default "我是缺省值";//可以有缺省值
	String value() default "qaq";//当属性名为value()时可以省略属性名
}
@MyAnnotation(id = 0, name = "sda")
class Person{
	private String name;
	private int age;
	private String gender;
	@SuppressWarnings("unused")
	private int n;
	public Person() {

	}
	@MyAnnotation
	public Person(String name, int age, String gender) {
		super();
		this.name = name;
		this.age = age;
		this.gender = gender;
	}
	@Override
	public String toString() {
		return "Person [name=" + name + ", age=" + age + ", gender=" + gender + "]";
	}
	public String getName() {
		return name;
	}
	@MyAnnotation("aqa")
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	
}
public class AnnotationTest {

}
````
## 路径问题：
> * 绝对路径：以根目录为开始的路径
> * 相对路径：以当前目录未开始的路径（./）
>
>
## 泛型
````java


import java.util.ArrayList;
import java.util.List;

import org.junit.Test;


/**
 * 泛型要解决类型安全问题
 */

class Person<X> { // X表示某种类型, X在这里称为泛型的类型参数(是一个形参)
	// X类型的真实类型会在创建对象时确定下来, 隶属于对象的存在而存在.
	
	private String name;
	private X info;
	
	public Person() {
	}

	public Person(String name, X info) {
		this.name = name;
		this.info = info;
	}
	
	public X getInfo() {
		return info;
	}

	public void setInfo(X info) {
		this.info = info;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "Person [name=" + name + ", info=" + info + "]";
	}
	
	//在静态方法中不可以使用泛型类中的泛型
	public static void test(X x) {
	}
}

// 泛型和继承之间的关系
class A<Y> {
	private Y y;
	public Y getY() {
		return y;
	}
}

class B1 extends A {} // 子类中没有处理父类的泛型. 泛型类型就是类型最模糊的Object, 这种不好

class B2 extends A<Integer> {} // 子类在继承时把父类的泛型写死了 ,  这是最简单
//class B3 extends A<Teacher> {} // 在创建子类对象后, 其泛型是固定的.

class B4<Y> extends A<Y> {} // 子类在继承时仍然继续泛型, 这是最灵活
class GenericMethod<T> {
	
	public void test(T t) {
	}
	
	//public Object get(Object obj) {
	// 泛型方法中必须传入泛型类型的参数, 如果不传泛型永远无法确定.
	// 这个泛型类型由实参的类型来决定, 所以它是和方法的某次调用相关
	public static <E> E get(E e) { // E表示只可以在此方法中使用的某种类型
		return null;
	}
	
}

public class GenericTest {
	
	@Test
	public void test5() {
		//Object object = GenericMethod.get();
		String string = GenericMethod.get("abc"); // 泛型方法必须通过实参来告诉方法, 泛型的具体类型是什么
		Integer integer = GenericMethod.get(200);
		Boolean boolean1 = GenericMethod.get(false);
		Object object = GenericMethod.get(null); // 如果实参是null, 将会导致泛型类型无法感知!!! 
	}
	
	@Test
	public void test4() {
		B1 b1 = new B1();
		Object y = b1.getY();
		
		Integer y2 = new B2().getY();
		Integer y3 = new B2().getY();
		
		//Teacher y4 = new B3().getY();
		
		B4 b4 = new B4();
		Object y5 = b4.getY();
		Double y6 = new B4<Double>().getY();
		String y7 = new B4<String>().getY();
	}
	
	@Test
	public void test3() {
		Person<Integer> person1 = new Person<Integer>("张三", 20); // 使用了泛型后, 类型就安全了.
		Integer info1 = person1.getInfo(); // 获取到的属性也安全了, 清晰了.
		
		Person<Boolean> person2 = new Person<Boolean>("李四", true);
		Boolean info2 = person2.getInfo();
		
		Person person3 = new Person("王五", 3.22);
		Object info3 = person3.getInfo();
	}
	
	@Test
	public void test2() {
		Person person1 = new Person("张三", 30);
		Object info1 = person1.getInfo();
		
		Person person2 = new Person("李四", "女");
		Object info2 = person2.getInfo();
	}
	
	@Test
	public void test1() {
		List list1 = new ArrayList();
		list1.add(1);
		list1.add("abc");
		
		Object object = list1.get(0);
		
		List<Integer> list2 = new ArrayList<Integer>();
		list2.add(3);
		//list2.add("abc");
		
		List<Object> list3 = new ArrayList<Object>();
	}
}


````

## 集合
````java
package collection;

import java.util.*;
import org.junit.Test;

/**
 * 	Collection 集合 : 保存一个一个的对象, 特点 : 无序可重复
 * 
 * 		Set 特点 : 无序不可重复
 * 			HashSet : 基于数组使用哈希算法实现的Set集合, 
 判定重复的标准是两个对象的equals为true, 并且两个对象的hashCode一样
 * 				优点 : 全是优点
 * 				缺点 : 对内存要求高
 * 
 * 			TreeSet : 基于二叉搜索树(红黑树)实现的Set集合, 
 判定重复的标准是两个对象的比较结果为0
 * 				优点 : 对内存要求低, 搜索速度快
 * 				缺点 : 插入和删除的速度慢，大量元素的比较和树的旋转
 * 
 * 		List : 特点 : 有序可重复
 * 			ArrayList : 基于数组实现的List集合, 线程不安全.
 * 				缺点 : 对内存要求高, 因为内存必须连续, 
 非末端数据的插入和删除都是最慢的, 因为有大量元素的移动.
 * 				优点 : 末端插入删除速度快
 * 				适用场景 : 存档数据, 主要用于查询检索
 * 
 * 			Vector : 和ArrayList一样, 是一个古老的实现. 但是线程安全
 * 
 * 			LinkedList : 基于链表实现的List集合
 * 				优点 : 对内存要求低. 插入,删除速度非常快
 * 				缺点 : 检索速度慢,
 * 				适用场景 : 频繁修改数据, 很少检索
 * 
 *	泛型 : 类型安全问题, 在集合中使用泛型的好处是约束中的元素的数据类型, 
 类型可以是确定的, 不再是类型最模糊的Object
 *
 *	遍历 : 增强for
 *			for (元素数据类型 临时变量 : 集合) {
 *			}
 *
 *		  迭代器 Iterator
 *
 	必须从集合对象获取迭代器
 	while (迭代器.hasNext()) {
 		元素 = 迭代器.next();
 		处理元素;
 	}
 	
 	Map集合 : 保存的是一对一对的对象. 是具有映射关系的键值对象, 
 	键值对象都可以是任意对象. 键到值是单向一对一映射.
 	Map可以简单地看作是一个词典, 键是词条, 值是解释.
 		Object put(Object key, Object value); //写入条目
 		Object remove(Object key); // 根据键删除 一个条目
 		Object get(Object key); // 根据键查找值, 查词典
 		Set keySet(); // 获取一个保存所有键对象的Set子集合
 		Set entrySet(); // 获取保存所有条件对象的Set集合
 		int size() ; 条目个数
 		
 		
 		HashMap 是典型实现, 使用哈希算法实现的Map集合
 		TreeMap 是基于二叉树实现的Map集合
 		Hashtable 是古老的实现, 和HashMap一样, 它是线程安全, 效率低.
 */

class Dog implements Comparable{
	private String name;
	private int age;
	private int weight;
	public Dog() {
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public int getWeight() {
		return weight;
	}
	public void setWeight(int weight) {
		this.weight = weight;
	}
	@Override
	public String toString() {
		return "Dog [name=" + name + ", age=" + age + ", weight=" + weight + "]";
	}
	public Dog(String name, int age, int weight) {
		super();
		this.name = name;
		this.age = age;
		this.weight = weight;
	}
	@Override
	public int compareTo(Object o) {
		if(o instanceof Dog) {
		return ((Dog)o).age-this.age;
		}
		throw new RuntimeException("对象不可比");
	}
	 
}
public class CollectionTest {
	@Test
	public void test2() {
		
	}
	@Test
	public void test1() {
		Set set=new TreeSet();
		Dog dog1=new Dog("小白", 5, 25);
		Dog dog2=new Dog("小黄", 6, 50);
		Dog dog3=new Dog("小黑", 4, 30);
		Dog dog4=new Dog("狗蛋", 2, 10);
		set.add(dog1);
		set.add(dog2);
		set.add(dog3);
		set.add(dog4);
		
		for (Object object : set) {
			System.out.println(object);
		}
	}
}

````
## 时间
````java
package date;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;

import org.junit.Test;

/**
 * LocalDate,LocalTime,LocalDateTime Java8中新提供的处理时间的类
 *
 */
public class DateTest {
	@Test
	public void test6() {
		LocalDateTime of = LocalDateTime.of(2000, 8, 10, 20, 10,1);
		System.out.println(of);
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy年MM月dd天");
		System.out.println(dtf.format(of));
	}
	@Test
	public void test5() {
		LocalTime time=LocalTime.now();
		System.out.println(time);
		LocalDateTime now = LocalDateTime.now();
		System.out.println(now);
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		System.out.println(dtf.format(now));
	}
	@Test
	public void test4() {
		String str1 = "abcwerthelloyuiodef ";
		String str2 = "cvhellobnm";
		int length = str2.length();
		l1: while (length > 0) {
			for (int begin = 0; begin + length <= str2.length(); begin++) {
				if (str1.contains(str2.substring(begin, begin + length))) {
					System.out.println(str2.substring(begin, begin + length));
					break l1;
				}
			}
			length--;
		}
	}

	@Test
	public void test3() {
		LocalDate date = LocalDate.now();
		System.out.println(date);
		LocalDate withYear = date.withYear(2000).withMonth(8).withDayOfMonth(10);
		System.out.println(withYear);
		LocalDate plusYears = withYear.plusDays(100);
		System.out.println(plusYears);
	}

	@Test
	public void test2() {
		Calendar instance = Calendar.getInstance();
		//
		instance.set(Calendar.YEAR, 2000);
		instance.set(Calendar.MONTH, 7);
		instance.set(Calendar.YEAR, 10);
		System.out.println(instance.getTime());
		instance.add(Calendar.DAY_OF_MONTH, 100);
		System.out.println(instance.getTime());
	}

	@Test
	public void test1() {
		System.out.println(System.currentTimeMillis());// 距离1970-01-01 00:00:00:000的毫秒数
		Date date = new Date();
		System.out.println(date);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String format = sdf.format(date);
		System.out.println(format);
		String string = "2001-12-06 20:45:19";
		try {
			System.out.println(sdf.parse(string));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
````
## 大数
````java
package math;

import java.math.BigInteger;

import org.junit.Test;
/**
 * java中所有字符都是两个字节
 * C语言中汉字占两个字节，其他字符1个字节
 *
 */
public class MathClassTest {
	@Test
	public void test1() {
		System.out.println(Math.random());
		System.out.println(Math.round(-4.5));
		BigInteger bi1=new BigInteger("41654894789415618977465187416518948651327849816354184894561564897488465415415");
		BigInteger bi2=new BigInteger("41654894789415641568977465187416518948651327849816354184894561564897488465415415");
		System.out.println(bi2.add(bi1));
	}
}

````

## StringBuilder
````java
package string;

import org.junit.Test;

/**
 * 
 * StringBuffer :内容可以改变的Unicode字符序列，任何修改都不会产生新对象，是内部的数据的变化，效率高
 * 是一个容器，是一个可以保存字符的容器，底层仍让使用数组
 *
 * StringBuilder append(...) 在字符串末尾追加任意数据. StringBuilder insert(int index, ...)
 * 在指定位置处插入任意新数据 StringBuilder delete(int begin, int end) 删除指定区间的所有字符
 * 
 * StringBuffer是线程安全的, 效率低 .
 * StringBuilder是线程不安全的, 效率高.(优先使用)
 */
public class StringBuilderTest {
	@Test
	public void test1() {
		String str=null;
		StringBuffer sb=new StringBuffer();
		sb.append(str);//如果append null会把null分解成单个字符，加入到StringBuffer中，count+=4
		System.out.println(sb.length());
		System.out.println(sb);
		StringBuffer sb1=new StringBuffer(str);//空指针错误,无法运行
		System.out.println(sb1);
	}
}

````
## String
````java
package string;

import org.junit.Test;

/**
 * 
 * 字符串：内容不可改变的Unicode字符的序列，任何对自负床的修改都一定会产生新的字符串对象
 * 底层使用byte[]来保存字符，字符串的处理与下标密切相关
 */
//System.arrycopy(value,0,result,0,value.length)实现从源数组到目标数组的复制

/**
 * 字符串 : 内容不可改变的Unicode字符的序列, 任何的对字符串的修改都一定会产生新的字符串对象.
 * 底层使用了char[]来保存字符, 字符串的处理和下标密切相关.
 * 					0 2         12       17        23        29      37 39
 * String string = "  abcABXXyy 我喜欢你,你喜欢我吗?我不喜欢你 qqyyZZ123  ";
 * 
 * 	*****public int length() 获取字符串长度(字符数) string.length() => 40
	*****public char charAt(int index) 获取参数指定的下标位置处的字符 string.charAt(10) => y. string.charAt(13) => 喜
	public char[] toCharArray() 获取字符串相应的字符数组, 是内部数组的一个副本
			System.arraycopy(value, 0, result, 0, value.length);
			// 第一个参数是源数组, 
			 * 第2个参数是源数组开始下标
			// 第3个参数是目标数组, 
			 * 第4个参数是目标数组的开始复制的下标, 
			 * 第5个参数是总共要复制的元素个数.
			 * 
			效果相当于 : 
			for (int i = 0; i < value.length; i++) {
				result[i] = value[i];
			}
			
	****public boolean equals(Object anObject)
	public int compareTo(String anotherString)
	
 * 					0 2         12       17        23        29      37 39
 * String string = "  abcABXXyy 我喜欢你,你喜欢我吗?我不喜欢你 qqyyZZ123  ";
 * 
	***public int indexOf(String s), 获取参数中的子串在当前字符串中首次出现的下标值 string.indexOf("喜欢") => 13, 如果搜索失败返回-1
	public int indexOf(String s ,int startpoint) 获取第2个喜欢 : string.indexOf("喜欢", 14) => 18, 
												  获取第3个喜欢 : string.indexOf("喜欢", 19) => 25,
												  
	public int lastIndexOf(String s) 从右向左搜索子串出现的下标, string.lastIndexOf("喜欢") => 25
	public int lastIndexOf(String s ,int startpoint) 获取第2个喜欢 : string.lastIndexOf("喜欢", 24) => 18
	
	// 通常获取文件列表名, 对文件名进行判断
	*public boolean startsWith(String prefix) 判断字符串是否以参数中的子串为开始 string.startsWith("  abc") => true
	*public boolean endsWith(String suffix) 判断字符串是否以参数中的子串为结束 string.endsWith("123") => false
	
	*****public String substring(int start,int end) 从当前字符串中截取子串, start表示开始下标(包含), end表示结束下标(不包含)
						string.substring(12, 16) => "我喜欢你",  结束下标-开始下标 == 子串长度
	public String substring(int startpoint) 从当前字符串中取子串,从start开始到结束
	
	public String replace(char oldChar,char newChar) 替换字符串中的所有旧字符为新字符
	public String replaceAll(String old,String new) 全部替换老串为新串, 特殊字符 \ [ * +
	
	public String trim() 修剪字符串的首尾的空白字符(Unicode码值小于等于32的字符，都是空白字符)
	
	public String concat(String str)
	public String toUpperCase() 改变大小写
	public String toLowerCase()
	public String[] split(String regex) 以参数中的子串为切割器, 把字符串切割成多个部分.
	*****public boolean equalsIgnoreCase(String s2) 比较字符串的内容, 忽略大小写
 *
 */
public class StringClassTest {
	
	@Test
	public void test4() {
		String s="  		\r\t\n  	\r\tw 		\t\r\t\n\r";
		int begin=0;
		for(int i=0;i<s.length();i++) {
			if(s.charAt(i)>32) {
				begin=i;
				break;
			}
		}
		System.out.println(begin);
		int end=begin;
		for(int i=s.length()-1;i>begin;i--) {
			if(s.charAt(i)>32) {
				end=i;
				break;
			}
		}
		System.out.println(end);
		System.out.println(s.substring(begin, end+1));
		
		
		
		String string="PATH=C:\\Python38\\Scripts\\;C:\\Python38\\;C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Windows\\System32\\OpenSSH\\;C:\\Program Files (x86)\\NVIDIA Corporation\\PhysX\\Common;C:\\Program Files\\NVIDIA Corporation\\NVIDIA NGX;C:\\Program Files (x86)\\Intel\\Intel(R) Management Engine Components\\DAL;C:\\Program Files\\Intel\\Intel(R) Management Engine Components\\DAL;C:\\WINDOWS\\system32;C:\\WINDOWS;C:\\WINDOWS\\System32\\Wbem;C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\;C:\\WINDOWS\\System32\\OpenSSH\\;D:\\Program Files\\Java\\jdk-13.0.2\\bin;C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\Anaconda3 (64-bit);D:\\python;D:\\python\\Scripts;D:\\python\\Library\\bin;D:\\Git\\cmd;C:\\ProgramData\\chocolatey\\bin;D:\\blog\\;C:\\Users\\Hasee\\AppData\\Local\\Microsoft\\WindowsApps;C:\\Users\\Hasee\\AppData\\Local\\Programs\\Microsoft VS Code\\bin;D:\\python\\PyCharm Community Edition 2019.3.3\\bin;D:\\Fiddler;C:\\Users\\Hasee\\AppData\\Roaming\\npm;D:\\PyCharm Community Edition 2020.2.3\\bin;C:\\adb;C:\\Program Files\\NVIDIA Corporation\\NVIDIA NvDLISR;C:\\WINDOWS\\system32;C:\\WINDOWS;C:\\WINDOWS\\System32\\Wbem;C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\;C:\\WINDOWS\\System32\\OpenSSH\\;D:\\tomcat\\apache-tomcat-10.0.2\\bin;D:\\Program Files\\Java\\jdk-13.0.2\\bin;C:\\Users\\Hasee\\AppData\\Local\\Microsoft\\WindowsApps;;C:\\Users\\Hasee\\AppData\\Local\\Programs\\Microsoft VS Code\\bin;D:\\python\\PyCharm Community Edition 2019.3.3\\bin;D:\\Fiddler;C:\\Users\\Hasee\\AppData\\Roaming\\npm;D:\\PyCharm Community Edition 2020.2.3\\bin;;C:\\Users\\Hasee\\AppData\\Local\\Microsoft\\WindowsApps";
		String[] splitString=string.split(";");
		for(int i=0;i<splitString.length;i++) {
			System.out.println(splitString[i]);
		}
	}
	@Test
	public void test3() {
		String s="abcdefghijklmn";
		int begin=2;
		int end=6;
		String s1=s.substring(0,begin);
		String s2=s.substring(begin, end);
		String s3=s.substring(end,s.length());
		System.out.println(s1);
		System.out.println(s2);
		System.out.println(s3);
		String news="";
		for(int i=0;i<s2.length();i++) {
			news=s2.charAt(i)+news;
		}
		System.out.println(news);
		news=s1+news+s3;
		System.out.println(news);
	}
	@Test
	public void test1() {
		char[] arr= {'a','7','o','p','0'};
		String s1=new String(arr);
		System.out.println(s1);
		String s2=new String(arr,2,3);//new String(char[],startindex,count)
		System.out.println(s2);
		System.out.println(s2.length());
		String s3="";
		for(int i=s1.length()-1;i>=0;i--) {
			s3+=s1.charAt(i);
		}
		System.out.println(s3);
	}
	@Test
	public void test2() {
		String s="abkkcadkabkebfkabkskab";
		String s1="ab";
		int cnt=0;
		for(int i=0;i<s.length();) {
			if(s.indexOf(s1,i)!=-1) {
				cnt++;
				i=s.indexOf(s1,i)+1;
			}
			else {
				i++;
			}
		}
		System.out.println(cnt);
	}
}

````
## 装箱
````java
package wrapper;

import org.junit.Test;

public class WrapperTest {
	@Test
	public void test() {
		int n=20;
		Integer obj1=new Integer(n);
		Integer obj2=n;//自动装箱
		System.out.println(obj1==obj2);
		System.out.println(obj1.equals(obj2));
	}
	@Test
	public void test1() {
		Integer i=new Integer(1);
		Integer j=new Integer(1);
		System.out.println(i==j);//false
		//自动装箱，调用Integer.valueOf(n)
		//在-128到127之间，自动装箱不会创建新的对象，会取缓冲对象数组中的一个，超过该范围，自动装箱会创建新对象
		Integer m=1;//自动装箱
		Integer n=1;
		System.out.println(m==n);// true
		
		
		Integer x=128;//自动装箱
		Integer y=128;
		System.out.println(x==y);//false
	}
}

````
## JavaIo
````java
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStreamWriter;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.junit.Test;
/*
 * 绝对路径：以根目录为开始的路径
 * 相对路径：以当前目录未开始的路径（./）
 */
class Student implements Serializable {
	
	public static String school; // 序列化不可以序列化静态属性
	
	// 只序列化对象在GC区中的数据
	private int id;
	private String name;
	private int grade;
	private transient double score;
	
	public Student() {
	}

	public Student(int id, String name, int grade, double score) {
		super();
		this.id = id;
		this.name = name;
		this.grade = grade;
		this.score = score;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	public double getScore() {
		return score;
	}

	public void setScore(double score) {
		this.score = score;
	}

	@Override
	public String toString() {
		return "Student [id=" + id + ", name=" + name + ", grade=" + grade + ", score=" + score + "]";
	}
	
}

public class JavaIoTest {
	// 从键盘输入一些内容, 把文件保存成UTF8格式的文本文件content.txt
	// 直到键盘输入over命令, 或ctrl+z 
	@Test
	public void test13() {
		InputStream is = System.in; // 以键盘为数据源
		InputStreamReader isr = null;
		BufferedReader bufferedReader = null;
		try {
			isr = new InputStreamReader(is);
			bufferedReader = new BufferedReader(isr);
			String line = bufferedReader.readLine();
			while (line != null) {
				// 1) 处理数据 
				if (line.equals("exit")) {
					break;
				}
				System.out.println(line);
				// 2) 继续读
				line = bufferedReader.readLine(); // ctrl+z 提醒流数据已经结束
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test12() {
		System.out.println("hello");
		System.err.println("Error");
	}
	
	@Test
	public void test11() {
		//FileWriter fileWriter = null;
		FileOutputStream fos = null;
		OutputStreamWriter osw = null;
		BufferedWriter bufferedWriter = null;
		try {
			//fileWriter = new FileWriter("一个文本文件");
			fos = new FileOutputStream("一个文本文件_UTF8", true); // 在创建节点流时, 传入第2个参数true,表示追加
			osw = new OutputStreamWriter(fos, "utf8"); // 在写文件时, 把字符串全部按照UTF8编码方式进行编码
			bufferedWriter = new BufferedWriter(osw);
			bufferedWriter.write("abc我和你");
			
			//bufferedWriter.flush(); // 把数据真的从缓冲区刷入硬盘
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bufferedWriter != null) {
				try {
					bufferedWriter.close(); // 在关闭前会自动flush
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test10() {
		//FileReader fileReader = null; // 它太弱了, 不好用
		FileInputStream fis = null;
		InputStreamReader isr = null;
		BufferedReader bufferedReader = null;
		try {
			//fileReader = new FileReader("HashMap.java"); // 只能处理和项目一致的编码的文本文件
			fis = new FileInputStream("HashMap.java");
			//isr = new InputStreamReader(fis); // 在这里仍然使用的是默认编码方式
			isr = new InputStreamReader(fis, "utf8"); // 指明转换流在处理字节数据时按照UTF8编码方式处理字符串
			bufferedReader = new BufferedReader(isr);
			
			String line = bufferedReader.readLine(); 
			while (line != null) {
				System.out.println(line);
				line = bufferedReader.readLine();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void unserialize() {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		ObjectInputStream ois = null;
		try {
			fis = new FileInputStream("对象序列化");
			bis = new BufferedInputStream(fis);
			ois = new ObjectInputStream(bis);
			
			/*
			Object obj1 = ois.readObject();
			Object obj2 = ois.readObject();
			Object obj3 = ois.readObject();
			
			System.out.println(obj1);
			System.out.println(obj2);
			System.out.println(obj3);
			
			System.out.println(Student.school);
			*/
			
			/*
			Student[] arr = (Student[])ois.readObject();
			for (int i = 0; i < arr.length; i++) {
				System.out.println(arr[i]);
			}
			*/
			
			List<Student> list = (List<Student>)ois.readObject();
			Iterator<Student> iterator = list.iterator();
			while (iterator.hasNext()) {
				System.out.println(iterator.next());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ois != null) {
				try {
					ois.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void serialize() {
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ObjectOutputStream oos = null;
		try {
			fos = new FileOutputStream("对象序列化");
			bos = new BufferedOutputStream(fos);
			oos = new ObjectOutputStream(bos);
			
			Student s1 = new Student(1, "小明", 3, 90);
			Student s2 = new Student(2, "小花", 1, 80);
			Student s3 = new Student(3, "小丽", 4, 20);
			
			s1.school = "atguigu";
			
			//oos.writeObject(s1);
			//oos.writeObject(s2);
			//oos.writeObject(s3);
			
			//Student[] arr = {s1, s2, s3};
			//oos.writeObject(arr);
			
			List<Student> list = new ArrayList<Student>();
			list.add(s1);
			list.add(s2);
			list.add(s3);
			oos.writeObject(list);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (oos != null) {
				try {
					oos.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test8() throws UnsupportedEncodingException {
		/*
		 * Unicoode编码每个字符占两个字节
		   GBK编码汉字占两个字节，其他字符一个字节
		   UTF-8编码汉字占三个字节，其他字符占一个字节
		 */
		// e6 88 91 可变长度编码
		int n1 = 0x6211; // Unicode码是国际标准委员会制定
		System.out.println(n1);
		System.out.println((char)n1);
		
		int n2 = 0xCED2; // GBK码值, 是中国人自己制定
		System.out.println(n2);
		
		// 编码 : 字符串 => 字节数组, string.getBytes(), 目标是把字符串保存到文件中或通过网络传输.
		String string = "abc我和你";
		byte[] bytes1 = string.getBytes("gbk"); // 按照项目默认的编码方式: GBK编码方式进行编码
		for (int i = 0; i < bytes1.length; i++) {
			System.out.print(Integer.toHexString(bytes1[i]) + " ");
		}
		System.out.println();
		
		byte[] bytes2 = string.getBytes("utf8");
		for (int i = 0; i < bytes2.length; i++) {
			System.out.print(Integer.toHexString(bytes2[i]) + " ");
		}
		System.out.println();
		
		// 解码 : 字节数组 => 字符串, new String(byte[]), 把文件中或从网络接收的数据还原成字符串
		String string2 = new String(bytes1, "gbk"); // 把字节数组按照gbk编码方式进行解码 
		// 每2个字节凑一个整数, 是GBK码, 再查表找到对应的Unicode码
		System.out.println(string2);
		
		String string3 = new String(bytes2, "utf8");
		// 每3个字节凑一个字符, 从3个字节中拆出数据, 拆出的数据直接就是Unicode
		System.out.println(string3);
	}
	
	@Test
	public void test9() {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		ObjectInputStream ois = null;
		try {
			fis = new FileInputStream("对象输出流文件2");
			bis = new BufferedInputStream(fis);
			ois = new ObjectInputStream(bis);
			
			int readInt = ois.readInt();
			System.out.println(readInt);
			boolean readBoolean1 = ois.readBoolean();
			boolean readBoolean2 = ois.readBoolean();
			System.out.println(readBoolean1);
			System.out.println(readBoolean2);
			long readLong = ois.readLong();
			System.out.println(readLong);
			double readDouble = ois.readDouble();
			System.out.println(readDouble);
			String readUTF = ois.readUTF(); // 读文件要解码
			System.out.println(readUTF);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ois != null) {
				try {
					ois.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test7() {
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ObjectOutputStream oos = null;
		try {
			fos = new FileOutputStream("对象输出流文件2");
			bos = new BufferedOutputStream(fos);
			oos = new ObjectOutputStream(bos);
			
			oos.writeInt(10); 
			oos.writeBoolean(false);
			oos.writeBoolean(true);
			oos.writeLong(20);
			oos.writeDouble(3.14);
			oos.writeUTF("abc我和你xxx"); // 写文件要编码
			//oos.writeChars("abc我和你xxx"); // 把字符串直接写文件
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (oos != null) {
				try {
					oos.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test6() {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		ObjectInputStream ois = null;
		try {
			fis = new FileInputStream("对象输出流文件");
			bis = new BufferedInputStream(fis);
			ois = new ObjectInputStream(bis);
			
			int readInt = ois.readInt();
			System.out.println(readInt);
			boolean readBoolean1 = ois.readBoolean();
			boolean readBoolean2 = ois.readBoolean();
			System.out.println(readBoolean1);
			System.out.println(readBoolean2);
			long readLong = ois.readLong();
			System.out.println(readLong);
			double readDouble = ois.readDouble();
			System.out.println(readDouble);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ois != null) {
				try {
					ois.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	// 使用对象流写文件, 写入50个100以内的随机整数
	@Test
	public void exer1() {
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ObjectOutputStream oos = null;
		try {
			fos = new FileOutputStream("50个随机数");
			bos = new BufferedOutputStream(fos);
			oos = new ObjectOutputStream(bos);
			
			for (int i = 0; i < 50; i++) {
				oos.writeInt((int)(Math.random() * 100));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (oos != null) {
				try {
					oos.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	// 使用对象输入流读取这50个随机整数
	@Test
	public void exer2() {
		FileInputStream fis = null;
		BufferedInputStream bis = null;
		ObjectInputStream ois = null;
		try {
			fis = new FileInputStream("50个随机数");
			bis = new BufferedInputStream(fis);
			ois = new ObjectInputStream(bis);
			
			for (int i = 0; i < 50; i++) {
				System.out.println(ois.readInt());
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (ois != null) {
				try {
					ois.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test5() {
		// ObjectInputStream和ObjectOutputStream
		FileOutputStream fos = null;
		BufferedOutputStream bos = null;
		ObjectOutputStream oos = null;
		try {
			fos = new FileOutputStream("对象输出流文件");
			bos = new BufferedOutputStream(fos);
			oos = new ObjectOutputStream(bos);
			
			oos.writeInt(10); // 数据在内存中如何 保存 它就如何写入文件
			oos.writeBoolean(false);
			oos.writeBoolean(true);
			oos.writeLong(20);
			oos.writeDouble(3.14);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (oos != null) {
				try {
					oos.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test4() {
		FileWriter fileWriter = null;
		BufferedWriter bufferedWriter = null;
		try {
			fileWriter = new FileWriter("使用缓冲流写文本");
			bufferedWriter = new BufferedWriter(fileWriter);
			String[] content = {"来上一些字符串内容1",
								"来上一些字符串内容2",
								"来上一些字符串内容3",
								"来上一些字符串内容4",
								"来上一些字符串内容5",
								"来上一些字符串内容6",
								"来上一些字符串内容7",
								"来上一些字符串内容8",
								"1234567890123456",
								"asdfkjasldfjalksdjflaksjdflkasjdflkasjdff",
								"xcvadsfasdfasdfasdfasdf"};
			for (String string : content) {
				bufferedWriter.write(string);
				bufferedWriter.newLine(); // 最有价值方法
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bufferedWriter != null) {
				try {
					bufferedWriter.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test3() {
		// 使用缓冲流(处理流)
		FileReader fileReader = null;
		BufferedReader bufferedReader = null;
		try {
			// 包装流, 使用对象关联, 包装流把节点流对象关联为属性.
			fileReader = new FileReader("HashMap.java");
			bufferedReader = new BufferedReader(fileReader);
			// 最有价值方法
			String line = bufferedReader.readLine(); // 读到的字符串没有换行
			int num = 1;
			while (line != null) {
				// 处理读到的行
				System.out.println(num++ + " " + line);
				// 继续读后面的行, 直到null
				line = bufferedReader.readLine();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 只需要关闭高级流, 因为低级流被关联, 并且会在关闭高级流时自动关闭
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	@Test
	public void test2() {
		FileWriter fileWriter = null;
		try {
			fileWriter = new FileWriter("写一个文件");
			// 写数组
			String[] content = {"来上一些字符串内容1",
								"来上一些字符串内容2",
								"来上一些字符串内容3",
								"来上一些字符串内容4",
								"来上一些字符串内容5",
								"来上一些字符串内容6",
								"来上一些字符串内容7",
								"来上一些字符串内容8",
								"1234567890123456",
								"asdfkjasldfjalksdjflaksjdflkasjdflkasjdff",
								"xcvadsfasdfasdfasdfasdf"};
			for (int i = 0; i < content.length; i++) {
				char[] charArray = content[i].toCharArray();
				//fileWriter.write(charArray);// 直接把一个数组的全部内容写入到输出流中
				//这是超重点方法, 把数组的一部分写入文件
				fileWriter.write(charArray, 1, charArray.length - 1); // 第2个参数是offset偏移, 第3个参数是length长度
				
				fileWriter.write(13); // 写回车
				fileWriter.write(10); // 写换行
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fileWriter != null) {
				try {
					fileWriter.close();
				} catch (Exception e2) {
				}
			}
		}
	}
	
	//使用缓冲区读文件, 要求在每一行前面加上行号
	@Test
	public void test1() {
		int line = 1;
		System.out.print(line++ + " ");
		FileReader fileReader = null;
		try {
			fileReader = new FileReader("HashMap.java");
			char[] buf = new char[8192];
			int realCount = fileReader.read(buf);
			while (realCount != -1) {
				// 1) 处理已经实际读到的数据
				for (int i = 0; i < realCount; i++) {
					System.out.print(buf[i]);
					if (buf[i] == 10) {
						System.out.print(line++ + " ");
					}
				}
				// 2) 继续读后面的数据, 直到-1为止
				realCount = fileReader.read(buf);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (fileReader != null) {
				try {
					fileReader.close();
				} catch (Exception e2) {
				}
			}
		}
	}
}

````
> * 文件复制
````java
package javaio;
import java.io.*;
public class FileCopy {

	public static void main(String[] args) {
		FileInputStream fis=null;
		FileOutputStream fos=null;
		try {
			fis=new FileInputStream("s");
			fos=new FileOutputStream("s2");
			byte[] buf=new byte[8192];
			int realCount=fis.read(buf);
			while(realCount!=-1) {
				//处理数据
				fos.write(buf, 0, realCount);
				//继续读
				realCount=fis.read(buf);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}finally {
			if(fis!=null) {
				try {
					fis.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if(fos!=null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
	}

}
````
## JDBC
### 连接数据库
````java
package jdbc;

import java.sql.SQLException;
import java.util.Properties;

import org.junit.Test;

import com.mysql.jdbc.Statement;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;

/**
 * 1) 在project项目下创建目录
 * 2) 把相关的.jar文件复制到这个目录中
 * 3) 再把jar文件导入到build-path中
 * 
 * url : uniform resource locator 
 * 统一资源定位器 jdbc:mysql://127.0.0.1:3306/test
 * jdbc是主协议
 * mysql是子协议 
 * 127.0.0.1是Mysql服务器主机地址
 * 3306是mysql服务器的端口
 * test是数据库名
 */
public class JdbcTest {
	
	@Test
	public void test6() {
		Connection connection=null;
		Statement statement=null;
		try {
		 connection = JdbcUtil.getConnection();
		 statement=(Statement) connection.createStatement();//通过连接获取执行体对象
		 System.out.println(statement);
		 String sql="create table if not exists customer(id int auto_increment,"
				 										+"name varchar(10),"
				 										+"gender char(1) default '男',"
				 										+"age int,"
				 										+"phone char(11),"
				 										+ "primary key(id),"
				 										+ "unique(phone))";
		 int rows=statement.executeUpdate(sql);//可以执行update,delete,insert,DDL，除了select的DML操作等sql操作
		 System.out.println(rows);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			JdbcUtil.close(connection,statement);
		}
	}

	@Test
	public void test5() throws SQLException, ClassNotFoundException, IOException {
		InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream("jdbc.properties");
		Properties properties = new Properties();
		properties.load(inputStream);
		inputStream.close();
		String driverClassName = properties.getProperty("driverClassName");
		String url = properties.getProperty("url");
		String user = properties.getProperty("user");
		String password = properties.getProperty("password");
		System.out.println(driverClassName);
		Class.forName(driverClassName); // 在类的静态语句块中完成自我注册
		Connection connection = DriverManager.getConnection(url, user, password);
		System.out.println(connection);
		connection.close();
	}

	@Test
	public void test4() throws SQLException, ClassNotFoundException {
		Class.forName("com.mysql.jdbc.Driver"); // 在类的静态语句块中完成自我注册
		String url = "jdbc:mysql://127.0.0.1:3306/jdbc";
		String user = "root";
		String password = "123456";
		Connection connection = DriverManager.getConnection(url, user, password);
		System.out.println(connection);
		connection.close();
	}

	@Test
	public void test3() throws SQLException, ClassNotFoundException, InstantiationException, IllegalAccessException {
		Class clazz = Class.forName("com.mysql.jdbc.Driver"); // 在类的静态语句块中完成自我注册
		// Driver driver = new com.mysql.jdbc.Driver();
		Driver driver = (Driver) clazz.newInstance();
		DriverManager.registerDriver(driver);
		// 通过驱动程序管理器来间接获取连接
		String url = "jdbc:mysql://127.0.0.1:3306/jdbc";
		String user = "root";
		String password = "123456";
		Connection connection = DriverManager.getConnection(url, user, password);
		System.out.println(connection);
		connection.close();
	}

	@Test
	public void test2() throws SQLException {
		Driver driver = new com.mysql.jdbc.Driver();
		DriverManager.registerDriver(driver);
		// 通过驱动程序管理器来间接获取连接
		String url = "jdbc:mysql://127.0.0.1:3306/jdbc";
		String user = "root";
		String password = "123456";
		Connection connection = DriverManager.getConnection(url, user, password);
		System.out.println(connection);
		connection.close();
	}

	@Test
	public void test1() throws SQLException {
		Driver driver = new com.mysql.jdbc.Driver(); // 创建子类对象, 当成接口类型的对象来使用
		String url = "jdbc:mysql://127.0.0.1:3306/jdbc"; // 统一资源定位器
		Properties info = new Properties();
		info.setProperty("user", "root"); // 用户名
		info.setProperty("password", "123456"); // 密码
		Connection connection = driver.connect(url, info); // 直接通过驱动程序来连接
		System.out.println(connection);
	}
}
````
### 数据修改
````java
package jdbc;

import java.io.IOException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommonUtil {
	/**
	 * 通过查询操作
	 * @param <T> 表示要处理的表中的数据对应的对象类型
	 * @param connection 连接对象
	 * @param clazz 类模板对象
	 * @param sql 查询
	 * @param args 代替sql中的?的实参列表
	 * @return 一个保存了所有对象的集合
	 * @throws Exception
	 */
	public static <T> List<T> getList(Connection connection, Class<T> clazz, String sql, Object... args) throws Exception {
		List<T> list = new ArrayList<>();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null; 
		try {
			preparedStatement = connection.prepareStatement(sql);
			for (int i = 0; i < args.length; i++) { // 替换SQL中的?
				preparedStatement.setObject(i + 1, args[i]);
			}
			resultSet = preparedStatement.executeQuery(); 
			ResultSetMetaData metaData = resultSet.getMetaData(); // 获取元数据
			int cols = metaData.getColumnCount(); // 获取列数
			while (resultSet.next()) { 
				T instance = clazz.newInstance(); // 反射的方式, 通过类模板创建实体对象
				for (int i = 0; i < cols; i++) {
					String label = metaData.getColumnLabel(i + 1); // label是列标签 , 同时又是属性名
					Object value = resultSet.getObject(label); // 从结果集中获取列标签对应的值, 也同时就是目标对象的属性值.
					Field field = clazz.getDeclaredField(label); // 反射的方式, 根据属性名获取属性定义对象
					field.setAccessible(true); // 暴力反射
					field.set(instance, value); // 通过反射的方式为目标对象的属性赋值.
				}
				list.add(instance);
			}
		} finally {
			JdbcUtil.close(null, preparedStatement, resultSet);
		}
		return list;
	}
	
	public static <T> List<T> getList(Class<T> clazz, String sql, Object... args) throws Exception {
		Connection connection = null;
		try {
			connection = JdbcUtil.getConnection();
			return getList(connection,  clazz, sql, args);
		} finally {
			JdbcUtil.close(connection);
		}
	}
	
	/**
	 * 通用更新操作
	 * @param sql 需要执行的SQL语句, 可以执行除了select外的DML和所有DDL
	 * @param args 用于代替SQL中的?的实参列表
	 * @return 影响行数
	 */
	public static int update(Connection connection, String sql, Object... args) throws ClassNotFoundException, IOException, SQLException {
		PreparedStatement preparedStatement = null;
		try {
			preparedStatement = connection.prepareStatement(sql); // 根据传入 的SQL预编译
			// 循环处理?
			for (int i = 0; i < args.length; i++) {
				preparedStatement.setObject(i + 1, args[i]);
			}
			int rows = preparedStatement.executeUpdate(); // 真正的执行
			return rows;
		} finally {
			JdbcUtil.close(null, preparedStatement); // 无论有没有发生异常,都要释放资源
		}
	} 
	
	/**
	 * 通用更新操作
	 * @param sql 需要执行的SQL语句, 可以执行除了select外的DML和所有DDL
	 * @param args 用于代替SQL中的?的实参列表
	 * @return 影响行数
	 */
	public static int update(String sql, Object... args) throws ClassNotFoundException, IOException, SQLException {
		Connection connection = null;
		try {
			connection = JdbcUtil.getConnection(); // 获取连接
			return update(connection, sql, args);
		} finally {
			JdbcUtil.close(connection); // 无论有没有发生异常,都要释放资源
		}
	}
}
````
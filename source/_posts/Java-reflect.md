---
title: Java反射
date: 2021-04-22 13:16:59
tags:
- java
- 反射
categories:
- Java
index_img: https://images.pexels.com/photos/1045113/pexels-photo-1045113.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940
banner_img: https://images.pexels.com/photos/1045113/pexels-photo-1045113.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940
---
# 反射
## 单元测试类
> * 单元测试方法的要求：类必须是公共的，必需不能有任何构造器
> * 方法必修是公共非静态无返回值参数
> * 执行：在方法名中右击，点击run as -junit
> * 包装类：把基本数据类型包装成对象

## 反射概述

* JAVA反射机制是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法；对于任意一个对象，都能够调用它的任意一个方法和属性；这种动态获取的信息以及动态调用对象的方法的功能称为java语言的反射机制。

  要想解剖一个类,必须先要获取到该类的字节码文件对象。而解剖使用的就是Class类中的方法.所以先要获取到每一个字节码文件对应的Class类型的对象.

* 反射就是把Java类中的各种成分映射成一个个的Java对象

  例如：一个类有：成员变量、方法、构造方法、包等等信息，利用反射技术可以对一个类进行解剖，把个个组成部分映射成一个个对象。

     （其实：一个类中这些成员方法、构造方法、在加入类中都有一个类来描述）

* 参考链接：CSDN博客 [链接](https://blog.csdn.net/qq_36226453/article/details/82790375)

## 反射基础实例代码

````Java
package reflect;

import static org.junit.Assert.*;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;

import org.junit.Test;

/**
 * 反射 : java的动态处理技术
 */
@Target({ElementType.TYPE, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@interface HelloAnnotation {
	String name() default "缺省名字";
	int id() default 10;
}

@HelloAnnotation(name="abc")
class Teacher extends ArrayList implements Serializable, Comparable, Runnable {
	
	@HelloAnnotation
	private String name;
	private int age;
	private String gender;
	
	//@HelloAnnotation
	public Teacher() {
	}
	//构造方法，Ctrl+Alt+S+O
	public Teacher(String name) {
		this.name = name;
	}
	
	public Teacher(int age) {
		this.age = age;
	}

	public Teacher(String name,String gender) {
		this.name = name;
		this.gender = gender;
	}

	public Teacher(String name, int age, String gender) {
		this.name = name;
		this.age = age;
		this.gender = gender;
	}
    //set,get方法 快捷键Ctrl+Alt+S+R
	//@HelloAnnotation
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

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}
    //Ctrl+Alt+S+S
	@Override
	public String toString() {
		return "Teacher [name=" + name + ", age=" + age + ", gender=" + gender + "]";
	}

	@Override
	public void run() {
	}

	@Override
	public int compareTo(Object o) {
		return 0;
	}
	
	private static void lesson(String content, int time) {
		System.out.println("老师在上[" + content + "]课, 共上了[" + time +"]小时");
		//return true;
		//throw new RuntimeException("一个异常");
	}
	
}

public class ReflectTest {
	
	@Test
	public void testName() throws Exception {
		Class clazz = Class.forName("reflect.Teacher");
		Annotation[] annotations = clazz.getAnnotations();
		System.out.println(annotations.length);
		System.out.println(annotations[0]);
	}
	
	@Test
	public void test14() throws Exception {
		Class clazz = Class.forName("reflect.Teacher");
		System.out.println("父类 : " + clazz.getSuperclass());
		Constructor[] constructors = clazz.getConstructors();
		for (int i = 0; i < constructors.length; i++) {
			System.out.println("构造器 : " + constructors[i]);
		}
		System.out.println("************************************************");
		Field[] fields = clazz.getFields(); // 所有公共属性
		for (int i = 0; i < fields.length; i++) {
			System.out.println("公共属性："+fields[i]);
		}
		//反射尽量不要破坏封装性，容易发生严重后果，慎用getDeclared.....()方法
		Field[] declaredFields = clazz.getDeclaredFields(); // 所有本类属性
		for (Field field : declaredFields) {
			System.out.println("本类属性："+field);
		}
		System.out.println("************************************************");
		Method[] methods = clazz.getMethods();//所有公共方法
		for (Method method : methods) {
			System.out.println("公共方法"+method);
		}
		System.out.println("************************************************");
		Method[] declaredMethods = clazz.getDeclaredMethods();//所有本类方法
		for (Method method : declaredMethods) {
			System.out.println("本类方法："+method);
		}
	}
	@Test
	public void test13() {
		try {
			Class clazz = Class.forName("reflect.Teacher");
			Method lessonMethod = clazz.getDeclaredMethod("lesson", String.class, int.class);
			lessonMethod.setAccessible(true);
			
			Short n = 3;
			Object retValue = lessonMethod.invoke(null, "JavaWEB", n); // 静态方法传null, 不需要传入对象
			System.out.println(retValue);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void test12() {
		try {
			Class clazz = Class.forName("reflect.Teacher");
			Constructor constructor = clazz.getConstructor(String.class, int.class, String.class);
			Object object = constructor.newInstance("佟刚", 40, "男");
			
			// getMethod只能获取公共的方法, 包括从父类继承的. 
			//Method lessonMethod = clazz.getMethod("lesson", String.class, int.class); 
			
			// getDeclaredMethod可以获取本类中所有声明的方法
			Method lessonMethod = clazz.getDeclaredMethod("lesson", String.class, int.class);
			lessonMethod.setAccessible(true);
			
			Short n = 3;
			Object retValue = lessonMethod.invoke(object, "JavaWEB", n); 
			System.out.println(retValue);
			/*
		    private String outOfBoundsMsg(int index) {
		        return "Index: "+index+", Size: "+size;
		    }
		    */
			/*
			//拿父类的方法，会有警告，最好不要暴力访问私有方法，属性
			Method declaredMethod = clazz.getSuperclass().getDeclaredMethod("outOfBoundsMsg", int.class);
			System.out.println(declaredMethod);
			//危险操作
			declaredMethod.setAccessible(true);
			
			Object invoke = declaredMethod.invoke(object, 20);
			System.out.println(invoke);
			*/
		} catch (ClassNotFoundException e) { // 类未找到
			e.printStackTrace();
		} catch (NoSuchMethodException e) { // 方法没有找到, 方法名错误或参数列表错误
			e.printStackTrace();
		} catch (SecurityException e) { // 安全异常
			e.printStackTrace();
		} catch (InstantiationException e) { // 创建对象时出现异常
			e.printStackTrace();
		} catch (IllegalAccessException e) { // 非法访问异常
			e.printStackTrace();
		} catch (IllegalArgumentException e) { // 非法实参异常, 实参和形参不匹配, 类型和顺序和数量
			e.printStackTrace();
		} catch (InvocationTargetException e) { // 调用的目标方法内部出现异常了.
			e.printStackTrace();
		}
	}
	
	@Test
	public void test11() {
		try {
			Class clazz = Class.forName("reflect.Teacher");
			Constructor constructor = clazz.getConstructor(String.class, int.class, String.class);
			Object object = constructor.newInstance("佟刚", 40, "男");
			
			//object.lesson("JavaWEB", 3);
			//先获取方法
			
			Method lessonMethod = clazz.getMethod("lesson", String.class, int.class); // 后面是方法参数类型列表
			short n = 3;
			Object retValue = lessonMethod.invoke(object, "JavaWEB", n); // 后面是实参列表, 如果方法没有返回值, 它的返回值是null
			System.out.println(retValue);
		} catch (ClassNotFoundException e) { // 类未找到
			e.printStackTrace();
		} catch (NoSuchMethodException e) { // 方法没有找到, 方法名错误或参数列表错误
			e.printStackTrace();
		} catch (SecurityException e) { // 安全异常
			e.printStackTrace();
		} catch (InstantiationException e) { // 创建对象时出现异常
			e.printStackTrace();
		} catch (IllegalAccessException e) { // 非法访问异常
			e.printStackTrace();
		} catch (IllegalArgumentException e) { // 非法实参异常, 实参和形参不匹配, 类型和顺序和数量
			e.printStackTrace();
		} catch (InvocationTargetException e) { // 调用的目标方法内部出现异常了.
			e.printStackTrace();
		}
	}
	
	@Test
	public void test10() {
		try {
			Class clazz = Class.forName("reflect.Teacher");
			//Object object = clazz.newInstance(); 没有无参构造器时出问题
			
			//public Teacher(String name, int age, String gender) 要想定位这个构造器, 必须让参数列表一致.
			
			// 提供形式参数类型列表, 是类模板对象的列表
			Constructor constructor = clazz.getConstructor(String.class, int.class, String.class); // 定位合适的构造器
			// 调用时必须给定实参列表
			Object object = constructor.newInstance("程程", 20, "女"); // new Teacher("程程", 20, "女");
			System.out.println(object);
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchMethodException e) { // 参数列表出错, 或者方法名出错
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) { // 方法调用时实参和形参不匹配
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
	}
	
	@Test
	public void test9() throws IOException  {
		//FileInputStream fis = new FileInputStream("只能读当前目录下的文件");
		ClassLoader classLoader = this.getClass().getClassLoader();
		// 只能加载build-path和src下的文件
		//InputStream inputStream = classLoader.getResourceAsStream("com/sun/corba/se/impl/logging/LogStrings.properties"); // 读取资源文件, 只要是Build-Path(classpath)中的文件都可以
		InputStream inputStream = classLoader.getResourceAsStream("s2");
		Properties properties = new Properties();
		properties.load(inputStream);
		
		Set<Entry<Object, Object>> entrySet = properties.entrySet();
		for (Entry<Object, Object> entry : entrySet) {
			System.out.println(entry);
		}
	}
	
	@Test
	public void test8()  {
		ClassLoader classLoader1 = ClassLoader.getSystemClassLoader(); // 获取系统类加载器
		System.out.println(classLoader1);
		ClassLoader classLoader2 = this.getClass().getClassLoader(); // 使用最多的, 获取当前类的类加载器
		System.out.println(classLoader2);
		
		ClassLoader classLoader3 = classLoader1.getParent(); // 获取父 "类加载器",  是 扩展 "类加载器"
		System.out.println(classLoader3);
		
		ClassLoader classLoader4 = classLoader3.getParent(); // 获取到的是引导类加载器(Bootstrap )
		System.out.println(classLoader4); // 这个类加载器无法获取, 无法使用
		
		/*
		双亲委派机制
		用户类加载器加载类时, 必须把此加载请求转发给父类加载器, 父类加载器再继续向父类加载器委派, 直到Bootstrap类加载器
		从Bootstrap类加载器开始真正加载, 各司其职. 
		*/
	}
	
	@Test
	public void test7()  {
		Class strClazz = String.class;
		System.out.println(strClazz);
		
		// 基本数据类型的类模板只能用第一种方式获取.
		Class clazz1 = int.class; // 基本数据类型也有相应的类模板对象, 但是不能获取属性和方法, 只能作为一个标记来使用.
		Class clazz2 = Integer.class; // 这是一个普通类模板.
		System.out.println(clazz1 == clazz2);
		
		// 判断类模板类型
		System.out.println("是否是基本型 : " + clazz1.isPrimitive());
		System.out.println("是否是基本型 : " + clazz2.isPrimitive());
	}
	
	@Test
	public void test6() throws ClassNotFoundException {
		// 获取类模板对象的方法 ，有４种
		// 1) 直接通过类.class, 效率最高, 最安全.
		Class clazz1 = Teacher.class;
		
		// 2) 根据对象, 调用它的getClass()方法获取, 此方法也很常用.
		Teacher teacher = new Teacher("佟刚", 40, "男");
		Class clazz2 = teacher.getClass();
		
		System.out.println(clazz1 == clazz2);
		
		// 3) 反射中最常用的 Class.forName("全限定类名");
		Class clazz3 = Class.forName("reflect.Teacher");
		System.out.println(clazz2 == clazz3);
		
		// 4) 通过类加载器对象动态加载类
		ClassLoader classLoader = this.getClass().getClassLoader();
		Class clazz4 = classLoader.loadClass("reflect.Teacher");
		System.out.println(clazz3 == clazz4);
	}
	
	@Test
	public void test5() throws ClassNotFoundException {
		Class clazz = Class.forName("reflect.Teacher");
		String name = clazz.getName();
		System.out.println("类名 : " + name);
		System.out.println("简单类名 :  " + clazz.getSimpleName());
		Class superclass = clazz.getSuperclass();
		System.out.println("父类 : " + superclass);
		Class[] interfaces = clazz.getInterfaces();
		System.out.println("接口列表 ");
		for (Class class1 : interfaces) {
			System.out.println(class1);
		}
		
	}
	
	@Test
	public void test4() {
		try {
			Class clazz = Class.forName("reflect.Teacher");
			Object object = clazz.newInstance();
			System.out.println(object);
			
			//Field ageField = clazz.getField("age"); // getField方法只能获取公共的属性, 也包括从父类继承的属性, 不可以获取私有属性
			Field ageField = clazz.getDeclaredField("age"); // 获取本类中声明的任意属性 
			// 暴力反射!!! 不推荐使用!!
			ageField.setAccessible(true); // 设置此属性为可访问的.
			ageField.set(object, 40); 
			System.out.println(ageField.get(object)); 
			
			Field nameField = clazz.getDeclaredField("name");
			nameField.setAccessible(true);
			nameField.set(object, "佟刚");
			
			System.out.println(object);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchFieldException e) { // 查找属性时, 有可能属性名不对, 可能是属性不存在
			e.printStackTrace();
		} catch (SecurityException e) { // 如果有安全检查.
			e.printStackTrace();
		}
	}
	
	@Test
	public void test3() {
		try {
			Class clazz = Class.forName("reflect.Teacher");
			Object object = clazz.newInstance();
			System.out.println(object);
			
			// 要想使用属性, 1)先获取属性定义对象 2) 配合目标this对象完成对象属性的间接访问.
			Field ageField = clazz.getField("age"); // 根据属性名获取属性的定义对象
			ageField.set(object, 40); // 设置属性值, 相当于 object.age = 40; 
			System.out.println(ageField.get(object)); // 获取属性值,  相当于 System.out.println(object.age)
			
			Field nameField = clazz.getField("name");
			nameField.set(object, "佟刚"); // object.name = "佟刚"
			
			Field genderField = clazz.getField("gender");
			genderField.set(object, "男");
			
			System.out.println(object);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (NoSuchFieldException e) { // 查找属性时, 有可能属性名不对, 可能是属性不存在
			e.printStackTrace();
		} catch (SecurityException e) { // 如果有安全检查.
			e.printStackTrace();
		}
	}
	
	@Test
	public void test2() { // 软编码, 灵活, 把问题延迟到运行时.
		try {
			// 干预类的加载, 直接获取类模板对象.
			Class clazz = Class.forName("reflect.Teacher"); // 类名必须全限定!!!
			// 通过类模板对象.newInstance创建实体对象
			Object object = clazz.newInstance(); // 调用无参构造器创建对象
			System.out.println(object);
		} catch (ClassNotFoundException e) { // 在运行时动态加载类时, 发现没有找到类
			e.printStackTrace();
		} catch (InstantiationException e) { // 在创建对象时出现异常, 可能是构造器不存在
			e.printStackTrace();
		} catch (IllegalAccessException e) { // 非法访问, 访问权限不够时出现
			e.printStackTrace();
		}
	}
	
	@Test
	public void test1() { // 编译时必须依赖类, 硬编码
		
		//Teacher t1 = new Teacher(); // 强烈依赖类
		//t1.name = "佟刚";
		//t1.age = 40;
		//t1.gender = "男";
		
		//System.out.println(t1.name);
		//System.out.println(t1.age);
		//System.out.println(t1.gender);
		
		//System.out.println(t1);
		
		Teacher t2 = new Teacher("程程", 20, "女");
		System.out.println(t2);
	}
	
	@Test
	public void test0() {
		// 测试方法所在的线程永远是守护线程
	}
	
	public static void main(String[] args) {
		// 守护线程, setDaemon(true); 此方法必须在start()以前调用.
		// 主线程永远是用户线程
	}
}

````


---
title: Scala
date: 2021-08-10 10:08:07
tags:
- Scala
categories:
- Scala
index_img: https://tse4-mm.cn.bing.net/th/id/OIP-C.6Tef98Y-yqyArVEYYu-lygHaDS?pid=ImgDet&rs=1
banner_img: https://tse4-mm.cn.bing.net/th/id/OIP-C.6Tef98Y-yqyArVEYYu-lygHaDS?pid=ImgDet&rs=1
---

# Scala

## Scala简介

* Scala是一门多范式的编程语言，Scala支持面向对象和函数式编程。（多范式，就是多种编程方法的意思。有面向过程，面向对象，泛型，函数式四种程序设计方式。）

### class和object说明

* object：从语法的角度上讲，上面的语法表示声明了一个伴生对象，但是还会生成一个伴生类。Scala是纯面向对象的，去除了java中的static关键字，通过伴生对象模拟static效果
* 伴生对象：伴随类产生的一个对象
* 对scala源文件进行编译后，默认会生成两个字节码文件，一个是伴生类另一个是伴生对象所属类（类名+一个$符号）
* 真正的伴生对象是伴生对象所属类中创建的单例对象
* 如果不想生成伴生类，可以手动生成，要求伴生类名称和伴生对象名称一致。
* 运行原理：
  - java运行原理：先编译，再解释。.java源文件--->编译器(javac)--->.class字节码文件--->JVM(java 不同平台)--->机器指令
  - scala运行原理：先编译，再解释。.scala源文件--->编译器(scalac)--->.class字节码文件--->JVM(scala 不同平台)--->机器指令

## 变量和数据类型

* 注释和java规则一样。

* 变量 var 变量名[:变量类型]=初始值

* 常量 val 变量名[:变量类型]=初始值

* 声明变量时必须要有初始指

* 标识符业余java基本一致。特殊情况：（1）以字母或者下划线开头，后接字母、数字、下划线

  （2）以操作符开头，且只包含操作符（+ - * / # !等）

  （3）用反引号`....`包括的任意字符串，即使是Scala关键字（39个）也可以

* 键盘输入输出：

* 输出：（1）字符串，通过+号连接

  （2）printf用法：字符串，通过%传值。

  （3）字符串模板（插值字符串）：通过"$"获取变量值。

  ${}

* 输入：StdIn.readLine()、StdIn.readShort()、StdIn.readDouble()

### 数据类型

* Any：所有类的父类
* AnyVal:(值类型)
  - Byte,Short,Int,Long,Float,Double,Boolean,Char
  - Unit:表示返回值类型为空，相当于Java中的 void  关键字
  - StringOps:对自负床功能的 增强
* AnyRef（引用类型 ）
  - 所有java语言中的类
  - Scala  语言中的类
  - 集合
  - Null：表示变量声明后，没有指向任何对象，相当于java中的null关键字
* Nothing :所有类的子类

### 类型转换

* char在java中是没有符号位的。char占两个字节。

### 函数式编程

* 面向对象编程：
  - Scala是一个完全面向对象的编程语言，万物皆对象。
  - 对象的本质：对数据和行为的一个封装。
* 函数式编程：
  - 将问题分解成一个一个的步骤，将每一个步骤进行封装，通调用这些封装好的步骤。
  - Scala是一个完全函数式编程语言，万物皆函数。

* 函数的本质：函数可以当做一个值进行传递。

#### 函数基础

* 函数与方法的区别

  * 为完成某一功能的程序语句的集合，称为函数。
  * 类中的函数称为方法
  * 函数没有重载和重写的概念；方法可以进行重载和重写
  * Scala中函数可以嵌套定义

  ````scala
  object TestFunction {
  def main(args: Array[String]): Unit = {
          // （1）函数定义
          def f(arg: String): Unit = {
              println(arg)
          }
          // （2）函数调用
          // 函数名（参数）
          f("hello world")
      }
  }
  ````

* 函数至简原则

  - （1）return可以省略，Scala会使用函数体的最后一行代码作为返回值

    （2）如果函数体只有一行代码，可以省略花括号

    （3）返回值类型如果能够推断出来，那么可以省略（:和返回值类型一起省略）

    （4）如果有return，则不能省略返回值类型，必须指定

    （5）如果函数明确声明unit，那么即使函数体中使用return关键字也不起作用

    （6）Scala如果期望是无返回值类型，可以省略等号

    （7）如果函数无参，但是声明了参数列表，那么调用时，小括号，可加可不加

    （8）如果函数没有参数列表，那么小括号可以省略，调用时小括号必须省略

    （9）如果不关心名称，只关心逻辑处理，那么函数名（def）可以省略
  
  ````scala
  package com.zt.spark.day01
  
  object FunctionTest {
    def main(args: Array[String]): Unit = {
      //(0)函数标准写法
      def f(s:String): String={
        return s+"hello world"
      }
      println(f("hi,"))
      //至简原则
      //(1)return可以省略，Scala会使用函数体的最后一行代码作为返回值
      def f1(s:String):String={
        s+"hello"
      }
      println(f1("world "))
      //(2)如果函数只有一行代码，可以省略花括号
      def f2(s:String):String=s+" hello"
      println(f2("world"))
      //(3)返回值类型如果能推断出来，那么可以省略（：和返回值类型一起省略）
      def f3(s:String)=s+" wocao"
      println(f3("aaaa"))
      //(4)如果return,则不能省略返回值类型，必须指定。
      def f4():String=return "hello"
      println(f4)
      //(5)如果函数明确声明unit，那么即使函数体中使用return关键字也不起作用
      def f5():Unit=return "xxxx"
      println(f5)
      //(6)Scala如果期望是无返回值类型，可以省略等号
      //将无返回值的函数称为"过程"
      def f6() {
        "dadadada"
      }
      println(f6())
      //(7)如果函数无参，但是声明了参数列表，那么调用时，小括号可加可不加
      def f7()="xxx"
      println(f7())
      println(f7)
      //(8)如果函数没有参数列表，那么小括号可以省略，调用时小括号必须省略
      def f8 ="xxx"
      println(f8)
      //(9)如果不关心名称，只关心逻辑处理，那么函数名(def)可以省略
      def f9=(x:String)=>{println("wode")}
      def f10(f:String=>Unit): Unit ={
        f("")
      }
      f10(f9)
      println(f10((x:String)=>{println("dadada")}))
    }
  
  }
  
  ````
  
  

#### 高阶函数

* 函数可以作为值进行传递
  - var f = 函数名 _
  - 如果明确了变量的数据类型，那么下划线可以省略
  
* 函数可以作为参数进行传递
  - 通过匿名函数
  - 扩展函数的功能
  - 提高函数的灵活度
  
* 函数可以作为返回值进行传递
  - 函数的嵌套
  - 函数链式调用，通过参数传递数据，在执行过程中，函数始终占据栈内存，容易导致内存溢出
  - 闭包：内层函数访问外层函数的局部变量，会自动延长外层函数局部变量的生命周期，与内层函数形成一个闭合的效果，我们称之为闭包
  - 柯里化：将一个参数列表中的多个参数，拆分为多个参数列表
  
* 匿名函数：

  - (x:Int)=>{函数体}
  - x：表示输入参数类型；Int：表示输入参数类型；函数体：表示具体代码逻辑

  - 参数的类型可以省略，会根据形参进行自动的推导
  - 类型省略之后，发现只有一个参数，则圆括号可以省略；其他情况：没有参数和参数超过1的永远不能省略圆括号。
  - 匿名函数如果只有一行，则大括号也可以省略
  - 如果参数只出现一次，则参数省略且后面参数可以用_代替

  ````scala
      def main(args: Array[String]): Unit = {
  
          // （1）定义一个函数：参数包含数据和逻辑函数
          def operation(arr: Array[Int], op: Int => Int) = {
              for (elem <- arr) yield op(elem)
          }
  
          // （2）定义逻辑函数
          def op(ele: Int): Int = {
              ele + 1
          }
  
          // （3）标准函数调用
          val arr = operation(Array(1, 2, 3, 4), op)
          println(arr.mkString(","))
  
          // （4）采用匿名函数
          val arr1 = operation(Array(1, 2, 3, 4), (ele: Int) => {
              ele + 1
          })
          println(arr1.mkString(","))
  
          // （4.1）参数的类型可以省略，会根据形参进行自动的推导;
          val arr2 = operation(Array(1, 2, 3, 4), (ele) => {
              ele + 1
          })
          println(arr2.mkString(","))
  
          // （4.2）类型省略之后，发现只有一个参数，则圆括号可以省略；其他情况：没有参数和参数超过1的永远不能省略圆括号。
          val arr3 = operation(Array(1, 2, 3, 4), ele => {
              ele + 1
          })
          println(arr3.mkString(","))
  
          // (4.3) 匿名函数如果只有一行，则大括号也可以省略
          val arr4 = operation(Array(1, 2, 3, 4), ele => ele + 1)
          println(arr4.mkString(","))
  
          //（4.4）如果参数只出现一次，则参数省略且后面参数可以用_代替
          val arr5 = operation(Array(1, 2, 3, 4), _ + 1)
          println(arr5.mkString(","))
      }
  }
  ````

  

## 面向对象

### 对象和类

* 在自然界中，只要是客观存在的都是对象（万物皆对象）

* 对大量对象共性的抽象，抽取为类

  - 有什么         属性
  - 能做什么     方法

* 在面向对象语言中，类是创建对象的模板

* 类是客观事务在人脑中的主观反映

* Scala的属性：

  - 在Scala语言中，类，方法，属性，默认修饰符都是public，但是没有public关键字
  - 对于Scala中的属性，底层会用private修饰，同时提供公开的设置以及获取属性的方法----面向封装
  - 如果要生成满足JavaBean规范的get和set方法的话，需要在属性上加@BeanProperty注解

* 访问权限

  - Java

    ````
    private		私有的，只能在本类中被访问
    default		默认的，可以在本类以及同包的其它类中被访问
    protected	受保护的，可以在本类、同包的其它类以及非同包的子类中被访问
    public 		公开的，所有类
    ````

  - Scala

    ````
    private		      私有的，只能在本类中被访问
    public(默认)	     公开的，所有类
    protected		  比Java设置的更严格，只能在本类以及子类中被访问，同包其他类访问不了
    private[包名] 	 可以让指定的包进行访问
    ````

    

### 创建对象的方式

* 构造器

  - 主构造方法

    - 在声明类的同时，主构造方法也被声明
    - 主构造方法只能有一个
    - 如果主构造方法没有参数，那么声明以及调用的时候，小括号可以省略。

  - 辅助构造方法

    - 方法名必修叫this
    - 辅助构造方法可以重载
    - 辅助构造方法中的第一行代码必须直接或者间接调用主构造方法

    ````scala
    //（1）如果主构造器无参数，小括号可省略
    //class Person (){
    class Person {
    
        var name: String = _
    
        var age: Int = _
    
        def this(age: Int) {
            this()
            this.age = age
            println("辅助构造器")
        }
    
        def this(age: Int, name: String) {
            this(age)
            this.name = name
        }
    
        println("主构造器")
    }
    
    object Person {
    
        def main(args: Array[String]): Unit = {
    
            val person2 = new Person(18)
        }
    }
    ````

* 继承

  - class 子类名 extends 父类名  { 类体 }
  - Scala是单继承

* 创建对象的方式

  - new   底层调用的是构造方法

  - 类名()  底层调用的是伴生对象中apply方法

  - 实现单例设计模式

    ````scala
    object Test {
    
        def main(args: Array[String]): Unit = {
    
            //（1）通过伴生对象的apply方法，实现不使用new关键字创建对象。
            val p1 = Person()
            println("p1.name=" + p1.name)
    
            val p2 = Person("bobo")
            println("p2.name=" + p2.name)
        }
    }
    
    //（2）如果想让主构造器变成私有的，可以在()之前加上private
    class Person private(cName: String) {
        var name: String = cName
    }
    
    object Person {
    
        def apply(): Person = {
            println("apply空参被调用")
            new Person("xx")
        }
    
        def apply(name: String): Person = {
            println("apply有参被调用")
            new Person(name)
    }
    //注意：也可以创建其它类型对象，并不一定是伴生类对象
    }
    ````

    

### 特质和抽象类

* 使用abstract关键字定义抽象类
  - 定义抽象类：abstract class Person{} //通过abstract关键字标记抽象类
* 抽象类一般和抽象属性以及抽象方法配合使用
* 抽象属性
  - 属性只有声明，但是没有赋值
  - 定义抽象属性：val|var name:String //一个属性没有初始化，就是抽象属性
* 抽象方法
  - 方法只有声明，没有实现
  - 定义抽象方法：def hello():String //只声明而没有实现的方法，就是抽象方法

* 抽象类总结
  - 在一个类中，如果存在抽象属性或者抽象方法，那么这个类一定是抽象类
  - 如果一个类是抽象类，那么它不一定包含抽象属性和抽象方法
  - 如果一个类中存在抽象属性或者抽象方法，那么具体的实现应该交给子类完成
  - 如果子类也实现不了抽象内容，那么子类也应该声明为抽象类
  - 如果重写(实现)抽象属性或者方法，那么override关键字可以省略
  - 如果重写(覆盖)非抽象属性或者方法，那么override关键字不能省略，必须得加
  - 如果对非抽象属性进行覆盖，要求属性必须得用val修饰
  - 可以通过super关键字调用父类的方法，但是不能super调用父类的属性
* 在Scala中，属性和方法都是动态绑定
  - 静态绑定（编译器绑定）
    - 在编译阶段，确定属性或者方法所属类型，多态的时候根据这个来看。（编译看左，运行看右）
  - 动态绑定
    - 在运行阶段，根据实际创建的对象类型来决定属性或者方法所属类型

#### 特质（Trait）

* Scala中采用特质trait来代替接口的概念。

* Scala中的trait中即**可以有抽象属性和方法，也可以有具体的属性和方法**，**一个类可以混入（mixin）多个特质**。这种感觉类似于Java中的抽象类。

  ````scala
  trait PersonTrait {
  
      // 声明属性
      var name:String = _
  
      // 声明方法
      def eat():Unit={
  
      }
  
      // 抽象属性
      var age:Int
      
      // 抽象方法
      def say():Unit
  }
  //通过查看字节码，可以看到特质=抽象类+接口
  ````

* 基本语法

  - **没有父类**：class  类名 ***extends*** 特质1  ***with***  特质2  ***with***  特质3 …
  - **有父类**：class  类名  ***extends*** 父类  ***with*** 特质1  ***with***  特质2  ***with*** 特质3…

* 特质（trait）叠加：

  - 由于一个类可以混入（mixin）多个trait，且trait中可以有具体的属性和方法，若混入的特质中具有相同的方法（方法名，参数列表，返回值均相同），必然会出现继承冲突问题。冲突分为以下两种：

    - 第一种，一个类（Sub）混入的两个trait（TraitA，TraitB）中具有相同的具体方法，且两个trait之间没有任何关系，解决这类冲突问题，直接在类（Sub）中重写冲突方法。
    - 第二种，一个类（Sub）混入的两个trait（TraitA，TraitB）中具有相同的具体方法，且两个trait继承自相同的trait（TraitC），及所谓的“钻石问题”，解决这类冲突问题，Scala采用了***特质叠加***的策略。

  - 特质叠加顺序

    - 第一步：列出第一个混入特质的继承关系，作为临时叠加的顺序
    - 第二步：列出第二个混入特质的继承关系,并且该顺序放到临时叠加顺序的前面，已经出现的特质不在出现   
    - 第三步：将子类放到临时叠加顺序的第一个

    ````scala
    trait Ball {
       def describe(): String = {
          "ball"
       }
    }
    
    trait Color extends Ball {
       override def describe(): String = {
          "blue-" + super.describe()
       }
    }
    
    trait Category extends Ball {
       override def describe(): String = {
          "foot-" + super.describe()
       }
    }
    
    class MyBall extends Category with Color {
       override def describe(): String = {
          "my ball is a " + super.describe()
       }
    }
    
    object TestTrait {
       def main(args: Array[String]): Unit = {
          println(new MyBall().describe())
       }
    }
    //注意：这个时候super不是调用父类中的方法了，而是调用特质叠加顺序上下一个节点的方法
    //运行结果：my ball is a blue-foot-ball
    ````

* 特质和抽象类的区别

  - 优先使用特质。一个类扩展多个特质是很方便的，但却只能扩展一个抽象类。
  - 如果你需要构造函数参数，使用抽象类。因为抽象类可以定义带参数的构造函数，而特质不行（有无参构造）。

* 类型检查和转换
  - obj.isInstanceOf[T]：判断obj是不是T类型。
  - obj.asInstanceOf[T]：将obj强转成T类型。
  - classOf获取对象的类名。



## 集合

### 集合基本概述

* 存放单值类型

  - Seq   有序，可重复
  - Set    无序，不能重复

* 存放键值对

  - Map   以k-v键值对的形式存放数据，其中key无序不能重复

* 对于几乎所有的集合类，Scala都同时提供了可变和不可变的版本，分别位于以下两个包

  - 不可变集合：scala.collection.immutable
    - 对集合进行添加或者删除操作的时候，会创建新的集合对象
  - 可变集合：scala.collection.mutable
    - 对集合进行添加或者删除操作的时候，直接在原来的集合上操作，不会创建新的集合对象

* 数组

  - Array

    ````scala
    object TestArray{
    
        def main(args: Array[String]): Unit = {
    
            //（1）数组定义
            val arr01 = new Array[Int](4)
            println(arr01.length) // 4
            
            var arr02 = Array(1, 3, "bobo")
            println(arr02.length)
            for (i <- arr02) {
                println(i)
            }
            //（2）数组赋值
    
    
            //（2.1）修改某个元素的值
            arr01(3) = 10
            //（2.2）采用方法的形式给数组赋值
            arr01.update(0,1)
    
            //（3）遍历数组
            //（3.1）查看数组
            println(arr01.mkString(","))
    
            //（3.2）普通遍历
            for (i <- arr01) {
                println(i)
            }
    
            //（3.3）简化遍历
            def printx(elem:Int): Unit = {
                println(elem)
            }
             arr01.foreach(printx)
            // arr01.foreach((x)=>{println(x)})
            // arr01.foreach(println(_))
            arr01.foreach(println)
    
            //（4）增加元素（由于创建的是不可变数组，增加元素，其实是产生新的数组）
            println(arr01)
            val ints: Array[Int] = arr01 :+ 5
            println(ints)
        }
    }
    ````

    

  - ArrayBuffer

  - 多维数组

    ````scala
    object DimArray {
    
        def main(args: Array[String]): Unit = {
            
            //（1）创建了一个二维数组, 有三个元素，每个元素是，含有4个元素一维数组()
            val arr = Array.ofDim[Int](3, 4)
            arr(1)(2) = 88
    
            //（2）遍历二维数组
            for (i <- arr) { //i 就是一维数组
    
                for (j <- i) {
                    print(j + " ")
                }
    
                println()
            }
        }
    }
    ````

    

* Seq

  - List

    ````scala
    object TestList {
    
        def main(args: Array[String]): Unit = {
    
            //（1）List默认为不可变集合
            //（2）创建一个List（数据有顺序，可重复）
            val list: List[Int] = List(1,2,3,4,3)
            
            //（7）空集合Nil
            val list5 = 1::2::3::4::Nil
    
            //（4）List增加数据
            //（4.1）::的运算规则从右向左
            //val list1 = 5::list
            val list1 = 7::6::5::list
            //（4.2）添加到第一个元素位置
            val list2 = list.+:(5)
    
            //（5）集合间合并：将一个整体拆成一个一个的个体，称为扁平化
            val list3 = List(8,9)
            //val list4 = list3::list1
            val list4 = list3:::list1
    
            //（6）取指定数据
            println(list(0))
    
            //（3）遍历List
            //list.foreach(println)
            //list1.foreach(println)
            //list3.foreach(println)
            //list4.foreach(println)
            list5.foreach(println)
        }
    ````

    

  - ListBuffer

* Set

* Map

  - 当调用map.get方法的时候，返回的Option类型数据,Option有两个子类型，一个Some，另一个None,可以帮我们避免对空值进行处理的情况，使用getOrElse函数，给空值赋默认值

    ````scala
    object TestMap {
    
        def main(args: Array[String]): Unit = {
            // Map
            //（1）创建不可变集合Map
            val map = Map( "a"->1, "b"->2, "c"->3 )
    
            //（3）访问数据
            for (elem <- map.keys) {
                // 使用get访问map集合的数据，会返回特殊类型Option(选项):有值（Some），无值(None)
                println(elem + "=" + map.get(elem).get)
            }
    
            //（4）如果key不存在，返回0
            println(map.get("d").getOrElse(0))
            println(map.getOrElse("d", 0))
    
            //（2）循环打印
            map.foreach((kv)=>{println(kv)})
        }
    }
    ````

    

### 集合函数

* 基本属性和常用操作

  （1）获取集合长度          length

  （2）获取集合大小          size

  （3）循环遍历                  foreach

  （4）迭代器                      iterator

  （5）生成字符串              mkString

  （6）是否包含                  contains

* 衍生集合

  ```
  	（1）获取集合的头
  		head
  	（2）获取集合的尾（不是头的就是尾）
  		tail
  	（3）集合最后一个数据
  		last
  	（4）集合初始数据（不包含最后一个）
  		init
  	（5）反转
  		reverse
  	（6）取前（后）n个元素
  		take|takeRight
  	（7）去掉前（后）n个元素
  		drop|dropRight
  	（8）并集
  		union
  	（9）交集
  		intersect
  	（10）差集
  		diff
  	（11）拉链
  		zip
  	（12）滑窗
  		sliding
  ```

* 集合计算初级，高级函数

  ````
  		（1）求和
  			sum
  		（2）求乘积
  			product
  		（3）最大值
  			max
  		（4）最小值
  			min
  		（5）排序
  			sorded|sortBy|sortWith
  			
  集合计算高级函数：
  		（1）过滤 filter(函数：指定过滤条件) 
  			 遍历一个集合并从中获取满足指定条件的元素组成一个新的集合
  
  		（2）转换/映射  map
  				 	
  		（3）扁平化 flatten   :::
  			将集合中元素由整体转换为个体的过程
  
  		（4）扁平映射  flatMap  
  			先映射再进行扁平化处理
  
  		（5）分组	gruopBy
  			按照一定的分组规则，将集合中的元素放到不同的组中
  
  		（6）简化|规约
  			>对集合内部元素之间进行聚合 
  			>reduce   聚合的数据类型一致
  			>reduceLeft|reduceRight 	聚合的数据类型可以不一致
  
  		（7）折叠
  			>对外部元素和集合内部元素之间进行聚合
  			>fold 	聚合的数据类型一致
  			>foldLeft|foldRight		聚合的数据类型可以不一致
  ````

  

## 下划线的用法

* 标识符命名
* 导包
  - 导入某一个类下的"静态成员" ：import scala.util.control.Breaks._
  - 导入某一包下的所有类：import java.util._
  - 屏蔽类：import java.sql.{Date=>_,Array=>_,_}
* 匿名函数
  - 如果在匿名函数中，参数只出现了一次，那么参数可以省略，在函数体使用参数的时候，用下划线代替
* 在类中声明属性，如果要给属性赋默认值
* 在模式匹配中
  - case_  表示上面所有case都没有匹配成功的情况，相当于default


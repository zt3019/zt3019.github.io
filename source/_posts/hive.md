---
title: Hive
date: 2021-06-04 19:39:54
tags:
- 大数据
categories:
- 大数据
- Hive
index_img: https://tse4-mm.cn.bing.net/th/id/OIP.0YDh0T1VxxssqKBcgGX7AgHaEK?w=267&h=180&c=7&o=5&pid=1.7
banner_img: https://tse4-mm.cn.bing.net/th/id/OIP.0YDh0T1VxxssqKBcgGX7AgHaEK?w=267&h=180&c=7&o=5&pid=1.7
---

# Hive

## Hive基础知识

* Hive：由Facebook开源用于解决海量结构化日志的数据统计工具。

  Hive是基于Hadoop的一个***数据仓库工具***，可以***将结构化的数据文件映射为一张表***，并***提供类SQL查询功能***。

  本质是：将HQL转化成MapReduce程序

* 优点：1. 操作采用类SQL语法，提供快速开发的能力。

* 缺点： 1. 效率低

* 架构原理：[![2YmPaT.png](https://z3.ax1x.com/2021/06/04/2YmPaT.png)](https://imgtu.com/i/2YmPaT)

* 大致流程：Hive通过给用户提供的一系列交互接口，接收到用户的指令(SQL)，使用自己的Driver，结合元数据(MetaStore)，将这些指令翻译成MapReduce，提交到Hadoop中执行，最后，将执行返回的结果输出到用户交互接口。

* Hive Beeline 是一个命令行工具，它是 Hive 的一部分，用于与 HiveServer2 进行交互。HiveServer2 是 Hive 的一个服务端组件，它提供了 JDBC/ODBC 接口，允许外部客户端（如 Hive Beeline）连接并执行 HiveQL 查询。

* hiveserver2，如果使用beeline，需要开启hiveserver2

* 架构解析：

  1. 用户接口：Client.CLI（command-line interface）、JDBC/ODBC(jdbc访问hive)、WEBUI（浏览器访问hive）

  2. 元数据：Meta store .元数据包括：表名、表所属的数据库（默认是default）、表的拥有者、列/分区字段、表的类型（是否是外部表）、表的数据所在目录等；

     默认存储在自带的derby数据库中（只支持但客户端访问），推荐使用MySQL存储Metastore（支持多客户端访问）

     Metastore的作用是：客户端连接metastore服务，metastore再去连接MySQL数据库来存取元数据。有了metastore服务，就可以有多个客户端同时连接，而且这些客户端不需要知道MySQL数据库的用户名和密码，只需要连接metastore 服务即可。

     - 内嵌模式使用的是内嵌的Derby数据库来存储元数据，也不需要额外起Metastore服务。这个是默认的，配置简单，但是一次只能一个客户端连接，适用于用来实验，不适用于生产环境。
     - 本地元存储和远程元存储都采用外部数据库来存储元数据，目前支持的数据库有：MySQL、Postgres、Oracle、MS SQL Server.在这里我们使用MySQL。
     - 本地元存储和远程元存储的区别是：本地元存储不需要单独起metastore服务，用的是跟hive在同一个进程里的metastore服务。远程元存储需要单独起metastore服务，然后每个客户端都在配置文件里配置连接到该metastore服务。远程元存储的metastore服务和hive运行在不同的进程里。

  3. Hadooop.使用HDFS进行存储，使用MapReduce进行计算。

  4. 驱动器：Driver.

     1. 包括解析器（SQL Parser）:将SQL字符串转换成抽象语法树AST
     2. 编译器（Physical Plan）：将AST编译生成逻辑执行计划。
     3. 优化器（Query Optimizer）：对逻辑执行计划进行优化。
     4. 执行器（Execution）：把逻辑执行计划转换成可以运行的物理计划。对于Hive来说，就是MR/Spark/Tez。

* Tez引擎

  - 可以理解为一个加强版的MapReduce。比MapReduce更快，但是消耗更多的内存

* hive的数据类型

  | Hive数据类型 | Java数据类型 | 长度                                                 | 例子                                 |
  | ------------ | ------------ | ---------------------------------------------------- | ------------------------------------ |
  | TINYINT      | byte         | 1byte有符号整数                                      | 20                                   |
  | SMALINT      | short        | 2byte有符号整数                                      | 20                                   |
  | INT          | int          | 4byte有符号整数                                      | 20                                   |
  | BIGINT       | long         | 8byte有符号整数                                      | 20                                   |
  | BOOLEAN      | boolean      | 布尔类型，true或者false                              | TRUE  FALSE                          |
  | FLOAT        | float        | 单精度浮点数                                         | 3.14159                              |
  | DOUBLE       | double       | 双精度浮点数                                         | 3.14159                              |
  | STRING       | string       | 字符系列。可以指定字符集。可以使用单引号或者双引号。 | ‘now is the time’ “for all good men” |
  | TIMESTAMP    |              | 时间类型                                             |                                      |
  | BINARY       |              | 字节数组                                             |                                      |

集合数据类型：

| 数据类型 | 描述                                                         | 语法示例                                       |
| -------- | ------------------------------------------------------------ | ---------------------------------------------- |
| STRUCT   | 和c语言中的struct类似，都可以通过“点”符号访问元素内容。例如，如果某个列的数据类型是STRUCT{first STRING, last STRING},那么第1个元素可以通过字段.first来引用。 | struct()例如struct<street:string, city:string> |
| MAP      | MAP是一组键-值对元组集合，使用数组表示法可以访问数据。例如，如果某个列的数据类型是MAP，其中键->值对是’first’->’John’和’last’->’Doe’，那么可以通过字段名[‘last’]获取最后一个元素 | map()例如map<string, int>                      |
| ARRAY    | 数组是一组具有相同类型和名称的变量的集合。这些变量称为数组的元素，每个数组元素都有一个编号，编号从零开始。例如，数组值为[‘John’, ‘Doe’]，那么第2个元素可以通过数组名[1]进行引用。 | Array()例如array<string>                       |

* 数据类型转化
  - 隐式转化   与java类似。1.所有整数类型、FLOAT和STRING类型都可以隐式地转换成DOUBLE
  - 强制转化 CAST('1' AS INT)将把字符串'1' 转换成整数1；如果强制类型转换失败，如执行CAST('X' AS INT)，表达式返回空值 NULL。

### Hive 执行引擎

* hive前期版本默认是mapreduce。后面有tez引擎（基于内存较多，生成dag执行图，会做一些优化，比mr快很多，但对内存的要求也更高）
* **Spark on Hive**
  - 就是同步Sparksql,加载hive的配置文件，获取到hive的元数据信息
  - Spark sql获取到hive的元数据信息之后就可以拿到hive的所有表的数据
  - 接下来就可以通过spark sql来操作hive表中的数据
* **Hive on Spark**
  - 就是把hive查询从MR换成spark,参考官方的版本配置，不然很容易遇到依赖冲突。
  - 之后还是在hive上写hivesql，但是执行引擎是spark，任务会转化成spark rdd算子去执行。
  - 优化器还是hive的优化器，而没有spark sql自带的优化器的效果好
* 二者的核心区别在于，客户端的 SQL 是否提交给了服务角色 HiveServer2 (org.apache.hive.service.server.HiveServer2)，且该hs2配置了 hive.execution.engine=spark;

## SQL语言的分类

**SQL语言的分类**

SQL语言共分为四大类：数据查询语言DQL，数据操纵语言DML，数据定义语言DDL，数据控制语言DCL。

**1. 数据查询语言DQL**
数据查询语言DQL基本结构是由SELECT子句，FROM子句，WHERE
子句组成的查询块：
SELECT <字段名表>
FROM <表或视图名>
WHERE <查询条件>

**2 .数据操纵语言DML**
数据操纵语言DML主要有三种形式：
1) 插入：INSERT
2) 更新：UPDATE
3) 删除：DELETE

**3. 数据定义语言DDL**
数据定义语言DDL用来创建数据库中的各种对象-----表、视图、
索引、同义词、聚簇等如：
CREATE TABLE/VIEW/INDEX/SYN/CLUSTER
| | | | |
表 视图 索引 同义词 簇

DDL操作是隐性提交的！不能rollback 

**4. 数据控制语言DCL**
数据控制语言DCL用来授予或回收访问数据库的某种特权，并控制
数据库操纵事务发生的时间及效果，对数据库实行监视等。如：
1) GRANT：授权。


2) ROLLBACK [WORK] TO [SAVEPOINT]：回退到某一点。
回滚---ROLLBACK
回滚命令使数据库状态回到上次最后提交的状态。其格式为：
SQL>ROLLBACK;


3) COMMIT [WORK]：提交。

  在数据库的插入、删除和修改操作时，只有当事务在提交到数据
库时才算完成。在事务提交前，只有操作数据库的这个人才能有权看
到所做的事情，别人只有在最后提交完成后才可以看到。
提交数据有三种类型：显式提交、隐式提交及自动提交。下面分
别说明这三种类型。

(1) 显式提交
用COMMIT命令直接完成的提交为显式提交。其格式为：
SQL>COMMIT；

(2) 隐式提交
用SQL命令间接完成的提交为隐式提交。这些命令是：
ALTER，AUDIT，COMMENT，CONNECT，CREATE，DISCONNECT，DROP，
EXIT，GRANT，NOAUDIT，QUIT，REVOKE，RENAME。

(3) 自动提交
若把AUTOCOMMIT设置为ON，则在插入、修改、删除语句执行后，
系统将自动进行提交，这就是自动提交。其格式为：
SQL>SET AUTOCOMMIT ON；

## DDL语句

* 库的DDL

* 创建语句，location就相当于数据库，他们之间是有映射关系的

  ````hive
  CREATE DATABASE [IF NOT EXISTS] database_name
  [COMMENT database_comment]
  [LOCATION hdfs_path]
  [WITH DBPROPERTIES (property_name=property_value, ...)];
  
  --显示数据库
  show databases;
  hive> show databases like 'db_hive*';
  OK
  db_hive
  db_hive_1
  
  --显示数据库详细信息
  desc database extended db_hive;
  
  --删除数据库
  drop database db_hive2;
  
  --如果数据库不为空，可以采用cascade命令，强制删除
  drop database db_hive cascade;
  ````

  

* 表的DDL

* 创建表

  ````hive
  CREATE [EXTERNAL] TABLE [IF NOT EXISTS] table_name 
  [(col_name data_type [COMMENT col_comment], ...)] 
  [COMMENT table_comment] 
  [PARTITIONED BY (col_name data_type [COMMENT col_comment], ...)] 
  [CLUSTERED BY (col_name, col_name, ...) 
  [SORTED BY (col_name [ASC|DESC], ...)] INTO num_buckets BUCKETS] 
  [ROW FORMAT row_format] 
  [STORED AS file_format] 
  [LOCATION hdfs_path]
  [TBLPROPERTIES (property_name=property_value, ...)]
  [AS select_statement]
  
  --（7）ROW FORMAT 
  DELIMITED [FIELDS TERMINATED BY char] [COLLECTION ITEMS TERMINATED BY char]
          [MAP KEYS TERMINATED BY char] [LINES TERMINATED BY char] 
     | SERDE serde_name [WITH SERDEPROPERTIES (property_name=property_value, property_name=property_value, ...)]
  用户在建表的时候可以自定义SerDe或者使用自带的SerDe。如果没有指定ROW FORMAT 或者ROW FORMAT DELIMITED，将会使用自带的SerDe。在建表的时候，用户还需要为表指定列，用户在指定表的列的同时也会指定自定义的SerDe，Hive通过SerDe确定表的具体的列的数据。
  
  ````

* 内部表

  - 默认创建的是内部表，也叫管理表。当我们删除一个管理表时，Hive也会删除这个表中数据。管理表不适合和其他工具共享数据。

* 外部表

  - 创建时加上 external
  - 以Hive并非认为其完全拥有这份数据。删除该表并不会删除掉这份数据，不过描述表的元数据信息会被删除掉。
  - **结论: 外部表的数据不由hive自身负责管理，虽然数据会被加载到/user/hive/warehouse/，但是不由hive管理。**
  - **指定location：指定加载数据的位置，不再是默认加载到/user/hive/warehouse/目录下了。**

* 内部表外部表转化

  - 修改内部表student2为外部表

    ````hive
    修改内部表student2为外部表
    alter table student2 set tblproperties('EXTERNAL'='TRUE');
    
    --查询表的类型
    desc formatted student2;
    --转换为内部表
    alter table student2 set tblproperties('EXTERNAL'='FALSE');
    ````

* 分区表

* <font color=red>Hive中的分区就是分目录</font>，把一个大的数据集根据业务需要分割成小的数据集。

  - ````hive
    create table dept_partition(deptno int, dname string, loc string
    )
    partitioned by (month string)
    row format delimited fields terminated by '\t';
    --分区字段不能是表中已经存在的数据，可以将分区字段看作表的伪列。
    -- 查询分区表的分区
    show partitions dept_partition
    --如果提前准备数据，但是没有元数据
    --把数据直接上传到分区目录上，让分区表和数据产生关联的三种方式
    --1.添加分区
    alter table dept_partition add partition(class="03")
    --2.直接修复
    msck repair table stu_par;
    --3.上传带分区
    
    --同时创建分区
    alter table dept_partition add partition(month='201705'), partition(month='201704');
    --删除多个分区
     alter table dept_partition drop partition (month='201705'), partition (month='201706');
    ````
    
  - 分区表不能转换，只能在建表时就建好
  
  - 支持二级分区
  
    ````hive
    create table dept_partition2(
                   deptno int, dname string, loc string
                   )
                   partitioned by (month string, day string)
                   row format delimited fields terminated by '\t';
    ````
  
    
  
* 修改表

  ````hive
  -- 修改表注释
  ALTER TABLE 表名 SET TBLPROPERTIES('comment' = '表注释内容');
  -- 修改表名
  ALTER TABLE table_name RENAME TO new_table_name
  -- 更新列
  ALTER TABLE table_name CHANGE [COLUMN] col_old_name col_new_name column_type [COMMENT col_comment] [FIRST|AFTER column_name]
  -- 增加和替换列
  ALTER TABLE table_name ADD|REPLACE COLUMNS (col_name data_type [COMMENT col_comment], ...) 
  -- REPLACE 则是表示替换表中所有字段（修改不修改的列都需要写上）。
  -- 删除表
  drop table dept_partition;
  ````
  
  

## DML

* 数据导入

  ````hive
  --创建语句
  create table student(id string, name string) row format delimited fields terminated by '\t';
  --1.load导入数据
  load data [local] inpath '/opt/module/datas/student.txt' [overwrite] into table student [partition (partcol1=val1,…)];
  --本地数据导入
  load data local inpath '/opt/module/datas/student.txt' into table default.student;
  --hdfs数据导入
  load data inpath '/user/zt/hive/student.txt' into table default.student;
  --加载数据覆盖表中已有的数据
  load data inpath '/user/zt/hive/student.txt' overwrite into table default.student;
  --hdfs的导入是移动，本地导入是复制
  ````

  

  ````hive
  --2.通过查询语句向表中插入数据（Insert）
   create table student_par(id int, name string) partitioned by (month string) row format delimited fields terminated by '\t';
   
  insert overwrite table student partition(month='201708')
               select id, name from student where month='201709';
               
  --insert into：以追加数据的方式插入到表或分区，原有数据不会删除
  --insert overwrite：会覆盖表或分区中已存在的数据
  
  --3.建表时用as select
  create table if not exists student3
  as select id, name from student;
  
  --4.创建表时通过Location指定加载数据路径
  create external table if not exists student5(
                id int, name string
                )
                row format delimited fields terminated by '\t'
                location '/student;'
  
  
  -- 5.Import数据到指定Hive表中
  import table student2 partition(month='201709') from
   '/user/hive/warehouse/export/student';
  ````

  

* 数据导出(不重要)

  ````hive
  --1. Insert导出
  --将查询结果导出到本地
  insert overwrite local directory '/opt/module/datas/export/student'
              select * from student;
              
  --将查询的结果格式化导出到本地
  insert overwrite local directory '/opt/module/datas/export/student1'
             ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'             select * from student;
             
  --将查询的结果导出到HDFS上(没有local)
  insert overwrite directory '/user/zt/student2'
  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
  select * from student;
  --整张表export 到处到HDFS
  export table default.student to
   '/user/hive/warehouse/export/student';
  ````

  

* 清除数据

  ````hive
  --Truncate只能删除管理表（内部表），不能删除外部表中数据
  --只删除数据，不删除本身
  truncate table student;
  ````

  

## DQL

### 数据查询语言

#### 1. 基本查询（select.....from.....）

（1）SQL 语言大小写不敏感。 

（2）SQL 可以写在一行或者多行

（3）关键字不能被缩写也不能分行

（4）各子句一般要分行写。

（5）使用缩进提高语句的可读性。

* 别名

  - 紧跟列名，也可以在列名和别名之间加入关键字‘AS’

  - select ename AS name, deptno dn from emp;

* 算数运算符

  - select sal +1 from emp;

  | 运算符 | 描述           |
  | ------ | -------------- |
  | A+B    | A和B 相加      |
  | A-B    | A减去B         |
  | A*B    | A和B 相乘      |
  | A/B    | A除以B         |
  | A%B    | A对B取余       |
  | A&B    | A和B按位取与   |
  | A\|B   | A和B按位取或   |
  | A^B    | A和B按位取异或 |
  | ~A     | A按位取反      |

* 常用函数

  - UDF函数：一个输入一个输出 select substring(ename,1,1) from emp;（从ｅname的1开始，取一个字符）用户定义（普通）函数，只对单行数值产生作用。实现：继承UDF，实现evaluate()方法
  - UDAF函数：多个输入，一个输出 select count(*) cnt from emp;用户定义聚合函数，可对多行数据产生作用；等同与SQL中常用的SUM()，AVG()，也是聚合函数；
  - UDTF函数：一个输入，多个输出。用户定义表生成函数。用来解决输入一行输出多行；实现：继承GenericUDTF，实现initialize(),process(),close()方法

  ````hive
  --1．求总行数（count）
  select count(*) cnt from emp;
  --2．求工资的最大值（max）
  select max(sal) max_sal from emp;
  --3．求工资的最小值（min）
  select min(sal) min_sal from emp;
  --4．求工资的总和（sum）
  select sum(sal) sum_sal from emp; 
  --5．求工资的平均值（avg）
  select avg(sal) avg_sal from emp;
  ````

* LIMIT子句用于限制返回的行数

  - select * from emp limit 5;

#### 2.条件过滤

 1. 使用where子句，将不满足条件的行过滤掉

    select * from emp where sal =5000;

 2. 比较运算符：下面表中描述了谓词操作符，这些操作符同样可以用于JOIN…ON和HAVING语句中

    | 操作符                  | 支持的数据类型 | 描述                                                         |
    | ----------------------- | -------------- | ------------------------------------------------------------ |
    | A=B                     | 基本数据类型   | 如果A等于B则返回TRUE，反之返回FALSE                          |
    | A<=>B                   | 基本数据类型   | 如果A和B都为NULL，则返回TRUE，其他的和等号（=）操作符的结果一致，如果任一为NULL则结果为NULL |
    | A<>B, A!=B              | 基本数据类型   | A或者B为NULL则返回NULL；如果A不等于B，则返回TRUE，反之返回FALSE |
    | A<B                     | 基本数据类型   | A或者B为NULL，则返回NULL；如果A小于B，则返回TRUE，反之返回FALSE |
    | A<=B                    | 基本数据类型   | A或者B为NULL，则返回NULL；如果A小于等于B，则返回TRUE，反之返回FALSE |
    | A>B                     | 基本数据类型   | A或者B为NULL，则返回NULL；如果A大于B，则返回TRUE，反之返回FALSE |
    | A>=B                    | 基本数据类型   | A或者B为NULL，则返回NULL；如果A大于等于B，则返回TRUE，反之返回FALSE |
    | A [NOT] BETWEEN B AND C | 基本数据类型   | 如果A，B或者C任一为NULL，则结果为NULL。如果A的值大于等于B而且小于或等于C，则结果为TRUE，反之为FALSE。如果使用NOT关键字则可达到相反的效果。 |
    | A IS NULL               | 所有数据类型   | 如果A等于NULL，则返回TRUE，反之返回FALSE                     |
    | A IS NOT NULL           | 所有数据类型   | 如果A不等于NULL，则返回TRUE，反之返回FALSE                   |
    | IN(数值1, 数值2)        | 所有数据类型   | 使用 IN运算显示列表中的值                                    |
    | A [NOT] LIKE B          | STRING 类型    | B是一个SQL下的简单正则表达式，也叫通配符模式，如果A与其匹配的话，则返回TRUE；反之返回FALSE。B的表达式说明如下：‘x%’表示A必须以字母‘x’开头，‘%x’表示A必须以字母’x’结尾，而‘%x%’表示A包含有字母’x’,可以位于开头，结尾或者字符串中间。如果使用NOT关键字则可达到相反的效果。 |
    | A RLIKE B, A REGEXP B   | STRING 类型    | B是基于java的正则表达式，如果A与其匹配，则返回TRUE；反之返回FALSE。匹配使用的是JDK中的正则表达式接口实现的，因为正则也依据其中的规则。例如，正则表达式必须和整个字符串A相匹配，而不是只需与其字符串匹配。 |

```hive
--通配符字符串匹配　% _
--%匹配任意串，_匹配任意字符
--查询以A开头的员工
select * from emp where ename like "A%";

--正则匹配
--查询以A开头的员工
select * from emp where ename rlike "^A"; 
```

* rlike匹配正则表达式

* 正则表达式

  ````
  一般字符匹配自己
  ^ 匹配一行开头 ^R 以R开头
  $ 匹配一行结束 R$ 以R结尾
  . 匹配任意字符 ^.$ 一行只有一个字符
  * 前一个子式匹配零次或多次
  .*匹配任意字符
  [] 匹配一个范围内的任意字符
  \ 转义
  ````

3. 逻辑运算符（AND，OR，NOT）

   ````hive
   select * from emp where sal>1000 and deptno=30;
   select * from emp where sal>1000 or deptno=30;
   select * from emp where deptno not IN(30, 20);
   ````

   

#### 3. 分组

* GROUP BY语句通常会和聚合函数一起使用，按照一个或者多个列队结果进行分组，然后对每个组执行聚合操作。

* （1）where后面不能写分组函数，而having后面可以使用分组函数。

  （2）having只用于group by分组统计语句。

  

* ````hive
  --计算emp表每个部门的平均工资
  select t.deptno, avg(t.sal) avg_sal from emp t group by t.deptno
  --求每个部门的平均薪水大于2000的部门
  select deptno, avg(sal) avg_sal from emp group by deptno having
   avg_sal > 2000;
  ````

#### 4.连接

* Hive支持通常的SQL JOIN语句，但是只支持等值连接，不支持非等值连接。

  - 内连接
  - 左外连接
  - 右外连接
  - 满外连接

  ````hive
  select
      e.empno,
      e.ename,
      d.deptno, 
      d.dname 
  from 
      emp e 
  join
      dept d 
  on
      e.deptno = d.deptno;
      
  ````

* 表的别名：好处：1.简化查询，使用表名前缀可以提高执行效率

* 多表连接

  ````hive
  SELECT 
      e.ename,
      d.dname, 
      l.loc_name
  FROM
  	emp e 
  JOIN
  	dept d
  ON
  	d.deptno = e.deptno 
  JOIN
  	location l
  ON
  	d.loc = l.loc;
  ````



* **hive join目前不支持在on子句中使用谓词or(hive1 不支持)**

  select e.empno, e.ename, d.deptno from emp e join dept d on e.deptno

  = d.deptno or e.ename=d.deptno;  在hive1错误的,hive3支持

#### 5.排序

* order by:全局排序，只有一个Reducer(极易造成数据倾斜)
* ASC（ascend）: 升序（默认）
* DESC（descend）: 降序
* sort by:局部排序（sort by 为每个reduce产生一个排序文件。每个Reduce内部进行排序，对全局结果来说不是排序）

````hive
--一般需求不会要求给所有的数据排序，而要求知道前几
--求工资前10的人，Map会先求局部前10
select *
from emp
order by sal desc
limit 10;

--还有一种可能，我们只需要看大概的数据趋势，不需要全排序
--Hive的局部排序 sort by
select *
from emp
sort by empno desc;

--多条件排序，先按部门排序，再按工资排序
select *
from emp
order by
deptno asc,
sal desc;

--limit,offset
limit X,Y 跳过X条数据，取Y条数据
offset X 跳过X条数据
````

* 分区排序 （Distribute By）

* ***distribute by***类似MR中partition（自定义分区），进行分区，结合sort by使用。 

  ````hive
  --指定局部排序的分区字段
  select * from emp
  distribute by empno
  sort by sal desc;
  
  --如果分区和排序的字段一样，我们可以用cluster by代替
  select * from emp distribute by empno sort by empno;
  select * from emp cluster by empno;
  ````

* 当distribute by和sorts by字段相同时，可以使用cluster by方式。

  

#### 6.分桶

* 分区提供一个隔离数据和优化查询的便利方式。不过，并非所有的数据集都可形成合理的分区。对于一张表或者分区，Hive 可以进一步组织成桶，也就是更为细粒度的数据范围划分。
* 分区针对的是数据的存储路径；分桶针对的是数据文件。

* 分桶：针对某一个区的数据，把它的数据进一步组织成多个文件

* 分区：把多个数据，分成文件夹管理

  ````hive
  create table stu_buck(id int, name string)
  clustered by(id) 
  into 4 buckets
  row format delimited fields terminated by '\t';
  
  
  ````

* 分桶抽样查询

* 对于非常大的数据集，有时用户需要使用的是一个具有代表性的查询结果而不是全部结果。Hive可以通过对表进行抽样来满足这个需求。

  ````hive
  select * from stu_buck tablesample(bucket 1 out of 4 on id);
  --tablesample是抽样语句，语法：TABLESAMPLE(BUCKET x OUT OF y) 
  --y必须是table总bucket数的倍数或者因子(因子就是所有可以整除这个数的数,不包括这个数自身)。hive根据y的大小，决定抽样的比例
  把数据按照bucket分成y份，取其中的第x份
  ````

  

### 常用查询函数

#### 常用函数

```hive
hive中查询函数
show functions
show functions like "collect*"
查看函数的描述
desc function 函数名
--nvl空字段赋值
select comm, nvl(comm, -1) from emp;
```



```hive
--case when
--统计不同部门男女各有多少人
select
    dept_id,
    count(*) total,
    sum(case sex when '男' then 1 else 0 end) male,
    sum(case sex when '女' then 1 else 0 end) female
from
    emp_sex
group by
    dept_id;
```



```hive
在 Group by 子句中，Select 查询的列，要么需要是 Group by 中的列，要么得是用聚合函数（比如 sum、count 等）加工过的列。不支持直接引用非 Group by 的列。这一点和 MySQL 有所区别。Hive 错误 Expression not in GROUP BY key的原因。
--行转列
collect_list(x),聚合成一个数组，聚合函数
concat_ws("分隔符"，数组)，把数组按分割符拼成一个字符串
contact(str1,str2......,strn)拼接几列在一起

select
    concat(constellation,",",blood_type) xzxx,
    concat_ws("|", collect_list(name)) rentou
from
    person_info
group by
    constellation,blood_type;
```



```hive
--列转行
--explode(a)函数
--如果传入的是一个数组，则将其分成多行
--如果传入一个map,按照key,value分成两列
--split(str,regrex)函数
--将一个字符串按照正则表达式规则划分成一个数组
lateral view 后面接一个表名，起一个列名，列名取决于explode()炸开后的效果。
select
    m.movie,
    tbl.cate
from
    movie_info m
lateral view
    explode(split(category, ",")) tbl as cate;
```

#### 窗口函数

* 相关函数说明

  OVER()：指定分析函数工作的数据窗口大小，这个数据窗口大小可能会随着行的变而变化。

  CURRENT ROW：当前行

  n PRECEDING：往前n行数据

  n FOLLOWING：往后n行数据

  UNBOUNDED：UNBOUNDED PRECEDING 表示从前面的起点， UNBOUNDED FOLLOWING表示到后面的终点

  LAG(col,n,default_val)：往前第n行数据

  LEAD(col,n, default_val)：往后第n行数据

  NTILE(n)：把有序窗口的行分发到指定数据的组中，各个组有编号，编号从1开始，对于每一行，NTILE返回此行所属的组的编号。注意：n必须为int类型。

  percent_rank()将数据按百分比分

```hive
--聚合
select name,count(*) over () 
from business 
where substring(orderdate,1,7) = '2017-04' 
group by name;
```

```hive
--各种聚合
select name,orderdate,cost, 
sum(cost) over() as sample1,--所有行相加 
sum(cost) over(partition by name) as sample2,--按name分组，组内数据相加 
sum(cost) over(partition by name order by orderdate) as sample3,--按name分组，组内数据累加 
sum(cost) over(partition by name order by orderdate rows between UNBOUNDED PRECEDING and current row ) as sample4 ,--和sample3一样,由起点到当前行的聚合 
sum(cost) over(partition by name order by orderdate rows between 1 PRECEDING and current row) as sample5, --当前行和前面一行做聚合 
sum(cost) over(partition by name order by orderdate rows between 1 PRECEDING AND 1 FOLLOWING ) as sample6,--当前行和前边一行及后面一行 
sum(cost) over(partition by name order by orderdate rows between current row and UNBOUNDED FOLLOWING ) as sample7 --当前行及后面所有行 
from business;
```

```hive
--结合其他函数使用
select
    name, orderdate, cost, 
    lag(orderdate, 1) 
    over(partition by name order by orderdate) last_order,
    lead(orderdate, 1) 
    over(partition by name order by orderdate) next_order
from
    business;
```

```hive
--ntile
Ntile(group_num) 将所有记录分成group_num个组，每组序号一样
SELECT
	*
FROM
	(
		select name,
		orderdate,
		cost,
		ntile(5) over(
		order by orderdate) n
	from
		business) t1
WHERE
	n = 1;
```

```hive
-- percent_rank
-- percent_rank() 含义就是 当前行-1 / 当前组总行数-1
select
	name,
	orderdate,
	cost,
	PERCENT_RANK() over(
	order by orderdate) pr
from
	business;
```

```hive
--rank
rank()排序，相同的一样排名，数字按照实际的来，类似于高考排名
dense_rank() 相同的一样排名，数字按照排名的数字来
row_number() 直接排名，相同的排名也不一样
SELECT
	*,
	rank() OVER(partition by subject
order by
	score desc) r,
	DENSE_RANK() OVER(partition by subject
order by
	score desc) dr,
	ROW_NUMBER() OVER(partition by subject
order by
	score desc) rn
from
	score;
```

#### 日期函数

```hive
--current_date 返回当前日期
select current_date();
```

```hive
-- 日期的加减
-- 今天开始90天以后的日期
select date_add(current_date(), 90);
-- 今天开始90天以前的日期
select date_sub(current_date(), 90);
```

```hive
--日期差
SELECT datediff(CURRENT_DATE(), "1990-06-04");
```

习题：有哪些顾客连续两天来过我的店，数据是business表

````hive
--习题:连续登录
-- 有哪些顾客连续两天来过我的店，数据是business表

--time1下一次购买商品的时间
select
name,cost,orderdate,
lead(orderdate,1,"2021-09-01") over(partition by name order by orderdate) time1
from
business

--时间差
select
name,cost,orderdate,time1,
datediff(time1,orderdate) difftime
from
    (select
name,cost,orderdate,
lead(orderdate,1,"2021-09-01") over(partition by name order by orderdate) time1
from
business) tab;

--找到时间差为1的人
select
name,corderdate,time1,difftime
from
(select
name,cost,orderdate,time1,
datediff(time1,orderdate) difftime
from
    (select
name,cost,orderdate,
lead(orderdate,1,"2021-09-01") over(partition by name order by orderdate) time1
from
business) tab) tab1
where
difftime=1;

````

* hive重点：写sql,熟练使用函数，尤其是开窗函数

### SQL一般执行顺序

1. from 确定基表
2. join on 如果一张基表不够, 再联接其他表,或者lateral view explode(需炸裂的列) table_name as 炸裂后的列名 
3. where 过滤总基表中的行
4. group by 分组, 分组依据的列.（可以开始使用select中的别名，从group 开始往后都可用）
5. select 把分组依据的列放在select后, 再考虑要选择哪些列, 及进行哪些函数调用 sum(),count(1)等
6. having 进一步把分组后的虚表行过滤
7. ***窗口函数***，select中若包含over()开窗函数，**执行完非开窗函数后，select等待执行完开窗函数，随后select执行结束**，开窗函数通过表数据进行分区和排序，跟select查询中的字段是平行关系，不依赖查询字段。
8. distinct
9. order by 最终表的一个排序显示.
10. limit

## 调优

### 小文件优化

* 小文件的产生：
  - 动态分区插入数据，产生大量小文件，导致map数量剧增
  - reduce个数等于输出的文件个数，如果reduce个数多同时文件大小小的话就会产业很多小文件
  - **用datax同步数据时，设则多线程，如果数据量不大的情况下，生成了小文件**
  
* 带来的问题：
  - 小文件会导致开启很多很多map，一个map开一个JVM执行，所以这些任务的初始化，启动，执行会浪费大量的资源，严重影响性能。
  - 小文件也会占用NameNode元数据的内存，如果太多小文件的话，会占用很多的NameNode的内存

* 常用的一些hive参数设置，可以做为一些通用的优化手段。但是对于没有效果的的sql代码还是需要具体情况具体分析

* ````hive
  -- 执行Map前进行小文件合并
  set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
  -- 填的数都为byte数
  -- 每个Map最大输入大小(这个值决定了合并后文件的数量)
  set mapred.max.split.size=128000000;
  -- 每个map最小输入大小
  set mapred.min.split.size=10000000;
  
  -- 上面的参数配置同时也要考虑到：1.文件的格式是否可以切分；2.是否开启了压缩等因素
  
  -- 一个节点上split的至少的大小(这个值决定了多个DataNode上的文件是否需要合并)
  set mapred.min.split.size.per.node=100000000;
  
  -- 一个机架下split的至少的大小(这个值决定了多个机架上的文件是否需要合并)
  set mapred.min.split.size.per.rack=100000000;
  
  -- 这四个参数是有优先级的，一般来说优先级如下：
  -- max.split.size <= min.split.size <= min.size.per.node <= min.size.per.rack
  
  -- 要想达到控制map任务个数的效果，要按照优先级合理配置参数的值
  -- 一般来说按照上面配置参数后可以到达map数约等于文件大小/128 个（但是要注意文件是否压缩，是否可切分等情况）
  /**
  -- map数量由三个方面决定
  1.文件个数
  2.文件大小
  3.blocksize
  -- 因为map端一般都会默认开启聚合小文件的参数，所以文件个数我们先不考虑
  -- 一般情况下，粗略计算任务map个数=文件大小/blocksize
  */
  
  
  -- 设置map端输出进行合并，默认为true
  set hive.merge.mapfiles = true;
  
  -- 设置reduce端输出进行合并，默认为false
  set hive.merge.mapredfiles = true;
  
  -- 设置合并文件的大小
  set hive.merge.size.per.task = 128000000;
  
  -- 当输出文件的平均大小小于该值时，启动一个独立的MapReduce任务进行文件merge。
  set hive.merge.smallfiles.avgsize=16000000;
  
  -- 每个reducer任务处理的数据量
  set hive.exec.reducers.bytes.per.reducer=128000000;
  -- 4999 每个任务的最大reducer数量
  hive.exec.reducers.max=4999;
  
  -- reduce任务个数一般等于map输出的文件大小/hive.exec.reducers.bytes.per.reduce 的值。（也要考虑文件是否压缩的情况）
  
  -- 或者指定设置reduce个数。-1表示不指定
  set mapreduce.job.reduces=-1;
  /**
  一些情况指定设置reduce个数，是无效的
  1.order by 最终只会生成一个reduce
  2.笛卡尔积，笛卡尔积也是全局聚合，只能一个reduce处理
  2.map端输出的数据量很小
  */
  ````
  
* 预防小文件的一个基础通用配置，可以默认放在sql前面

  ````hive
  -- 设置Hive输入,执行map前进行小文件合并
  set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
  -- 每个map最大输入大小
  set mapred.max.split.size=256000000;
  -- 每个map最小输入大小
  set mapred.min.split.size=128000000;
  --节点上最小分片大小,每个节点处理的最小split
  set mapred.min.split.size.per.node=128000000;
  -- 机架上最小分片大小,决定不同机架的DataNode上文件是都进行合并。每个机架处理的最小split
  set mapred.min.split.size.per.rack=128000000;
  
  --输出合并
  -- 设置map端输出进行合并，默认为true
  set hive.merge.mapfiles = true;
  -- 设置reduce端输出进行合并，默认为false
  set hive.merge.mapredfiles = true;
  -- 小于这个值会开启一个独立的mapreduce任务进行小文件合并,默认16m
  set hive.merge.smallfiles.avgsize=16000000;
  -- 合并后的文件大小,默认256m,推荐128m,一个hdfs分块的大小
  set hive.merge.size.per.task=128000000;
  ````

  

* distribute by处理已有的小文件

* ````hive
  insert overwrite table 目标表 [partition(hour=...)] select * from 目标表 
  distribute by floor( rand() * 具体最后落地生成多少个文件数);
  distribute by `floor`(rand() * 5)
  /**
  rand()函数生成一个介于0（包含）和1（不包含）之间的随机浮点数。
  这个随机数乘以5，得到一个介于0（包含）和5（不包含）之间的随机浮点数。
  floor()函数取这个浮点数的整数部分，结果将是0、1、2、3或4中的一个。
  因此，floor(rand() * 5)将生成一个随机整数，这个整数用作分发的键，将数据随机分配到5个reducer中的一个。
  */
  
  /**
  作用
  数据随机化：如果你想要随机地将数据分发到reducer上，这可能是有用的。例如，如果你正在进行随机采样或者想要确保数据在reducer之间均匀分布。
  测试：在测试Hive查询或MapReduce作业时，随机分配数据可以帮助你检查代码是否能够正确处理不同的reducer分配情况。
  负载均衡：如果某个键的值非常倾斜（即大部分数据都属于同一个键），使用随机分配可以帮助平衡reducer之间的负载。
  
  注意：
  需要注意的是，使用rand()可能会导致性能问题，因为每个输入行都会调用rand()函数，这可能会增加计算的开销。此外，这种方法可能会导致数据分布不均匀，因为随机性意味着无法保证每个reducer获得相同数量的数据。在使用这种方法时，应该考虑到这些潜在的问题。
  */
  ````

* concatenate 命令

  - ````hive
    alter table test [partition(...)] concatenate
    
    
    alter table ods.ods_qxb_t_report_details_di partition(ds='20240328') concatenate;
    -- 这种方法仅仅适用于orc格式存储的表
    -- 只能内部表使用
    -- Concatenate/Merge can only be performed on managed tables
    ````

### 常见参数调优

* ````hive
  -- 修改引擎
  set hive.execution.engine=tez;
  -- 用于避免小文件的场景或者task特别多的场景，这类场景大多数执行时间都很短，因为hive调起mapreduce任务，JVM的启动过程会造成很大的开销，尤其是job有成千上万个task任务时，JVM重用可以使得JVM实例在同一个job中重新使用N次
  set mapred.job.reuse.jvm.num.tasks=10; --10为重用个数
  ````

* 数据倾斜

  - 表现：任务进度长时间维持在99%（或100%），查看任务监控页面，发现只有少量（1个或几个）reduce子任务未完成。因为其处理的数据量和其他reduce差异过大。单一reduce的记录数与平均记录数差异过大，通常可能达到3倍甚至更多。最长时长远大于平均时长。

  - 原因

    - key分布不均匀
    - 业务数据本身的特性
    - 建表时考虑不周
    - 某些sql语句本身就有数据倾斜
    - [![pAkiuTA.png](https://s21.ax1x.com/2024/08/26/pAkiuTA.png)](https://imgse.com/i/pAkiuTA)

  - 参数优化

    ````hive
    -- map端开启聚合
    set hive.map.aggr=true;
    -- 数据倾斜时生成两个MRJOB，第一个MR，先随机打散key，减少数据倾斜。第二个MR，再根据预处理的数据结果按照Group By Key分布到reduce中，最终完成
    set hive.groupby.skewindata=true;
    ````

### Map Join

* 适用于大表join小表。将小表放入内存。由于表的JOIN操作是在Map端且在内存进行的，所以其并不需要启动Reduce任务也就不需要经过shuffle阶段，从而能在一定程度上节省资源提高JOIN效率。

* 在Hive0.11前，需要指定mapjoin才能操作

* ````hive
  SELECT /*+ MAPJOIN(smalltable)*/  .key,value
  FROM smalltable JOIN bigtable ON smalltable.key = bigtable.key
  
  -- 在高版本中：如果想用上面这种语法
  set hive.auto.convert.join=false;-- (关闭自动MAPJOIN转换操作)
  set hive.ignore.mapjoin.hint=false;-- (不忽略MAPJOIN标记)
  -- 开启无条件转Map Join
  set hive.auto.convert.join.noconditionaltask=false;
  
  
  -- 建议不使用显示指定，调整自动mapjoin的一些参数就行
  ````

* 后面的版本，不用显示的指定mapjoin。hive优化器根据参与join的表的数据量大小，**自动触发**

* Hive在编译SQL语句阶段，起初所有的join操作均采用Common Join算法实现。

  之后在物理优化阶段：

  根据每个Common Join任务所需表的大小判断该Common Join任务是否能够转换为Map Join任务，若满足要求，便将Common Join任务自动转换为Map Join任务。

  如果在SQL的编译阶段不能确定是否能够转换的，（例如对子查询进行join操作）。

  针对这种情况，Hive会在编译阶段生成一个条件任务（Conditional Task）

* 自动触发的一些参数条件

  ````hive
  
  --启动Map Join自动转换
  set hive.auto.convert.join=true;
   
  -- 一个Common Join operator转为Map Join operator的判断条件,
  -- 若该Common Join相关的表中,存在n-1张表的已知大小总和<=该值,则生成一个Map Join计划,
  -- 此时可能存在多种n-1张表的组合均满足该条件,则hive会为每种满足条件的组合均生成一个Map Join计划,
  -- 同时还会保留原有的Common Join计划作为后备(back up)计划
  -- 实际运行时,优先执行Map Join计划，若不能执行成功，则启动Common Join后备计划。
  set hive.mapjoin.smalltable.filesize=250000;
   
  -- 开启无条件转Map Join
  set hive.auto.convert.join.noconditionaltask=true;
   
  -- 无条件转Map Join时的小表之和阈值,若一个Common Join operator相关的表中，
  -- 存在n-1张表的大小总和<=该值,此时hive便不会再为每种n-1张表的组合均生成Map Join计划
  -- 同时也不会保留Common Join作为后备计划。而是只生成一个最优的Map Join计划。
  set hive.auto.convert.join.noconditionaltask.size=10000000;
  ````

  



### 常见问题

* concat()函数和concat_ws()区别

  - 能否拼接INT类型

    ````hive
    select concat('',123,'xxx'); --可以拼接
    select concat_ws('',123,'xxx');-- 不可以拼接。must be "string or array<string>"
    
    ````

  - 拼接null值得结果

    ````hive
    select concat('',null,'xxx');--结果为null
    select concat_ws('',null,'xxx'); -- 会忽略null值
    ````

    

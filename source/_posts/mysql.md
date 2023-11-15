---
title: MySQL
date: 2021-04-25 14:23:14
updated:
tags:
- 数据库
categories: 
- 数据库
index_img: https://img.php.cn/upload/article/202009/15/2020091513341811712.jpg
banner_img: https://img.php.cn/upload/article/202009/15/2020091513341811712.jpg
---
# MySQL
## 架构

![Mysql架构](https://pic2.zhimg.com/9bb3acbba65f349299df27a93286ffb1_r.jpg)

* 连接层：最上层是一些客户端和连接服务。主要完成一些类似于连接处理，授权认证以及相关的安全方案。

* 服务层：

  | Management Serveices & Utilities | 系统管理和控制工具                                           |
  | -------------------------------- | ------------------------------------------------------------ |
  | SQL Interface:                   | SQL接口。接受用户的SQL命令，并且返回用户需要查询的结果。比如select from就是调用SQL Interface |
  | Parser                           | 解析器。 SQL命令传递到解析器的时候会被解析器验证和解析       |
  | Optimizer                        | 查询优化器。  SQL语句在查询之前会使用查询优化器对查询进行优化，比如有where条件时，优化器来决定先投影还是先过滤。 |
  | Cache和Buffer                    | 查询缓存。如果查询缓存有命中的查询结果，查询语句就可以直接去查询缓存中取数据。这个缓存机制是由一系列小缓存组成的。比如表缓存，记录缓存，key缓存，权限缓存等 |

* 引擎层：存储引擎层，存储引擎真正的负责了MySQL中数据的存储和提取，服务器通过API与存储引擎进行通信。不同的存储引擎具有不同的功能，这样我们可以根据自己的实际需求进行选取。

* 存储层：数据存储层，主要是将数据存储在运行与裸设备的文件系统之上，并完成与存储引擎的交互。

## 大致的查询流程

* MySQL客户端通过协议与MySQL服务器建立连接，发送查询语句，先检查缓存，如果命中直接返回结果。
* 语法解析器和预处理：首先MySQL通过关键字将SQL语句进行解析，并生成一颗对应的“解析树”。MySQL解析器使用MySQL语法规则验证和解析查询，预处理器则根据一些MySQL规则进一步检查解析树是否合法。
* 查询优化器当解析树被认为是合法的了，并且由优化器将其转化成执行计划。一条查询可以有很多种执行方式，最后都返回相同的结果。查询优化器会找出其中最好的执行计划。
* MySQL使用默认的B+树索引

## 存储引擎

* InnoDB:默认使用

  - InnoDB自增主键：InnoDB表如果没有指定主键，InnoDB会自动从表中选择合适的字段作为主键，如果没有合适的字段，InnoDB会创建一个不可见的，长度为6个字节的row_id。InnoDB维护了一个全局的dict_sys.row_id值，所有无主键的InnoDB表，每插入一行数据，都将当前的dict_sys.row_id值作为要插入数据的row_id，然后把dict_sys.row_id的值加1。

* MyISAM：自带系统表使用

* InnoDB的数据文件自己就是索引文件。MyISAM索引文件和数据文件是分离的，索引文件仅保存数据记录的地址。

* 由于InnoDB的数据文件自己要按主键汇集，因此InnoDB要求必须有主键（MyISAM能够没有），若是没有显示指定，则MySQL系统会自动选择一个能够唯一标识数据记录的列作为主键，若不存在这种列，则MySQL自动为InnoDB表生成一个隐含字段作为主键，这个字段长度为6个字节，类型为长整型。

  | 对比项         | MyISAM                                                   | InnoDB                                                       |
  | -------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
  | 外键           | 不支持                                                   | 支持                                                         |
  | 事务           | 不支持                                                   | 支持                                                         |
  | 行表锁         | 表锁，即使操作一条记录也会锁住整个表，不适合高并发的操作 | 行锁,操作时只锁某一行，不对其它行有影响，,<font color=red>适合高并发的操作</font> |
  | 缓存           | 只缓存索引，不缓存真实数据                               | 不仅缓存索引还要缓存真实数据，对内存要求较高，而且内存大小对性能有决定性的影响 |
  | 关注点         | 节省资源、消耗少、简单业务                               | 并发写、事务、更大资源                                       |
  | 默认安装       | Y                                                        | Y                                                            |
  | 默认使用       | N                                                        | Y                                                            |
  | 自带系统表使用 | Y                                                        | N                                                            |

## 索引

* 创建索引的方式

  ````sqlite
  --直接创建索引
  create index index_name on table (column(length))
  --修改表结构的方式添加索引
  alter table table_name add index index_name on (column(length))
  --创建表的时候同时创建索引
  CREATE TABLE `table` (
  	`id` int(11) NOT NULL AUTO_INCREMENT ,
  	`title` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
  	`content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
  	`time` int(10) NULL DEFAULT NULL ,
  	PRIMARY KEY (`id`),
  	INDEX index_name (title(length))
  )
  -- 删除索引
  ALTER TABLE table_name DROP INDEX index_name
  DROP INDEX index_name ON table_name
  ````

  

* Btree索引：

  [![4qdvuQ.png](https://z3.ax1x.com/2021/10/03/4qdvuQ.png)](https://imgtu.com/i/4qdvuQ)

  - 查找过程：
    - 如果要查找数据项29，那么首先会把磁盘块1由磁盘加载到内存，此时发生一次IO，在内存中用二分查找确定29在17和35之间，锁定磁盘块1的P2指针，内存时间因为非常短（相比磁盘的IO）可以忽略不计，通过磁盘块1的P2指针的磁盘地址把磁盘块3由磁盘加载到内存，发生第二次IO，29在26和30之间，锁定磁盘块3的P2指针，通过指针加载磁盘块8到内存，发生第三次IO，同时内存中做二分查找找到29，结束查询，总计三次IO。

* B+tree索引：MySQL默认索引

  [![4qwF3T.png](https://z3.ax1x.com/2021/10/03/4qwF3T.png)](https://imgtu.com/i/4qwF3T)

* b树和b+树的区别：

  - b树索引，关键字，记录是放在一起的。b+树的非叶子节点只有指向下一个节点的索引和关键字，记录只存放在叶子节点中。
  - b树中越靠近根节点的记录查的越快。而b+树每个记录的查找时间都是一样的，都需要从根节点走到叶子节点，并在叶子节点中查找关键字。
  - b+树的性能更好。因为b+树的非叶子节点不存放实际的数据，因此可以容纳的元素的更多，同样的数据下，树高比b树小，这样带来的好处是减少磁盘访问次数（例如，同样的数据量，b树三层，b+树两层，这样的话b+树就少一次IO操作，会快很多）。尽管B+树找到一个记录所需的比较次数要比b树多，但是一次磁盘访问的时间远远比内存比较的时间长。实际中，b+树的性能更好一些，而且b+树的叶子节点使用指针连接在一起，方便顺序遍历（例如查看一个目录下的所有文件，一个表中的所有记录等），这也是很多数据库和文件系统使用b+树的缘故。

* 为什么B+树更适合在实际应用中做操作系统的文件索引和数据库索引？

  - b+树的磁盘读写代价更低
  - b+树的查询效率更稳定。每个数据的查询效率相当。

> * C/S 架构
> * 服务器程序是 mysqld.exe
> * 客户端程序是 mysql.exe
> * cmd的打开方式：
````
mysql -uroot -p123456 -h127.0.0.1 -P3306
长选项：
mysql --host=主机地址 --port=端口 --user=用户名 --password=密码 默认数据库
````
## 基本语法
> * 查看服务器中的所有数据库
````
show databases;
````
> * 创建新的数据库
> * 数据库以目录的形式保存在服务器
安装目录/data目录下
````
show databases;
````
> * 切换当前工作数据库
mysql> use company;

> * 查看当前数据库中的所有表
show tables;
> * 跨库查看表
show tables from 其他库

> * 把.sql文件中数据导入数据库
source e:sql/company.sql;

> * 查看表中的所有数据
select * from employees;

> * 创建world数据库, 并导入 world.sql , 查看表中的数据
> * create database world;

> * use world;

> * source d:/mywork/mysql/world.sql;
> * 查看当前数据库 
select database();
> * 创建表
````
create table customer(
	id int,
	name varchar(20),
	age int,
	email varchar(50),
	gender enum('男', '女')
);
````
> * 丢弃表
drop table customer;

> * 查看表结构
describe customer;

> * desc 表名
> * 查看表的建表语句
show create table 表名;
> * 插入数据
> * 存储引擎 : InnoDB(支持事务, 外键等高级特性), MyISAM(不支持事务, 不支持外键)
> * show engines;显示支持的引擎
> * ``号专门用于包围数据库对象的名称(数据库, 表, 列, 主键, 外键, 索引, 函数, 存储过程, 触发器)
查询表中的所有数据
> * select * from 表名; from关键字可以省略
````
插入数据
insert into customer(
	id,
	name,
	age,
	email,
	gender 
) values (
	1,
	'张三',
	30,
	'zhang3@qq.com',
	'男'
);
````
> * 修改数据, 如果没有where 语句会导致修改所有记录
````
update customer set 
	age = 3,
	email = 'QQQ'
where 
	id = 1;
````
> * 删除数据, 如果没有where语句会导致删除所有记录
````
delete from customer
where id = 3;
````
> * 针对数据的操作.
````
C insert into  //Create 
R select 		//Retrieve
U update 		//Update
D delete 		//Delete
````
> * 查看表结构 :
desc 表名;


> * SQL注意 :
>> * SQL 语言大小写不敏感。 
>> * SQL 可以写在一行或者多行
>> * 关键字不能被缩写也不能分行
>> * 各子句一般要分行写。
>> * 使用缩进提高语句的可读性。
> * 给列起别名, 可以省略as关键字, 别名中如果有特殊符号, 可以使用""包围.
````
select 
	population as pop,
	name "国家 名称",
	code
from 
	country;
````
> * where 条件布尔(一个表达式，返回结果永远是一个布尔值)

> * 执行顺序SQL：先from, 再where 最后select 
````
SELECT 
	employee_id empId, 
	last_name name, 
	job_id job, 
	department_id deptId
FROM   
	employees
WHERE  
	department_id = 90 ;
	
-- 错误!! where中不可以使用列的别名, 因为此时虚表的列还没有生成好.
````

> * Between a and b 都包含
> * like 
>> * % 表示任意个任意字符
>> * _ 表示一个任意字符
````
查询姓名中第2个字母是o其他无所谓
SELECT last_name
FROM   employees
WHERE  last_name LIKE '_o%';
````
> * 只要有null参与比较运算, 结果一定是false
````
查询哪些国家没有首都
只要有null参与比较运算, 结果一定是false
--错误!!
select 
	name,
	continent,
	capital
from 
	country 
where 
	capital = null;
	
查询哪些国家没有首都
select 
	name,
	continent,
	capital
from 
	country 
where 
	capital is null;

查询哪些国家有首都
select 
	name,
	continent,
	capital
from 
	country 
where 
	capital is not null;
````
> * where 也支持算术运算, 结果为0表示假非0表示真
> * distinct 去重, 要求列真的有重复的
````
select
	distinct
		continent,
		name
from
	country;
````
> * order by  可以排序, 只是给结果集虚表排序
> * 默认是升充(asc)	
> * 降序必须指定(desc)
> * order by 可以使用列的别名.
> * order by  列1, 列2 先以列1排序, 再在相同的列1数据中, 再依据列2再微排.
````
SELECT 
	last_name, 
	department_id, 
	salary
FROM   
	employees
ORDER BY 
	department_id, 
	salary DESC;
````
> * 写SQL的步骤 : 
>> * (1) from 基表
>> * (2) where 过滤哪些行
>> * (3) select 选择哪些列
>> * (4) order by 以哪些列为排序依据. 

## 多表查询
### 表联接
````
表联接
select 
	* 
from 
	city2,
	country2;
笛卡尔集中的数据绝大多数都是垃圾, 必须使用行过滤.
````
> * 笛卡尔集中的数据绝大多数都是垃圾, 必须使用行过滤.
> * 解决列名冲突可以使用表名限定
````
--表名也可以起别名, 而且是如果多表联接, 最好起别名.
select 
	ci.name cityName,
	ci.population cityPop,
	co.name countryName,
	co.population countryPop,
	co.continent
from 
	city2 ci,
	country2 co 
where 
	ci.countrycode = co.code;
	
--一旦给表起了别名, 原名不可以使用, 必须使用别名. 原因是from最先执行, 它把原始表名变了.
select 
	city2.name cityName,
	city2.population cityPop,
	country2.name countryName,
	country2.population countryPop,
	country2.continent
from 
	city2 ci,
	country2 co 
where 
	city2.countrycode = country2.code;
````
> * 复习 :
>> * C/S 
>> * Server : mysqld.exe 
>> * Clinet : mysql.exe 
>> * 必须通过客户端才能使用服务器
>> * 需要提供IP, 端口, 用户名, 密码.
>> * mysql -h127.0.0.1 -P3306 -uroot -p123456
>> * mysql --host=127.0.0.1 --port=3306 --user=root --password=123456 默认数据库
>> * mysql --host=主机地址 --port=端口 --user=用户名 --password=密码 默认数据库
>> * 查看所有库
show databases;
>> * 切换成当前工作数据库
use 数据库;
>> * 查看库中的表
show tables;
>> * 跨库查看表
show tables from 其他库

>> * 查看表结构 
desc 表名;

>> * 查看表的建表语句
show create table 表名;

>> * 存储引擎 : InnoDB(支持事务, 外键等高级特性), MyISAM(不支持事务, 不支持外键)

>> * ``专门用于包围数据库对象的名称(数据库, 表, 列, 主键, 外键, 索引, 函数, 存储过程, 触发器)
>> * 查询表中的所有数据
select * from 表名; from关键字可以省略

>> * 相看当前数据库
select 
	database(), -- 函数
	now(), 
	version()

select
	100, -- 常量 
	'abc'
from
	dual;
	
>> * 使用用户变量
set @var1 = 100, @var2 = 'abc';

````
--SQL99标准, 用内联代替逗号联接.
select 
	ci.name cityName,
	ci.population cityPop,
	co.name countryName,
	co.population countryPop,
	co.continent
from 
	city2 ci
inner join 
	country2 co 
on
	ci.countrycode = co.code -- 联接条件
where  
	ci.population > 5000000 -- 普通过滤
	

-- where 和 on在内联时可以混用, 但是千万不要.
select 
	ci.name cityName,
	ci.population cityPop,
	co.name countryName,
	co.population countryPop,
	co.continent
from 
	city2 ci
join 
	country2 co 
on
	ci.countrycode = co.code -- 联接条件
where  
	ci.population > 5000000 -- 普通过滤
````
> * 注意：
>> * 内联接的逻辑是从笛尔集中取出来的是满足联接条件的记录. 有可能会导致某张表的数据不完整.
````
select 
	co.name countryName,
	ci.name capitalName,
	co.capital
from 
	country2 co 
left outer join -- 左外联接, 保证左表数据完整
	city2 ci 
on 
	co.capital = ci.id ;
	
select 
	co.name countryName,
	ci.name capitalName,
	co.capital
from 
	country2 co 
right outer join -- 左外联接, 保证左表数据完整
	city2 ci 
on 
	co.capital = ci.id ;
	
--外联时可以省略outer关键字	
select 
	co.name countryName,
	ci.name capitalName,
	co.capital
from 
	country2 co 
left join
	city2 ci 
on 
	co.capital = ci.id ;
````
### 函数
#### 单行函数
````
单行函数 -- 作用于结果集中的每一条记录的.
select 
	upper(name),
	now(),
	concat(continent, code2)
from 
	country;
	
查询国家表中的数据, 把国家名称,大洲, 国家代码 连接起来, 中间使用'=>'连接.
--concat(concat(concat(concat(name, '=>'), continent), '=>'), code)
select 
	concat(name, '=>', continent, '=>', code)
from 
	country;
````
#### 聚合函数
````
组函数（聚合函数） -- 作用于一组数据, 最终针对一组只有一个结果. 也称为统计处理
avg() 平均
max() 最大
min() 最小
count() 计数
sum()求和
````
> * 获取表中的记录数, 使用count(*)最好.
> * 如果有group by , 必须让分组依据的列放在select中.
````
select 
	-- name, 代表个体信息的列
	continent,
	max(population)
from 
	country 
group by 
	continent;
````
> * 对分组的虚表进行过滤, 必须使用having
> * having的执行晚于select, 所以可以使用列的别名
````
select 
	GovernmentForm,
	count(*) ct
from 
	country
group by 
	GovernmentForm
having
	ct > 10
order by 
	ct;
````
sql语句一般的执行顺序：
1. from 		确定基表
2. join 		如果一张基表不够, 再联接其他表
3. on 			如果有联接表 必须要有on
4. where 		过滤总基表中的行
5. group by 	分组, 分组依据的列.
6. select 		把分组依据的列放在select后, 再考虑要选择哪些列, 及进行哪些函数调用....
7. having 		进一步把分组后的虚表行过滤
8. order by 	最终表的一个排序显示.

### 子查询
> * 子查询 : 通常需要多步执行的简单查询

> * 针对表中的数据进行的操作, 这样的语言称DML(数据操纵语句)
>> * select R
>> * update U 
>> * delete D 
>> * insert C

> * 针对数据库中的对象的操作, 这样的语言称DDL(数据定义语言)
> * 数据库 
> * 表
> * 列 
> * 约束 
> * 索引 
> * 预编译
> * 函数
> * 存储过程 
> * 触发器
> * 事件.....
>
````
创建数据库 
create database 数据库名 charset 字符集;

create database if not exists school charset utf8;

修改数据库 
alter database school charset gbk;

丢弃数据库. 数据库中的所有内容全部丢弃. 慎重!!!!
drop database if exists school;

常用数据类型
int 			4字节整数
bigint			8字节整数
char(长度)		定长字符串
varchar(字符数) // 最多65535字节
double			8字节双精度浮点
decimal			定点数
date 			日期
datetime		日期时间
longtext 		长文本

create table if not exists teacher(
	id int auto_increment,
	name varchar(20),
	age int,
	phone varchar(20),
	address varchar(100),
	gender enum('男', '女') default '男',
	primary key(id)
) engine innodb charset gbk;

create table if not exists classes(
	id int auto_increment,
	name varchar(30),
	student_count int,
	room char(3),
	master int, -- 班主任
	begindate date,
	primary key(id)
);
````
> * 子查询题目例子
````
5 查询所有国家的首都和使用率最高的官方语言(选做)
select 
	co.name,
	ci.name,
	cl3.language,
	cl3.percentage
from 
	country co 
left join 
	city ci 
on 
	co.capital = ci.id 
left join 
	(select 
		cl.countrycode,
		cl.language,
		cl.percentage,
		cl.isofficial
	from 
		countrylanguage cl 
	join  
		(select countrycode, max(Percentage) maxPer from countrylanguage where isofficial = 'T' group by countrycode) cl2
	on 
			cl.countrycode = cl2.countrycode 
		and 
			cl.percentage = cl2.maxPer
	where 
		cl.isofficial = 'T'
	) cl3
on 
	co.code = cl3.countrycode 
order by 
	cl3.percentage;
````
````
创建数据库 
create database if not exists 数据库名 charset utf8;

修改数据库 只能修改字符集
alter database 数据库名 charset 新字符集;

丢弃数据库
drop database if exists 数据加名;

查看库或表
show create database(table) 数据库名或表名

SQL语言分类
	1) DML 数据操纵语言, 主要处理数据
		insert select update delete 
		
	2) DDL 数据定义语言, 主要处理数据库对象
		create show alter drop 
		
	3) DCL 数据控制语句, 主要用于控制事务
		commit rollback

````
### 创建表
> * 全新方式创建表
````
1) 全新方式建表
create table if not exists 表名(
	列1 数据类型1(长度) 其他选项,
	列2 数据类型2(长度) 其他选项,
	......,
	primary key(列) -- 表级主键
) engine 数据库引擎 charset 字符集;

数据库引擎 : 
	InnoDB : 缺省引擎, 支持事务, 外键等高级特性, 速度慢
	MyIsam : 速度快, 早期的缺省引擎, 不支持事务,外键等高级特性

其他选项 : auto_increment, default 缺省值, not null, unique.
````
> * 基于子查询, 可以复制数据，不能复制各种约束（key）...
```` 
create table if not exists 表名 
子查询 

create table country3 select * from world.country where continent = 'asia';

create table country4 select * from world.country;
````
> * 完全复制表结构，不能复制数据
````
create table if not exists 表名 like 已有表名
````
### 修改表结构
````
表结构的修改
alter table 表名 
--子句

添加新列
alter table 表名 
add 新列名 数据类型 其他选项;

alter table teacher 
add gender enum('男', '女') default '男';

修改列
alter table 表名 
modify 列名 新数据类型 新其他选项;

修改列名
alter table 表名 
change 老列名 新列名 新数据类型 新其他选项;
丢弃一个列, 此列对应的所有数据都会删除
alter table 表名
drop column 列名 

alter table teacher
drop column address;
丢弃表 
drop table if exists 表名1, 表名2, ....;

清空表数据
truncate table 表名; -- 它是一个DDL语句, 一旦清除,就不能回滚, 效率高.

delete from 表名; -- 它是一个DML语句, 意味着是可以回滚的. 效率低.

修改表名
alter table 表名
rename to 新表名
````
### 插入数据的方式
1. 全新方式插入
````
insert into 表名 (
	列1,
	列2,
	列3,
	.....
) values (
	值1,
	值2,
	值3,
	....
)
````
2. 使用子查询插入
````
insert into students(
	name,
	age,
	mobile,
	gender,
	address
) select 
	name,
	age, 
	mobile,
	gender,
	'北京'
from 
	teachers 
where 
	id in (2, 3);
-- 克隆表
create table 新表 like 旧表;
insert into 新表 select * from 旧表 
克隆城市表到当前库下新成中国城市表 (chinaCity)
create table if not exists chinaCity like world.city; 
insert into chinacity select * from world.city where countrycode = 'chn';
````
3.  插入一条数据 insert into 表名 set 数据
````
insert into 
	teachers 
set 
	name = '丁老师',
	age = 25,
	mobile = '123234234';
修改数据 
update 表名 set 
	列1 = 值1,
	列2 = 值2,
	列3 = 值3,
	....
where 
	行过滤
	
update teachers set 
	age = 40,
	mobile = '135342342'
where 
	id = 1;
	
删除数据 
delete from 表名 
where 行过滤

delete from teachers 
where id > 3
````
### 数据库事物
> * 定义：让数据从一种状态到另一种状态
> * ACID特性
> * 让一组逻辑操作单元当成一个单个的命令来执行.
>> * A 原子性 : 不可分割 
>> * C 一致性 : 数据前后是一致
>> * I 独立性 : 事务间, (独立性有等级)
>> * D 持久性 : 事务一旦提交, 数据持久化.
````
设置提交状态：SET AUTOCOMMIT = FALSE;
或者显式的执行 start transaction
            或 begin
			
以第一个 DML 语句的执行作为开始

以下面的其中之一作为结束:
COMMIT 或 ROLLBACK 语句
DDL 语句（自动提交）
用户会话正常结束, 提交
系统异常终止      回滚

SET AUTOCOMMIT = true;

set autocommit = false;

用一个客户端在事务中删除表数据, 另一个客户端查询??

预编译 : 提前把SQL编译成可执行的, 在执行时只需要调用它即可.
prepare 预编译名 from 'SQL'; 

prepare p1 from 'select * from teachers'

执行预编译 
execute p1; 

丢弃预编译
drop prepare p1;
````
````
prepare p2 
from 
	'insert into teachers(
		name, 
		age, 
		mobile
	) values (
		?,
		?,
		?
	)';
	
prepare p3 from 
'delete from teachers 
 where id = ?';

在执行时预编译时, 代替?的实参必须要用用户变量

set @变量名 = 值, @变量名2 = 值2;

execute 预编译 using @变量名, @变量名2;

? 只能代替值的部分, 表名, 列名绝不可以.
下面是错误!!
prepare p4 from 
'insert into teachers(
	?, 
	?, 
	?
) values (
	?,
	?,
	?
)';

在SQL中要想使用', 必须再加一个', 起到转义的作用
prepare p2 from 
'insert into teachers(
	name, 
	age, 
	mobile,
	gender
) values (
	?,
	?,
	?,
	?
)';
````
> * 有以下六种约束:
>> * NOT NULL 非空约束，规定某个字段不能为空, 必须列级约束 
>> * UNIQUE  唯一约束，规定某个字段在整个表中是唯一的
>> * PRIMARY KEY  主键(非空且唯一)
>> * FOREIGN KEY  外键
>> * DEFAULT  默认值, 必须是列级
>> * check
````

create table test(
	id int auto_increment,
	name varchar(20),
	phone varchar(20) not null, -- 必须列级约束
	unique(name), -- 可以表级约束
	primary key(id)
);

insert into test(
	name,
	phone
) values (
	'aaa',
	'234234'
);

alter table test 
drop key name; -- 丢弃唯一键约束

create table test2(
	id int auto_increment,
	name varchar(20),
	phone varchar(20) not null, -- 必须列级约束
	constraint myunique unique(name, phone), -- 可以表级约束, 联合键
	primary key(id)
);

````
### 外键
> * 外键 : 让一个表中的记录的值要引用到另一张表中的数据...
> * 一旦有了外键, 子表中插入数据必须要引用到真实的父表中数据
> * 一旦父表中的记录被子表引用, 当删除父表中的相关记录时, 不允许删除.
````
foreign key(本表的外键列) references 父表(父表主键)

drop table if exists classes;
create table if not exists classes(
	id int auto_increment,
	name varchar(30),
	student_count int,
	room char(3),
	master int, 
	begindate date,
	primary key(id),
	foreign key(master) references teachers(id)
);
````
> * 丢弃外键, 必须要知道外键名.
````
alter table classes 
drop foreign key classes_ibfk_1;
````
> * 添加外键
> * on delete do nothing, 是默认选项, 在删除父表被引用的记录时不允许
> * on delete cascade 级联删除, 当删除父表中的相关记录时, 子表中引用此记录的所有记录也会被删除.
> * on delete set null 级联置空.当删除父表中的相关记录时, 子表中引用此记录的所有记录会被置为空.
#### limit
> * limit n, 把结果集截断成n条记录.

> * limit m, n 把结果集中的m条略过, 再截断成n条记录
>
> * limit子句必须放在整个查询语句的最后！
>
> * offset n 表示去掉n个值
>
> * 一般用法：
>
>   ````sql
>   SELECT * FROM employees
>   ORDER BY hire_date DESC      -- 倒序
>   LIMIT 1 offset 2;       -- 去掉排名倒数第一第二的时间，取倒数第三;   
>   
>   ````
>
>   


## 总结：
> * 重点：DML数据操纵语言，主要就是查询
> * 标准SQL
>> * select 
>> * from 
>> * left join 
>> * on 
>> * where 
>> * group by 
>> * having 
>> * order by
> * 注意点
>> * 注意多表连接的内联，外联 
>> * 函数的使用，where中不能使用
>> * 别名的使用，从group by开始可以使用select中的别名了

## SQL优化

* 先找到运行慢的SQL

  ````sql
  -- 查看慢SQL日志是否可用
  show variables like 'log_slow_queries';
  
  -- 查看执行慢于多少秒的SQL会记录到日志文件中
  show variables like 'long_query_time';
  
  -- 查看慢SQL存在的位置
  show variables like 'slow_query_log_file';
  
  ````

  

### 字段

* 尽量使用 `TINYINT` 、 `SMALLINT` 、 `MEDIUM_INT` 作为整数类型而非 `INT` ，如果非负则加上 `UNSIGNED`
* varchar的长度只分配真正需要的空间
* 使用枚举或整数代替字符串类型
* 尽量使用TIMESTAMP而非DATETIME
* 单表不要有太多字段，建议在20以内
* 避免使用NULL字段，很难查询优化且占用额外索引空间
* 用整型来存IP

### 索引

* 索引并不是越多越好，要根据查询有针对性地创建，<font color=red>考虑在where和order by命令上涉及地列建立索引</font>，根据explain来查看是否用了索引还是全表扫描。
* 应尽量避免在where子句中对字段进行NULL值判断，否则将导致引擎放弃使用索引而进行全表扫描。
* 值分布很稀少地字段不适合建索引
* 字符串字段只建前缀索引
* 字符字段最好不要做主键
* 不用外键，由程序保证约束
* 尽量不用 `UNIQUE` ，由程序保证约束
* 使用多列索引时主意顺序和查询条件保持一致，同时删除不必要的单列索引



### 查询SQL

* 可通过开启慢查询日志来找出较慢的SQL
* 不做列运算
* sql语句尽可能简单，一条SQL只能在一个cpu运算，大语句拆小语句，减少锁时间；一条大SQL可以堵死整个库。
* 不用select *，要尽量避免使用 select *，而是查询需要的字段，这样可以提升速度，以及减少网络传输的带宽压力
* <font color=red>or改写成in</font>,or的效率是n级别，in的效率是log(n)级别，in的个数建议在200以内
* 不用函数和触发器，在应用程序实现
* 少用join
* 使用同类型进行比较
* <font color=red>尽量避免在where子句中使用!=或<>操作符</font>，否则引擎将放弃使用索引而进行全表扫描。
* 对于连续型数值，使用BETWEEN 不用 in
* 列表数据不要拿全表，要使用limit来分页，每页数量也不要太大
* 小表驱动大表



### 系统参数调优

* wait_timeout：数据库连接闲置时间，闲置连接会占用内存资源。可以从默认的8小时减到半小时
* max_user_connection: 最大连接数，默认为0无上限，最好设一个合理上限
* back_log：back_log值指出在MySQL暂时停止回答新请求之前的短时间内多少个请求可以被存在堆栈中。也就是说，如果MySql的连接数据达到max_connections时，新来的请求将会被存在堆栈中，以等待某一连接释放资源，该堆栈的数量即back_log，如果等待连接的数量超过back_log，将不被授予连接资源。可以从默认的50升至500
* thread_concurrency：并发线程数，设为CPU核数的两倍



## 存储过程

### 概述

* 如果在实现用户的某些需求时，需要编写一组复杂的SQL语句才能实现的时候，那么我们就可以将这组复杂的SQL语句集提前编写在数据库中，由JDBC调用来执行这组SQL语句。把编写在数据库中的SQL语句集称为存储过程。
* 存储过程：(procedure) 是事先经过编译并存储在数据库中的一段SQL语句的集合。调用存储过程可以简化应用开发人员的很多工作，减少数据在数据库和应用服务器之间的传输，对于提高数据处理的效率是很有好处的。<font color=red>**存储过程就是数据库SQL语言层面的代码封装与重用**</font>
* 存储过程就类似于Java中的方法，需要先定义，使用时需要调用。存储过程可以定义参数，参数分为IN，OUT，INOUT三种类型
  - IN类型的参数表示接受调用者传入的数据
  - OUT类型的参数表示向调用者返回数据
  - INOUT类型的参数既可以接受调用者传入的参数，也可以向调用者返回数据

### 优缺点

* 优点

  - 简化复杂操作，简化对变动的管理
  - **通常存储过程有助于提高应用程序的性能**。当创建的存储过程被编译之后，就存储在数据库中。
  - 存储过程有助于减少应用程序和数据库服务器之间的流量。
  - 可重用，透明，安全的。

* 缺点

  - 如果大量使用存储过程，那么使用这些存储过程的每个连接的内存使用量将大大增加。此外，如果在存储过程中过度使用大量的逻辑操作，那么CPU的使用率也在增加，因为MySQL数据库最初的设计就侧重于高效的查询，而不是逻辑运算。

  - 开发维护，调试代码困难，**对数据库依赖程度高，移植性较差**。

    ````sql
    DELIMITER $$
    
    CREATE
        /*[DEFINER = { user | CURRENT_USER }]*/
        PROCEDURE 数据库名.存储过程名([in变量名 类型,out 参数 2，...])
        /*LANGUAGE SQL
        | [NOT] DETERMINISTIC
        | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
        | SQL SECURITY { DEFINER | INVOKER }
        | COMMENT 'string'*/
    	BEGIN
    		[DECLARE 变量名 类型 [DEFAULT 值];]
    		存储过程的语句块;
    	END$$
    
    DELIMITER ;
    
    ````

  - in代表输入参数（默认情况下为in参数），表示该参数的值必须由调用程序指定。

  - out代表输出参数，表示该参数的值经过存储过程计算后，将out参数的计算结果返回给调用程序

  - inout代表即时输入参数，又是输出参数，表示该参数的值既可以由调用程序制定，又可以将inout参数的计算结果返回给调用程序。

* 存储过程中的语句必须包含在BEGIN和END之间

* DELIMITER是分割符，默认情况下DELIMITER是分号，遇到分号就执行。

* DECLARE中用来声明变量，变量默认赋值使用DEFAULT，语句块中改变变量值，使用SET变量=值

* 例子

  ````sql
  DELIMITER $$
  
  CREATE
      PROCEDURE `demo`.`demo1`()
  	-- 存储过程体
  	BEGIN
  		-- DECLARE声明 用来声明变量的
  		DECLARE de_name VARCHAR(10) DEFAULT '';
  		
  		SET de_name = "jim";
  		
  		-- 测试输出语句（不同的数据库，测试语句都不太一样。
  		SELECT de_name;
  	END$$
  
  DELIMITER ;
  -- 调用
  CALL demo1();
  ````

  ````sql
  DELIMITER $$
  
  CREATE
      PROCEDURE `demo`.`demo2`(IN s_sex CHAR(1),OUT s_count INT)
  	-- 存储过程体
  	BEGIN
  		-- 把SQL中查询的结果通过INTO赋给变量
  		SELECT COUNT(*) INTO s_count FROM student WHERE sex= s_sex;
  		SELECT s_count;
  		
  	END$$
  DELIMITER ;
  -- 调用
  -- @s_count表示测试出输出的参数
  CALL demo2 ('男',@s_count);
  
  ````

  ````sql
  -- if判断
  DELIMITER $$
  CREATE
      PROCEDURE `demo`.`demo3`(IN `day` INT)
  	-- 存储过程体
  	BEGIN
  		IF `day` = 0 THEN
  		SELECT '星期天';
  		ELSEIF `day` = 1 THEN
  		SELECT '星期一';
  		ELSEIF `day` = 2 THEN
  		SELECT '星期二';
  		ELSE
  		SELECT '无效日期';
  		END IF;
  		
  	END$$
  DELIMITER ;
  -- case when判断
  DELIMITER $$
  CREATE 
      PROCEDURE demo5(IN num INT)
  	BEGIN
  		CASE num  -- 条件开始
  		WHEN 1 THEN 
  			SELECT '输入为1';
  		WHEN 0 THEN 
  			SELECT '输入为0';
  		ELSE 
  		SELECT '不是1也不是0';
  		END CASE; -- 条件结束
  	END$$
  DELIMITER;
  
  ````

  ````sql
  -- while循环
  DELIMITER $$
  CREATE 
      PROCEDURE demo6(IN num INT,OUT SUM INT)
  	BEGIN
  	     SET SUM = 0;
  	     WHILE num<10 DO -- 循环开始
  	         SET num = num+1;
  	         SET SUM = SUM+num;
  	         END WHILE; -- 循环结束
  	END$$
  DELIMITER;
  
  -- REPEAT...UNTIL语句的语法和Java中的do...while语句类似，都是先执行循环操作，再判断条件，区别就是REPEAT表达式值为false时才执行循环操作，直到表达式值为true停止
  -- 创建过程
  DELIMITER $$
  CREATE 
      PROCEDURE demo7(IN num INT,OUT SUM INT)
  	BEGIN
  	     SET SUM = 0;
  	     REPEAT-- 循环开始
  		SET num = num+1;
  		SET SUM = SUM+num ;
  		UNTIL num>=10
  		END REPEAT; -- 循环结束
  	END$$
  DELIMITER;
  
  -- LOOP循环语句，用来重复执行某些语句
  -- 执行过程中可使用LEAVE语句或者ITERATE来跳出循环，也可以嵌套IF等判断语句
  -- LEAVE语句效果对于Java中的break,用来终止循环
  -- ITERATE语句效果相当于Java中的Continue，用来跳过此次循环。进入下一次循环，且ITERATE之下的语句将不在进行。
  DELIMITER $$
  CREATE 
      PROCEDURE demo8(IN num INT,OUT SUM INT)
  	BEGIN
  	     SET SUM = 0;
  	     demo_sum:LOOP-- 循环开始
  		SET num = num+1;
  		IF num > 10 THEN
  		    LEAVE demo_sum; -- 结束此次循环
  		ELSEIF num < 9 THEN
  		    ITERATE demo_sum; -- 跳过此次循环
  		END IF;
  		
  		SET SUM = SUM+num;
  		END LOOP demo_sum; -- 循环结束
  	END$$
  DELIMITER;
  
  ````

  * 使用存储过程插入信息

    ````sql
    DELIMITER $$
    CREATE 
        PROCEDURE demo9(IN s_student VARCHAR(10),IN s_sex CHAR(1),OUT s_result VARCHAR(20))
    	BEGIN
    	   -- 声明一个变量 用来决定这个名字是否已经存在
    	   DECLARE s_count INT DEFAULT 0;
    	   -- 验证这么名字是否已经存在
    	   SELECT COUNT(*) INTO s_count FROM student WHERE `name` = s_student;	
    	   IF s_count = 0 THEN
    	        INSERT INTO student (`name`, sex) VALUES(s_student, s_sex);
    		SET s_result = '数据添加成功';
    	   ELSE
                    SET s_result = '名字已存在，不能添加';
                    SELECT s_result;
    	   END IF;
    	END$$
    DELIMITER;
    -- 调用
    CALL demo9("Jim","女",@s_result);
    
    ````

* ````sql
  SHOW PROCEDURE STATUS -- 显示存储过程
  SHOW PROCEDURE STATUS WHERE db = 'db名字' AND NAME = 'name名字';-- 显示特定数据库的存储过程
  SHOW PROCEDURE STATUS WHERE NAME LIKE '%mo%';-- 显示特定模式的存储过程
  SHOW CREATE PROCEDURE 存储过程名;-- 显示存储过程源码
  DROP PROCEDURE 存储过程名;-- 删除存储过程
  ````

## MySQL函数

### 函数定义

* MySQL的函数定义语法如下：

  ````sql
      CREATE  
          [DEFINER = { user | CURRENT_USER }]
          FUNCTION functionName ( varName varType [, ... ] )
          RETURNS returnVarType
          [characteristic ...] 
          routine_body
  ````

* 参数含义：

  - functionName：函数名，同MySQL内置函数一样，大小写不敏感
  - varName：形参类型，其与varName配对使用。形参数量不限
  - returnVarType：返回值类型。函数必须有且只能有一个返回值
  - characteristic：函数特性
  - routine_body：函数体。函数体中必须含有return 语句，当函数体为复合结构时，需要使用begin....end语句

* ````sql
      create
          function myfun_getMax(num1 int, num2 int)
          returns int        
      begin
          declare res int;
          if(num1 > num2) then
              set res = num1;
          elseif (num1 < num2) then
              set res = num2;
          else
              set res = num1;
          end if;
          return res;
      end;
  ````

### 表格值函数

* 内联表格值函数:返回一个表格

  ````sql
  create function tabcmess(@title VARCHAR(10)) RETURNS TABLE as 
  return (select title,des from product where title like '%'+@title+'%')
  ````

* 多句表格值函数

  ````
  ````

  

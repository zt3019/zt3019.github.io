---
title: sql_userful_function
date: 2022-06-13 15:39:06
hide: true
tags:
- SQL
categories:
- 数据库
index_img: https://upload.shejihz.com/2019/04/5eee1c371fc6928560fa4113c28ab574.jpg
banner_img: https://upload.shejihz.com/2019/04/5eee1c371fc6928560fa4113c28ab574.jpg
---

# 常用的SQL函数

## 常见的MySQL关系型数据库

* date_format(date,format)

  - **date**参数是合法的日期，**format**规定日期/时间的输出格式。

  - ````mysql
    select date_format('2021-10-01 10:00:00','%Y-%m-%d %h:%i:%s')
    ````

  - | %a   | 缩写星期名                                     |
    | ---- | ---------------------------------------------- |
    | %b   | 缩写月名                                       |
    | %c   | 月，数值                                       |
    | %D   | 带有英文前缀的月中的天                         |
    | %d   | 月的天，数值(00-31)                            |
    | %e   | 月的天，数值(0-31)                             |
    | %f   | 微秒                                           |
    | %H   | 小时 (00-23)                                   |
    | %h   | 小时 (01-12)                                   |
    | %I   | 小时 (01-12)                                   |
    | %i   | 分钟，数值(00-59)                              |
    | %j   | 年的天 (001-366)                               |
    | %k   | 小时 (0-23)                                    |
    | %l   | 小时 (1-12)                                    |
    | %M   | 月名                                           |
    | %m   | 月，数值(00-12)                                |
    | %p   | AM 或 PM                                       |
    | %r   | 时间，12-小时（hh:mm:ss AM 或 PM）             |
    | %S   | 秒(00-59)                                      |
    | %s   | 秒(00-59)                                      |
    | %T   | 时间, 24-小时 (hh:mm:ss)                       |
    | %U   | 周 (00-53) 星期日是一周的第一天                |
    | %u   | 周 (00-53) 星期一是一周的第一天                |
    | %V   | 周 (01-53) 星期日是一周的第一天，与 %X 使用    |
    | %v   | 周 (01-53) 星期一是一周的第一天，与 %x 使用    |
    | %W   | 星期名                                         |
    | %w   | 周的天 （0=星期日, 6=星期六）                  |
    | %X   | 年，其中的星期日是周的第一天，4 位，与 %V 使用 |
    | %x   | 年，其中的星期一是周的第一天，4 位，与 %v 使用 |
    | %Y   | 年，4 位                                       |
    | %y   | 年，2 位                                       |

* concat(str1,str2,...)    ，concat_ws(seperator,string1,string2)

  - MySQL `CONCAT()`函数需要一个或多个字符串参数，并将它们连接成一个字符串。`CONCAT()`函数需要至少一个参数，否则会引起错误。 
  - MySQL提供了一种特殊形式的`CONCAT()`函数：`CONCAT_WS()`函数。`CONCAT_WS()`函数将两个或多个字符串值与预定义的分隔符相连接。

* timediff(dt1,dt2)

  - `TIMEDIFF`函数接受两个必须为相同类型的参数，即`TIME`或`DATETIME`。 `TIMEDIFF`函数返回表示为时间值的`dt1 - dt2`的结果。
  - `TIMEDIFF`函数的结果是一个`TIME`值，范围是从`-838:59:59`到`838:59:59`。

* TIMESTAMPDIFF(unit,begin,end); 

  - `TIMESTAMPDIFF`函数返回`end-begin`的结果，其中`begin`和`end`是[DATE](http://www.yiibai.com/mysql/date.html)或[DATETIME](http://www.yiibai.com/mysql/datetime.html)表达式。
  - `TIMESTAMPDIFF`函数允许其参数具有混合类型，例如，`begin`是`DATE`值，`end`可以是`DATETIME`值。 如果使用`DATE`值，则`TIMESTAMPDIFF`函数将其视为时间部分为`“00:00:00”`的`DATETIME`值。
  - `unit`参数是确定(`end-begin`)的结果的单位，表示为整数。 以下是有效单位：
    - MICROSECOND
    - SECOND
    - MINUTE
    - HOUR
    - DAY
    - WEEK
    - MONTH
    - QUARTER
    - YEAR

* 数据类型转换函数

  - cast('2022-01-01 00:00:00' as datetime)
  - convert('2021-01-01 00:00:00',datetime)

* date_sub(date,INTERVAL expr type) 

  - 从日期减去指定的时间间隔
  - *date* 参数是合法的日期表达式。*expr* 参数是您希望添加的时间间隔。

* DATE_ADD(date,INTERVAL expr type)

  - 从日期加上指定的时间间隔

  - *date* 参数是合法的日期表达式。*expr* 参数是您希望添加的时间间隔。

  - | MICROSECOND        |
    | ------------------ |
    | SECOND             |
    | MINUTE             |
    | HOUR               |
    | DAY                |
    | WEEK               |
    | MONTH              |
    | QUARTER            |
    | YEAR               |
    | SECOND_MICROSECOND |
    | MINUTE_MICROSECOND |
    | MINUTE_SECOND      |
    | HOUR_MICROSECOND   |
    | HOUR_SECOND        |
    | HOUR_MINUTE        |
    | DAY_MICROSECOND    |
    | DAY_SECOND         |
    | DAY_MINUTE         |
    | DAY_HOUR           |
    | YEAR_MONTH         |

* round(x,d)

  - x指要处理的数，d是指保留几位小数

* ifnull(expression_1,expression_2)

  - MySQL IFNULL函数是MySQL控制流函数之一，它接受两个参数，如果不是NULL，则返回第一个参数。 否则，IFNULL函数返回第二个参数。

* year(datetime)函数 取时间的年份

* month(datetime) 取月份

* dayofmonth() 取一个月的第几天

* if(expr1,expr2,expr3)函数

  - if() 类似与三元表达式，如果expr1的值为true，则返回expr2的值，如果expr1的值为false,则返回expr3的值

* substring_index(“待截取有用部分的字符串”，“截取数据依据的字符”，截取字符的位置N)

* substr(string,start,length)

  - string：表示要截取的字符串
  - start：规定字符串从何处开始。（1表示第一个下标）
  - length：可选

* 插入数据

  - INSERT INTO t1(field1,field2) VALUE(v001,v002)
  - INSERT INTO t1(field1,field2) VALUES(v101,v102),(v201,v202),(v301,v302),(v401,v402);　**在插入批量数据时方式2优于方式1**
  - INSERT INTO t2(field1,field2) SELECT col1,col2 FROM t1 WHERE
  - INSERT INTO t2 SELECT id, name, address FROM t1

* LENGTH( 字段名) 

  - 返回字段中值的长度
  - mysql5.0版本以上：
    - UTF-8：一个汉字等于3个字节，英文是一个字节
    - GBK：一个汉字等于2个字节，英文是一个字节

* REPLACE(str,old_string,new_string);

  - 使用新的字符串替换表的列中的字符串

* curdate()  取时间 %Y-%m-%d

* curtime()  取时间 %H:%i%s

* | NOW()               | CURDATE()  | CURTIME() |
  | :------------------ | :--------- | :-------- |
  | 2008-12-29 16:25:46 | 2008-12-29 | 16:25:46  |

* with t as () 语句其实就是把一大堆重复用到的sql语句放在with as里面，取一个别名，后面的查询就可以用它，这样对于大批量的sql语句起到一个优化的作用，而且清楚明了

  ````sql
  with e as (select * from scott.emp e where e.empno=4)
  select * from e;
  
  
  with
  e as (select * from scott.emp),
  d as (select * from scott.dept)
  select * from e, d where e.deptno = d.deptno;
  ````

  

---
title: Hive_WindowFunction
date: 2022-02-25 15:19:28
tags:
- Hive
- 窗口函数
categories:
- 大数据
- Hive
index_img: https://pic1.zhimg.com/v2-06649c39990e7b781a5563b925812b71_r.jpg?source=172ae18b
banner_img: https://pic1.zhimg.com/v2-06649c39990e7b781a5563b925812b71_r.jpg?source=172ae18b
---

# 窗口函数

## partition by 子句

* 窗口函数

  - 窗口函数，也叫OLAP函数（Online Anallytical Processing,联机分析处理），可以对数据库进行实时分析处理。

  - 基本语法：

    ````
    <窗口函数> over (partition by <用于分组的列名>
                    order by <用于排序的列名>)
    ````

* 语法中<窗口函数>的位置，可以放下以下两种函数：

  - 专用窗口函数，包括后面要讲到的rank,dense_rank,row-number等专用窗口函数

  - 聚合函数，sum,avg,count,max,min等

  - ````
    select *,
       rank() over (partition by 班级
                     order by 成绩 desc) as ranking
    from 班级表
    ````

  ![](https://pic2.zhimg.com/v2-451c70aa24c68aa7142693fd27c85605_r.jpg)

* 简单来说，窗口函数具有以下功能
  
  - 同时具有分组和排序的功能
  - 不减少原表的行数

## window子句

* 如果只使用partition by 子句，未指定order by 的话，我们的聚合就是分组内的聚合

* 使用了order by子句，未使用window子句的情况下，默认从起点到当前行。

* 当同一个select查询中存在多个窗口函数时，他们互相之间是没有影响的。每个窗口函数应用自己的规则。

* window子句

  - PRECEDING：往前

  - FOLLOWING：往后

  - CURRENT ROW：往前行

  - UNBOUNDED：起点

  - UNBOUNDED PRECEDING : 表示从前面的起点

  - UNBOUNDED FOLLOWING ：表示到后面的终点

  - ````sqlite
    select name,orderdate,cost,
    sum(cost) over() as sample1,--所有行相加
    sum(cost) over(partition by name) as sample2,--按name分组，组内数据相加
    sum(cost) over(partition by name order by orderdate) as sample3,--按name分组，组内数据累加
    sum(cost) over(partition by name order by orderdate rows between UNBOUNDED PRECEDING and current row )  as sample4 ,--和sample3一样,由起点到当前行的聚合
    sum(cost) over(partition by name order by orderdate rows between 1 PRECEDING   and current row) as sample5, --当前行和前面一行做聚合
    sum(cost) over(partition by name order by orderdate rows between 1 PRECEDING   AND 1 FOLLOWING  ) as sample6,--当前行和前边一行及后面一行
    sum(cost) over(partition by name order by orderdate rows between current row and UNBOUNDED FOLLOWING ) as sample7 --当前行及后面所有行
    from t_window;
    ````

````
name    orderdate   cost    sample1 sample2 sample3 sample4 sample5 sample6 sample7
jack    2015-01-01  10  661 176 10  10  10  56  176
jack    2015-01-05  46  661 176 56  56  56  111 166
jack    2015-01-08  55  661 176 111 111 101 124 120
jack    2015-02-03  23  661 176 134 134 78  120 65
jack    2015-04-06  42  661 176 176 176 65  65  42
mart    2015-04-08  62  661 299 62  62  62  130 299
mart    2015-04-09  68  661 299 130 130 130 205 237
mart    2015-04-11  75  661 299 205 205 143 237 169
mart    2015-04-13  94  661 299 299 299 169 169 94
neil    2015-05-10  12  661 92  12  12  12  92  92
neil    2015-06-12  80  661 92  92  92  92  92  80
tony    2015-01-02  15  661 94  15  15  15  44  94
tony    2015-01-04  29  661 94  44  44  44  94  79
tony    2015-01-07  50  661 94  94  94  79  79  50
````



## 窗口函数中的序列函数

* Hive中常用的序列函数有下面几个：

### NTILE

* NTILE(n),用于将分组数据按照顺序切分成n片，返回当前切片值

* NTILE 不支持ROWS BETWEEN

* 如果切片步均匀，默认增加第一个切片的分布

* 案例：假如我们想要给每位顾客购买金额前1/3的交易记录，我们便可以使用这个函数

  ````sqlite
  select name,orderdate,cost,
         ntile(3) over() as sample1 , --全局数据切片
         ntile(3) over(partition by name), -- 按照name进行分组,在分组内将数据切成3份
         ntile(3) over(order by cost),--全局按照cost升序排列,数据切成3份
         ntile(3) over(partition by name order by cost ) --按照name分组，在分组内按照cost升序排列,数据切成3份
  from t_window
  ````

* ````
  name    orderdate   cost    sample1 sample2 sample3 sample4
  jack    2015-01-01  10  3   1   1   1
  jack    2015-02-03  23  3   1   1   1
  jack    2015-04-06  42  2   2   2   2
  jack    2015-01-05  46  2   2   2   2
  jack    2015-01-08  55  2   3   2   3
  mart    2015-04-08  62  2   1   2   1
  mart    2015-04-09  68  1   2   3   1
  mart    2015-04-11  75  1   3   3   2
  mart    2015-04-13  94  1   1   3   3
  neil    2015-05-10  12  1   2   1   1
  neil    2015-06-12  80  1   1   3   2
  tony    2015-01-02  15  3   2   1   1
  tony    2015-01-04  29  3   3   1   2
  tony    2015-01-07  50  2   1   2   3
  ````

* 

### row_number,rank,dense_rank

* row_number()  取直接的数字排名，比较值相同也不会重复
* rank()  类似于高考排名，比较值相同则排名相同，下一个排名数字会跳跃
* dense_rank  比较值相同则排名相同，但是排名的数字不会跳跃

### LAG和LEAD函数

* LAG(col,n,default_val) ：往前第n行数据,没有数据则返回default_val

* LEAD(col,n,default_val)：往后第n行数据,没有数据则返回default_val

* 案例：我们要查看顾客上次的购买时间

  ````sqlite
  select name,orderdate,cost,
  lag(orderdate,1,'1900-01-01') over(partition by name order by orderdate ) as time1,
  lag(orderdate,2) over (partition by name order by orderdate) as time2
  from t_window;
  ````

* 结果：

  ````
  name    orderdate   cost    time1   time2
  jack    2015-01-01  10  1900-01-01  NULL
  jack    2015-01-05  46  2015-01-01  NULL
  jack    2015-01-08  55  2015-01-05  2015-01-01
  jack    2015-02-03  23  2015-01-08  2015-01-05
  jack    2015-04-06  42  2015-02-03  2015-01-08
  mart    2015-04-08  62  1900-01-01  NULL
  mart    2015-04-09  68  2015-04-08  NULL
  mart    2015-04-11  75  2015-04-09  2015-04-08
  mart    2015-04-13  94  2015-04-11  2015-04-09
  neil    2015-05-10  12  1900-01-01  NULL
  neil    2015-06-12  80  2015-05-10  NULL
  tony    2015-01-02  15  1900-01-01  NULL
  tony    2015-01-04  29  2015-01-02  NULL
  tony    2015-01-07  50  2015-01-04  2015-01-02
  ````

### first_value和last_value

* first_value取分组内排序后，截止到当前行，第一个值

* last_value取分组内排序后，截止到当前行，最后一个值

  ````sqlite
  select name,orderdate,cost,
  first_value(orderdate) over(partition by name order by orderdate) as time1,
  last_value(orderdate) over(partition by name order by orderdate) as time2
  from t_window
  ````

  ````
  name    orderdate   cost    time1   time2
  jack    2015-01-01  10  2015-01-01  2015-01-01
  jack    2015-01-05  46  2015-01-01  2015-01-05
  jack    2015-01-08  55  2015-01-01  2015-01-08
  jack    2015-02-03  23  2015-01-01  2015-02-03
  jack    2015-04-06  42  2015-01-01  2015-04-06
  mart    2015-04-08  62  2015-04-08  2015-04-08
  mart    2015-04-09  68  2015-04-08  2015-04-09
  mart    2015-04-11  75  2015-04-08  2015-04-11
  mart    2015-04-13  94  2015-04-08  2015-04-13
  neil    2015-05-10  12  2015-05-10  2015-05-10
  neil    2015-06-12  80  2015-05-10  2015-06-12
  tony    2015-01-02  15  2015-01-02  2015-01-02
  tony    2015-01-04  29  2015-01-02  2015-01-04
  tony    2015-01-07  50  2015-01-02  2015-01-07
  
  ````

  

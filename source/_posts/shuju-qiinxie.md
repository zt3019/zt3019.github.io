---
title: shuju_qiinxie
date: 2021-10-22 15:59:33
tags:
- 数据倾斜
categories:
- 大数据
index_img: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhadoop.f.dajiangtai.com%2Fupload%2F2016%2F11%2F09%2Fblog%2F5fed2ae5-9730-41b7-abf6-a29d3b814a7d.png&refer=http%3A%2F%2Fhadoop.f.dajiangtai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637481826&t=4ea1a499879b0aa5af7934ec324e454d
banner_img: https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhadoop.f.dajiangtai.com%2Fupload%2F2016%2F11%2F09%2Fblog%2F5fed2ae5-9730-41b7-abf6-a29d3b814a7d.png&refer=http%3A%2F%2Fhadoop.f.dajiangtai.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1637481826&t=4ea1a499879b0aa5af7934ec324e454d
---

# 数据倾斜

## 数据倾斜描述

* 正常的数据分布理论上都是倾斜的，就是常说的2-8原则。不同的数据字段可能的数据倾斜一般有两种情况：
  - 唯一值非常少
  - 唯一值比较多

## 数据倾斜产生的原因

* 数据倾斜在MapReduce编程模型中十分常见,用最通俗易懂的话来说,数据倾斜无非就是大量的相同key被partition分配到一个分区里,造成了'一个人累死,其他人闲死'的情况,这种情况是我们不能接受的,这也违背了并行计算的初衷,首先一个节点要承受着巨大的压力,而其他节点计算完毕后要一直等待这个忙碌的节点,也拖累了整体的计算时间,可以说效率是十分低下的。
* 产生的现象：
  - 其它的任务都执行完成了，一个任务一直卡在某个进度，一直没有完成。
  - 本来应该能正常执行的任务，出现OOM(内存溢出)。

### 数据倾斜的解决

* 数据倾斜只会发生在shuffle中，在hive中，表的join,group by。在spark中常见可能会触发shuffle操作的算子：distinct，groupByKey,reduceByKey,aggregateByKey,join,cogroup,repartition等。
* 对于hive HQL来说解决的办法：
  - group by 时的数据倾斜:解决办法：hive.groupby.skewindata=true
    - 控制生成两个MRJob，第一个MR的map的输出结果随机分配到reduce中，减少某些key值条数过多，某些key 值条数过少造成的数据倾斜问题。
    - 第二个MR再根据预处理的数据结果，按照group By Key分布到reduce中，（这个过程可以保证相同的Group By Key分布到同一个reduce中），最后完成最终的聚合操作。
  - join时数据倾斜，对于一些热点key，他们所在的reduce运行较慢。解决方式：
    - 过滤不正常的记录
    - 数据去重
    - 使用map join
    - 打开set Hive.optimize.skewjoin = true;  
  - 无法从sql层面优化时，可以从业务算法角度提升
    - 只读需要的列和分区
    - 周，月任务按天累计计算
    - 先聚合后join
  - Reduce任务数不合理
    - set mapred.reduce.tasks=N
  - 业务数据本身存在倾斜
    - 配置参数，优化SQL语句，将数据值较多的数据分散到多个reduce中
  - 多维分析带来的低效
    - 当含有rollup和cube语句的from子句中包含子查询或者join时，将子查询或join的结果放到临时表，然后从临时表中读取数据做多维分析  
* 对于Spark来说解决的办法
  - 使用hive  ETL预处理数据
  - 过滤少量导致数据倾斜的key
  - 提高shuffle操作的并行度
  - 两阶段聚合
    - 第一次是局部聚合，先给每个key打上一个随机数，这样就不会数据倾斜了，先局部聚合
    - 第二次是全局聚合，把随机前缀去掉，再进行全局聚合
  - 将reduce join 转为map join
* spark数据倾斜的解决详细内容可见博客[spark 数据倾斜](https://blog.csdn.net/weixin_35353187/article/details/84303518)


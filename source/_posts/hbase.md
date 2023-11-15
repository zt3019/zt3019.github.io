---
title: hbase
date: 2021-06-27 11:39:02
tags:
- 大数据
- flume
categpries:
- 大数据
- Hbase
index_img: https://th.bing.com/th/id/R1ca597009e76b715bba612ba67909be7?rik=B64UMrUhcqEeag&riu=http%3a%2f%2fintellitech.pro%2fwp-content%2fuploads%2f2017%2f05%2fapache-hbase-image.png&ehk=70DnQXgetKij7C%2fCw%2bDtBFv6J1jPnGZV%2bFObTefSr24%3d&risl=&pid=ImgRaw
banner_img: https://th.bing.com/th/id/R1ca597009e76b715bba612ba67909be7?rik=B64UMrUhcqEeag&riu=http%3a%2f%2fintellitech.pro%2fwp-content%2fuploads%2f2017%2f05%2fapache-hbase-image.png&ehk=70DnQXgetKij7C%2fCw%2bDtBFv6J1jPnGZV%2bFObTefSr24%3d&risl=&pid=ImgRaw
---

# HBase

## HBbse概述

* HBase是一种分布式，可扩展，，支持海量数据存储的NoSQL数据库。
* 逻辑结构
* [![RJBhlV.png](https://z3.ax1x.com/2021/06/27/RJBhlV.png)](https://imgtu.com/i/RJBhlV)
* row key类似于主键
* region在行上的一个切分，几行分一个region
* 列族：Column Qualifier。
* store：按照region和列族可以分为一个个store

* 物理结构

  [![RJBomF.png](https://z3.ax1x.com/2021/06/27/RJBomF.png)](https://imgtu.com/i/RJBomF)

* 数据模型

  **1.** ***Name Space***

  命名空间，类似于关系型数据库的DatabBase概念，每个命名空间下有多个表。HBase有两个自带的命名空间，分别是hbase和default，hbase中存放的是HBase内置的表，default表是用户默认使用的命名空间。

  **2.** ***Region***

  类似于关系型数据库的表概念。不同的是，HBase定义表时只需要声明列族即可，不需要声明具体的列。这意味着，往HBase写入数据时，字段可以动态、按需指定。因此，和关系型数据库相比，HBase能够轻松应对字段变更的场景。

  **3.** ***Row***

  HBase表中的每行数据都由一个***RowKey***和多个***Column***（列）组成，数据是按照RowKey的字典顺序存储的，并且查询数据时只能根据RowKey进行检索，所以RowKey的设计十分重要。

  **4.** ***Column***

  HBase中的每个列都由Column Family(列族)和Column Qualifier（列限定符）进行限定，例如info：name，info：age。建表时，只需指明列族，而列限定符无需预先定义。

  **5.** ***Time*** ***Stamp***

  用于标识数据的不同版本（version），每条数据写入时，如果不指定时间戳，系统会自动为其加上该字段，其值为写入HBase的时间。

  **6.** ***Cell***

  由{rowkey, column Family：column Qualifier, time Stamp} 唯一确定的单元。cell中的数据是没有类型的，全部是字节数组形式存贮。

* 架构

  [![RJDyjK.png](https://z3.ax1x.com/2021/06/27/RJDyjK.png)](https://imgtu.com/i/RJDyjK)

* Region Server：region的管理者
* Master：所有Region Server的管理者
* Zookeeper：HBase通过Zookeeper来做Master的高可用、RegionServer的监控、元数据的入口以及集群配置的维护等工作。
* HDFS:HDFS为HBase提供最终的底层数据存储服务，同时为HBase提供高可用的支持。
* 一个RegionServer中有多个Region，每个Region中有多个store，每个Store中有一个Memstore和多个StoreFile

## HBase架构

[![RDKkkR.png](https://z3.ax1x.com/2021/06/30/RDKkkR.png)](https://imgtu.com/i/RDKkkR)

HBase分多个RegionServer，每个RegionServer内又有多个Region，每个Region中又有多个store，store中数据先写到内存，再写到SotreFile（分布式文件系统）上去。

* WAL:Write-Ahead logfile，防止写入内存后数据丢失，先写到这样一个日志文件中。类似于yarn中的edits文件。
* 保存实际数据的物理文件，StoreFile以HFile的形式存储在HDFS上。每个Store会有一个或多个StoreFile（HFile），数据在每个StoreFile中都是有序的。

### 写数据流程

[![RDKXHH.png](https://z3.ax1x.com/2021/06/30/RDKXHH.png)](https://imgtu.com/i/RDKXHH)

meta表中存放了表的信息，而meta的元数据信息存放在ZK上。

1) Client先访问zookeeper，获取hbase:meta（）表位于哪个Region Server，client如果在MetaCache中发现有该表的信息，就不会向ZK请求获取meta的位置了。

2) 访问对应的Region Server，获取hbase:meta表，根据读请求的namespace:table/rowkey，查询出目标数据位于哪个Region Server中的哪个Region中。并将该table的region信息以及meta表的位置信息缓存在客户端的meta cache，方便下次访问。

3) 与目标Region Server进行通讯；

4) 将数据顺序写入（追加）到WAL；

5) 将数据写入对应的MemStore，数据会在MemStore进行排序；

6) 向客户端发送ack；

7) 等达到MemStore的刷写时机后，将数据刷写到HFile（分布式存储中）。

### MemStore的刷写时机

* 当某个memstroe的大小达到了**hbase.hregion.memstore.flush.size**（默认值128M），其所在region的所有memstore都会刷写。但是数据持续写入到memstore也不会达到128就刷，当memstore的大小达到了128*4时，会阻止继续往该memstore写数据。
* Java heap size 堆栈大小, 指Java 虚拟机的内存大小。在Java虚拟机中，分配多少内存用于调用对象,函数和数组。因为底层中，函数和数组的调用在计算机中是用堆栈实现。
* 当region server中memstore的总大小达到
  **java_heapsize*hbase.regionserver.global.memstore.size.upper.limit**（默认值0.95），
  Region server会把它的所有region按照其所有memstore的大小顺序（由大到小）依次进行刷写。直到region server中所有region的memstore的总大小减小到***hbase.regionserver.global.memstore.size.lower.limit**以下。
* 当region server中memstore的总大小达到
  **java_heapsize*hbase.regionserver.global.memstore.size**（默认值0.4）
  时，会阻止继续往所有的memstore写数据。
* 达到自动刷写时间。默认1h。**hbase.regionserver.optionalcacheflushinterval**

### 读数据流程

[![RrMr7Q.png](https://z3.ax1x.com/2021/07/01/RrMr7Q.png)](https://imgtu.com/i/RrMr7Q)

* 与写数据流程差不多。说一下区别，去目标RegionServer读取数据时，会向Block Cache(读缓存),MemStore,StoreFile中查询数据，并将所有数据进行合并。此处所有数据是指同一条数据的不同版本（time stamp）或者不同的类型（Put/Delete）。
* 将从文件中查询到的数据块缓存到Block Cache中。客户端从读缓存中读取相应的数据。返回ACK。

### StoreFile Compaction

* 由于memstore每次刷写都会生成一个新的HFile，且同一个字段的不同版本（timestamp）和不同类型（Put/Delete）有可能会分布在不同的HFile中，因此查询时需要遍历所有的HFile。为了减少HFile的个数，以及清理掉过期和删除的数据，会进行StoreFile Compaction。

* Compaction（合并）分为两种：分别是Minor Compaction和Major Compaction。
* Minor Compaction会将临近的若干个较小的HFile合并成一个较大的HFile，但不会清理过期和删除的数据。默认是三个小文件会进行合并，达到一定的数量后也不会直接合并，会根据一个算法判断是否要进行合并。
* Major Compaction会将一个Store下的所有的HFile合并成一个大HFile，并且会清理掉过期和删除的数据。比较耗费资源，默认是一星期进行一次。

### Region Split

* 默认情况下，每个Table起初只有一个Region，随着数据的不断写入，Region会自动进行拆分。刚拆分时，两个子Region都位于当前的Region Server，但处于负载均衡的考虑，HMaster有可能会将某个Region转移给其他的Region Server。
* 分裂时机：如果当前RegionServer上只有一个Region，当这个Region中的所有Store file的总和超过2*hbase.hregion.memstore.flush.size分裂，否则按照超过hbase.hregion.max.filesize 分裂。

* 这样切分会尽量使每个Table的在每个RegionServer中的Region数量尽量一致。

## Hive与HBase集成

* hive默认是有jar包可与HBase集成的，可以用Hive对HBase中的数据进行分析，再将分析结果又返回到HBase中，方便其它的工作对分析好的数据的使用。

## Phoenix

* Phoenix是HBase的开源SQL皮肤。可以使用标准JDBC API代替HBase客户端API来创建表，插入数据和查询HBase数据。
* 可以用类sql语言操作hbase
* 优势：支持索引。

---
title: flume
date: 2021-06-21 17:20:42
tags:
- 大数据
- flume
categories:
- 大数据
- flume
index_img: https://img.stackshare.io/service/4337/Flume.png
banner_img: https://img.stackshare.io/service/4337/Flume.png
---



# Flume

## Flume概述

* 配置文档，自定义Source,Interceptor,sink就来看官方文档：[官方文档](http://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html#spooling-directory-source)

* flume是一个高可用的，可靠的，分布式的***海量日志采集，聚合，和传输的系统***基于流式框架，灵活简单。

* 基础架构：

  [![REvBm8.png](https://z3.ax1x.com/2021/06/21/REvBm8.png)](https://imgtu.com/i/REvBm8)

  - Agent:是一个JVM进程，它以事件的形式将数据从源头送至目的
  - source负责接收数据到Flume agent 的组件。可以处理各种类型，格式的日志数据。例如：spooling directory，netcat,avro,exec
  - sink不断轮询channel中的事件并且批量的移除他们，将这些事件批量写入到存储或索引系统，或者被发送到另一个flume agent。sink组件发送目的地包括：hdfs,logger,avro,file,HBase
  - Channel是位于source和sink之间缓冲区。Flume自带两种Channel：Memory Channel和File Channel。

* event:flume传输数据的基本单元。由Header和Body组成。Header用来存放该event的一些属性，为K-V结构，Body用来存放该条数据，形式为字节数组。

## flume入门案例

* 实时监控Hive日志，并上传到HDFS中

  ````
  1.第一种方式
  flume-ng agent --name agent的名字 --conf 配置文件的目录 --conf-file agent的配置文件（自己手动写）-Dflume.root.logger=INFO,console
  
  需要写配置文件
  基本步骤：
  #1.agent的source,channel,sink组件
  #2.source配置
  #3.channel配置
  #4.sink配置
  #5.source,channel,sink之间的关系
  # Name the components on this agent
  a2.sources = r2
  a2.sinks = k2
  a2.channels = c2
  
  # Describe/configure the source
  a2.sources.r2.type = exec
  a2.sources.r2.command = tail -F /opt/module/hive/logs/hive.log
  a2.sources.r2.shell = /bin/bash -c
  
  # Describe the sink
  a2.sinks.k2.type = hdfs
  a2.sinks.k2.hdfs.path = hdfs://hadoop102:8020/flume/%Y%m%d/%H
  #上传文件的前缀
  a2.sinks.k2.hdfs.filePrefix = logs-
  #是否按照时间滚动文件夹
  a2.sinks.k2.hdfs.round = true
  #多少时间单位创建一个新的文件夹
  a2.sinks.k2.hdfs.roundValue = 1
  #重新定义时间单位
  a2.sinks.k2.hdfs.roundUnit = hour
  #是否使用本地时间戳
  a2.sinks.k2.hdfs.useLocalTimeStamp = true
  #积攒多少个Event才flush到HDFS一次
  a2.sinks.k2.hdfs.batchSize = 100
  #设置文件类型，可支持压缩
  a2.sinks.k2.hdfs.fileType = DataStream
  #多久生成一个新的文件
  a2.sinks.k2.hdfs.rollInterval = 60
  #设置每个文件的滚动大小
  a2.sinks.k2.hdfs.rollSize = 134217700
  #文件的滚动与Event数量无关
  a2.sinks.k2.hdfs.rollCount = 0
  
  # Use a channel which buffers events in memory
  a2.channels.c2.type = memory
  a2.channels.c2.capacity = 1000
  a2.channels.c2.transactionCapacity = 100
  
  # Bind the source and sink to the channel
  a2.sources.r2.channels = c2
  a2.sinks.k2.channel = c2
  ````

  

* log4j.properties(日志架构)，类似于程序中的调试代码，输出一些东西，供编码的时候调试。但是项目上线后不能再直接输出，于是将这些调试输出输出到专门的日志文件中。

## Flume进阶

* flume事务。主要是为了保证数据不会丢失。

  [![RZxhvR.png](https://z3.ax1x.com/2021/06/22/RZxhvR.png)](https://imgtu.com/i/RZxhvR)

* flume agent内部原理：

  [![RZxsbV.png](https://z3.ax1x.com/2021/06/22/RZxsbV.png)](https://imgtu.com/i/RZxsbV)



* 1. Source接受数据，将数据以event的形式发给ChannnelProcessor

  2. ChannelProcessor将事件传递给拦截器，在拦截其中可以对event数据进行更改。

  3. 拦截器再将事件返回到ChannelProcessor，ChannelProcessor将每个事件给Channel选择器。ChannelSelector的作用就是选出Event将要被发往哪个Channel。其共有两种类型，分别是Replicating（复制）和Multiplexing（多路复用）。

  4. 再返回到ChannelProcessor，根据选择器的选择，event进入不同的channel

  5. SinkProcessor再决定channel中的enevt的走向。

     SinkProcessor共有三种类型，分别是DefaultSinkProcessor、LoadBalancingSinkProcessor和FailoverSinkProcessor。

     DefaultSinkProcessor对应的是单个的Sink，LoadBalancingSinkProcessor和FailoverSinkProcessor对应的是Sink Group，LoadBalancingSinkProcessor可以实现负载均衡的功能，FailoverSinkProcessor可以错误恢复的功能(故障转移）。

* flume拓扑结构
  - 简单串联。多个agent串起来
  - 复制和多路复用。Flume支持将事件流向一个或者多个目的地。这种模式可以将相同数据复制到多个channel中，或者将不同数据分发到不同的channel中，sink可以选择传送到不同的目的地。
  - 负载均衡和故障转移。Flume支持使用将多个sink逻辑上分到一个sink组，sink组配合不同的SinkProcessor可以实现负载均衡和错误恢复的功能。
  - 聚合。将多台服务器部署一个flume日志采集，再将所有日志聚合到一个集中收集日志的flume，由此上传到HDFS,HBase，进行数据分析。

### API编程

* 可以查看官网的开发者文档。
* 自定义Interceptor。定义类实现Interceptor接口，重写四个方法（初始化，单event修改，多event修改，关闭资源）还需要一个Builder静态内部类。

## 常见问题

### flume的source,sink,Channel的作用？

* 作用：

  （1）Source组件是专门用来收集数据的，可以处理各种类型、各种格式的日志数据，包括avro、thrift、exec、jms、spooling directory、netcat、sequence generator、syslog、http、legacy

  （2）Channel组件对采集到的数据进行缓存，可以存放在Memory或File中。

  （3）Sink组件是用于把数据发送到目的地的组件，目的地包括Hdfs、Logger、avro、thrift、ipc、file、Hbase、solr、自定义。

### flume参数调优

* ***1. source***

  增加Source个（使用Tair Dir Source时可增加FileGroups个数）可以增大Source的读取数据的能力。例如：当某一个目录产生的文件过多时需要将这个文件目录拆分成多个文件目录，同时配置好多个Source 以保证Source有足够的能力获取到新产生的数据。

  batchSize参数决定Source一次批量运输到Channel的event条数，适当调大这个参数可以提高Source搬运Event到Channel时的性能。

  ***2. Channel:***

  type 选择memory时Channel的性能最好，但是如果Flume进程意外挂掉可能会丢失数据。type选择file时Channel的容错性更好，但是性能上会比memory channel差。

  使用file Channel时dataDirs配置多个不同盘下的目录可以提高性能。

  Capacity 参数决定Channel可容纳最大的event条数。transactionCapacity 参数决定每次Source往channel里面写的最大event条数和每次Sink从channel里面读的最大event条数。transactionCapacity需要大于Source和Sink的batchSize参数。

  ***3. Sink***

  增加Sink的个数可以增加Sink消费event的能力。Sink也不是越多越好够用就行，过多的Sink会占用系统资源，造成系统资源不必要的浪费。

  batchSize参数决定Sink一次批量从Channel读取的event条数，适当调大这个参数可以提高Sink从Channel搬出event的性能。

### flume数据是否会丢失？

* flume采用事务机制，Flume使用两个独立的事务分别负责从Soucrce到Channel，以及从Channel到Sink的事件传递。如果因为某种原因使得事件无法记录，那么事务将会回滚。
* 正是因为flume完善的事务机制，flume不会丢失数据。
* 唯一可能丢失数据的情况是Channel采用memoryChannel，agent宕机导致数据丢失，或者Channel存储数据已满，导致Source不再写入，未写入的数据丢失。
* Flume不会丢失数据，但是有可能造成数据的重复，例如数据已经成功由Sink发出，但是没有接收到响应，Sink会再次发送数据，此时可能会导致数据的重复。


---
title: Hadoop的介绍
date:
updated:
tags:
- Hadoop
- 大数据
categories:
-大数据
- 老hadoop
index_img: https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4087057811,445331467&fm=26&gp=0.jpg
banner_img: https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4087057811,445331467&fm=26&gp=0.jpg
---
# Hadoop的介绍
1.hadoop两大核心组件    
> * HDFS(Hadoop Distributed File System )     
>> * NameNode(管理各种元数据并提供服务) ,DataNode  
>> *  冷备份SecondaryNameNode(HDFS1.0)
> * MapReduce    
>> * JobTracker TaskTracker    

2.Hadoop集群基准测试
> * Hadoop自带的一些基准测试程序，被打包在测试程序JAR文件中
> * 用TestDFSIO基准测试，来测试HDFS的IO性能
> * 用排序测试MapReduce

3.HDFS系统介绍    
基本介绍：HDFS开源实现了GFS的基本思想    
优良特性：
 > * 兼容廉价的硬件设备
 > * 流数据读写
 > * 大数据集
 > * 简单的文件模型
 > * 强大的跨平台兼容性   

局限性：
 > * 不适合低延迟数据访问
 > * 无法高效存储大量小文件
 > * 不支持多用户写入及任意修改文件 

相关概念：
 > * 块（64MB）
 > * 名称节点（NameNode）整个HDFS集群的管家
 >> * FsImage
 >> * EditLog
 > * 第二名称节点
 > * 数据节点    

HDFS存储原理：
 > * 冗余数据保存的问题
 > * 数据保存策略问题
 > * 数据恢复的问题
HDFS数据读写：
 > * 读写过程：    
 ![数据读写过程](https://img-blog.csdn.net/20160520174354336?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center "过程")
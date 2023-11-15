---
title: Hbase简介
date:
updated:
tags:
- Hadoop
- 大数据
categories:
- 大数据
- 老hadoop
index_img: https://th.bing.com/th/id/R1ca597009e76b715bba612ba67909be7?rik=B64UMrUhcqEeag&riu=http%3a%2f%2fintellitech.pro%2fwp-content%2fuploads%2f2017%2f05%2fapache-hbase-image.png&ehk=70DnQXgetKij7C%2fCw%2bDtBFv6J1jPnGZV%2bFObTefSr24%3d&risl=&pid=ImgRaw
banner_img: https://th.bing.com/th/id/R1ca597009e76b715bba612ba67909be7?rik=B64UMrUhcqEeag&riu=http%3a%2f%2fintellitech.pro%2fwp-content%2fuploads%2f2017%2f05%2fapache-hbase-image.png&ehk=70DnQXgetKij7C%2fCw%2bDtBFv6J1jPnGZV%2bFObTefSr24%3d&risl=&pid=ImgRaw
---
# 分布式数据库HBase简介
1. 概述    
    - HBase是针对谷歌BigTable的开源实现，是一个高可靠，高性能，面向列，可伸缩的分布式数据库           
    - 可以用来存储非结构化和半结构化的松散数据
2. 数据模型
    - 索引通过四个元素来定位：行键，列族，列限定符，时间戳
    -  面向列的存储
3. 实现原理 
    - HBase的功能组件
      > 库函数    
      Master服务器    
      Region服务器    
    - 两个核心概念表和Region
      > 一个HBase表被划分成多个Region     
      一个Region会分裂成多个新的Region
    - 怎么实现Region定位
      > 三层结构索引实现Region的定位    
      Zookeeper文件    
      -ROOT-表    
      .MEAT.表      

4. 运行机制
    - HBase的系统架构
    > ![](https://img-blog.csdnimg.cn/2020070104123335.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTE1NDU1OQ==,size_16,color_FFFFFF,t_70#pic_center "系统架构图")
    Zookeeper服务器（被大量用于分布式系统，提供配置维护，域名服务，分布式同步服务）实现协同管理服务，提供管家功能（维护和管理整个HBase集群）
    Master服务器作用：1.对表增删改查。2.负责不同Region服务器的负载均衡。3.负责调整分裂合并后Region的分布。4.负责重新分配故障，失效的Region服务器
    - Region服务器（负责用户数据的存储和管理）的工作原理
    - Store的工作原理
    - HLog的工作原理

5. 编程实践
HBase安装及实践，参考厦门大学数据库实验室博客      
[参考链接](http://dblab.xmu.edu.cn/blog/2442-2/)
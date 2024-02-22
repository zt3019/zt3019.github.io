---
title: boshi_work_summary
date: 2024-02-21 11:22:00
tags:
- 项目总结
hide: true
categories:
- 复盘
index_img: https://pic2.zhimg.com/v2-5b5bf59a17d6947d72b22b358b6805ca_r.jpg
banner_img: https://pic2.zhimg.com/v2-5b5bf59a17d6947d72b22b358b6805ca_r.jpg
---

# 总结

* 工作总结

## 数据仓库

### 数仓分层

* ODS 原始数据层

  - 基本数据存储格式
    - orc+snappy
    - parquet+lzo

  - 数据源基本上都是来自mysql等关系型数据库
  - 同步采用**datax**脚本同步数据
  - 启信宝数据采用分区表做每日增量更新操作
    - 做增量更新筛选时命中时间索引字段，加速查询
    - 增量更新出现**数据漂移问题**，**新增真实入库时间字段**保证数据不会丢失

* DW层 (临时处理层)  对每日新增数据做开窗取第一条数据，取最新的业务数据

  - 这种方式比较消耗时间，增加了一层数据层级，没有做分区无法找到历史数据
  - 采用制作拉链表的方式，可以找到历史数据，速度更快

#### 拉链表

* 适用场景：缓慢变化维度

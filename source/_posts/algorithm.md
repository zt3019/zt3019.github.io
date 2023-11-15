---
title: algorithm
date: 2021-10-04 17:15:54
tags:
- 算法
categories:
- 算法
index_img: https://tse1-mm.cn.bing.net/th/id/OIP-C.ltWNx-qIm5gQLLrUxTu5HgHaEt?pid=ImgDet&rs=1
banner_img: https://tse1-mm.cn.bing.net/th/id/OIP-C.ltWNx-qIm5gQLLrUxTu5HgHaEt?pid=ImgDet&rs=1
---



# 算法

## 动态规划

* 首先，动态规划问题一般形式就是求最值，求解动态规划的核心问题是穷举。
* 由于动态规划这类问题基本存在**重叠子问题**，如果暴力求解的话效率会很低，所以需要**备忘录或者DP table**来优化穷举过程。
* 动态规划问题一定会具备**最优子结构**，这样就能通过子问题求解原问题。要符合最优子结构，子问题之间必须相互独立。
* 正确的**状态转移方程**才能正确的求解。
* 求解动态规划的一般办法：
  - 确定基础案例，也就是最简单的子问题。
  - 确定状态，也就是原问题和子问题中会变化的量
  - 确定选择，也就是导致状态变化的行为
  - 明确dp 数组的含义

## 排序算法

* 常见排序算法的时间复杂度，稳定性
  - [![5KSEnO.png](https://z3.ax1x.com/2021/10/13/5KSEnO.png)](https://imgtu.com/i/5KSEnO)

## 大数取余算法

* 场景：当一个数很大时，大到基本类型都放不下，这时我们需要用String来存储数字。那么怎么进行取余操作呢？
* 我们根据一个例子来看看：
  - [![5KlnOS.png](https://z3.ax1x.com/2021/10/13/5KlnOS.png)](https://imgtu.com/i/5KlnOS)
  - 计算过程
    - 第一位数字4： 4%3=1；
    - 第二位数字4：（1*10+4）%3=2
    - 第三位数字3：（2*10+3）%3=2
  - 最终的结果是最后一步计算得到的余数2.

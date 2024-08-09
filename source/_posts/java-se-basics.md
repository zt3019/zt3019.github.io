---
title: java_se_basics
date: 2024-07-30 20:16:33
tags:
- JavaSE
hide: true
categories:
- Java
index_img: https://static.javatpoint.com/core/images/what-is-core-java2.png
banner_img: https://static.javatpoint.com/core/images/what-is-core-java2.png
---

# Java SE基础

## 第六章：集合

### 6.1集合概述

* [![pkxH3V0.png](https://s21.ax1x.com/2024/08/07/pkxH3V0.png)](https://imgse.com/i/pkxH3V0)













## 

* [![pkzOw28.png](https://s21.ax1x.com/2024/08/09/pkzOw28.png)](https://imgse.com/i/pkzOw28)
* JDBC常用API
* [![pkzO6Vs.png](https://s21.ax1x.com/2024/08/09/pkzO6Vs.png)](https://imgse.com/i/pkzO6Vs)
* [![pkzOf2T.png](https://s21.ax1x.com/2024/08/09/pkzOf2T.png)](https://imgse.com/i/pkzOf2T)
* [![pkzjmp6.png](https://s21.ax1x.com/2024/08/09/pkzjmp6.png)](https://imgse.com/i/pkzjmp6)
* [![pkzj8AA.png](https://s21.ax1x.com/2024/08/09/pkzj8AA.png)](https://imgse.com/i/pkzj8AA)
* [![pkzjt9P.png](https://s21.ax1x.com/2024/08/09/pkzjt9P.png)](https://imgse.com/i/pkzjt9P)

### 一般步骤

* 1.加载数据库驱动

  - ````java
    Class.forName("DriverName")
    ````

* 2.通过DriverManager获取数据库连接

  - ````java
    Connection conn = DriverManager.getConnection(url, username, password);//建立和数据库的连接对象
    ````

* 3.通过Connection对象获取Statement对象（执行sql后返回一个结果对象）

  - ````java
    Statement stmt = conn.createStatement();//创建Statement对象
    
    ````

* 4.使用Statement执行SQL语句

  - ````java
    ResultSet rs = stmt.executeQuery(sql);//使用Statement执行SQL语句，返回一个ResultSet结果集对象
    ````

* 5.操作ResultSet结果集

  - ````java
    /*
    可以操作返回的ResultSet结果集对象
    */
    while (rs.next()) {
                    int oid = rs.getInt("oid");
                    int oid2 = rs.getInt(1);
                    String credit_code = rs.getString("credit_code");
                    String stand_name = rs.getString("stand_name");
                    String source = rs.getString("source");
                    String source2 = rs.getString(4);
    
                    System.out.println(oid + "    |   " + credit_code + " |   " + stand_name + "  |   " + source + "  |   ");
                    System.out.println(oid2);
                    System.out.println(source2);
                }
    ````

* 6.关闭连接，释放资源

  - ````java
    /*
    每次操作数据库结束后都要进行关闭数据库连接，释放资源，以重复利用资源。通常关闭顺序是与打开顺序相反的。
    */
    finally {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            }
    ````

  - 

  


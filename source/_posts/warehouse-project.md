---
title: warehouse-project
date: 2021-07-29 09:04:09
hide: false
tags:
- 数据仓库
categories:
- 项目
- 离线数仓搭建
index_img: https://pic4.zhimg.com/v2-c56b23bd36d0488ea3617045a8fec4e4_720w.jpg?source=172ae18b
banner_img: https://pic4.zhimg.com/v2-c56b23bd36d0488ea3617045a8fec4e4_720w.jpg?source=172ae18b
---



# 离线数仓项目

## 数仓分层

* 为什么要分层

  [![WHSDoQ.png](https://z3.ax1x.com/2021/07/29/WHSDoQ.png)](https://imgtu.com/i/WHSDoQ)

  - ODS层（Operation Data Store）原始数据层，将前端日志数据，后端业务数据直接导入，不做处理
  - DWD层 (Data Warehouse Detail) 明细数据层，对ODS层数据进行数据清洗，维度退化，脱敏等。
  - DWS层 （Data Warehouse Service）服务数据层，以DWD层为基础，按天进行轻度汇总。
  - DWT层 （Data Warehouse Topic）主题数据层，以DWS层为基础，按主题进行汇总。
  - ADS层 （Application Data Store）应用数据层，为各种统计报表提供数据。
  
* 为什么要分层：

  - 把复杂问题简单化：将复杂的任务分解成多层来完成，每一层只处理简单的任务，方便定位问题。
  - 减少重复开发：规范数据分层，通过中间数据层，能够减少极大的重复计算，增加一次计算结果的复用性。
  - 隔离原始数据：不论是数据的异常还是数据的敏感性，使真实数据与统计数据解耦开。

## 数仓理论

### 范式概念

* 范式可以理解为设计一张数据表的表结构应符合的标准级别。
* 按照范式理论建表目的在于<font color=red>降低数据的冗余性</font>
* 范式的缺点是查询数据时需要进行大量的join操作。

#### 函数依赖

* 完全函数依赖：简单来说：就是AB能推出C，但是AB单独时不能推出C，那么说C完全依赖于AB。
* 部分函数依赖：AB能推出C,AB单独也能推出C，即C部分依赖于AB。
* 传递函数依赖：通过A推出B，通过B推出C，但是C推不出A，但是A能推出C，那么C传递函数依赖于A。

#### 范式区别

* 第一范式：属性不可切割
* 第二范式：不能存在部分函数依赖
* 第三范式：不能存在传递函数依赖

### 关系建模和维度建模

* 当今的数据处理大致可以分成两大类：联机事务处理OLTP（on-line transaction processing）、联机分析处理OLAP（On-Line Analytical Processing）。OLTP是传统的关系型数据库的主要应用，主要是基本的、日常的事务处理，例如银行交易。OLAP是数据仓库系统的主要应用，支持复杂的分析操作，侧重决策支持，并且提供直观易懂的查询结果。

* | ***对比属性*** | ***OLTP***                 | ***OLAP***                 |
  | -------------- | -------------------------- | -------------------------- |
  | ***读特性***   | 每次查询只返回少量记录     | 对大量记录进行汇总         |
  | ***写特性***   | 随机、低延时写入用户的输入 | 批量导入                   |
  | ***使用场景*** | 用户，Java EE项目          | 内部分析师，为决策提供支持 |
  | ***数据表征*** | 最新数据状态               | 随时间变化的历史状态       |
  | ***数据规模*** | GB                         | TB到PB                     |

#### 关系建模

* 关系建模，严格遵循第三范式。表较为松散，零碎，物理表数量多，而数据冗余程度低。由于数据分布于众多的表中，这些数据可以更为灵活地被应用，功能性较强。

#### 维度建模

* 维度模型主要应用在OLAP系统中，通常以某一个事实表为中心进行表的组织，主要面向业务。特征可能是存在数据的冗余，但是能方便得到数据。
* 关系模型虽然冗余少，但是在大规模数据，跨表分析统计查询过程中，会造成多表关联，这会大大降低执行效率。所以通常我们采用维度模型建模，把相关各种表整理成两种：事实表和维度表两种。

* 维度建模分成三种模型：
  - 星型模型
    - 标准的星型模型维度只有一层
  - 雪花模型
    - 比较靠近3NF，但是无法完全遵循，雪花模型的维度会设计多层。
  - 雪花模型和星型模型的主要区别在于维度的层级。
  - 选择星型模型还是雪花模型，取决于性能优先还是灵活更优先。在实际开发中，不会绝对选择一种，会根据情况灵活组合甚至并存，但是从整体上看<font color=red>更倾向与维度更少的星型模型,尤其对于Hadoop 体系，减少join就是减少Shuffle，性能差距很大</font>.星型模型性能更高一些，减少了join过程。雪花模型维度表表设计多层，更加灵活,减少了数据冗余，时间换空间。
  - [![WzGEEd.png](https://z3.ax1x.com/2021/08/01/WzGEEd.png)](https://imgtu.com/i/WzGEEd)
  - 星座模型
  - 星座模型与星型模型和雪花模型的区别是<font color=red>事实表的数量，星座模型是基于多个事实表。</font>
  - 星座模型基本上是很多数据仓库的常态，因为很多数据仓库都是多个事实表的，所以看是否为星座模型要看是否有多个事实表，他们之间是否共享一些维度表。
  - ![image-20210801175519654](C:\Users\Hasee\AppData\Roaming\Typora\typora-user-images\image-20210801175519654.png)

### 维度表与事实表（重点）

#### 维度表

* 维度表：一般是对事实的<font color=red>描述信息</font>。每一张维度表对应现实世界中的一个对象或者概念。例如：用户，商品，时间，地区等。就像是对事物描述的一个角度。
* 维度表的特征：
  - 维度表范围很宽（具有多个属性，列比较多）
  - 与事实表相比，行数相对较小
  - 内容相对固定：编码表，地区表

#### 事实表

* 事实表中的每行数据代表一个业务事件（下单，支付，退款等），事实这个术语表示的是业务事件的<font color=red>度量值（可以统计次数，个数，金额等）</font>
* 事实表的行包括：
  - 具有可加性的数值型的度量值
  - 与维度表相连接的外键（通常具有两个和两个以上的外键，外键之间表示维度表之间多对多的关系）

* 事实表的特征：
  - 非常大
  - 列数较少
  - 经常变化，每天会新增很多
* 事实表分类：
  - 事务型事实表：以每个<font color=red>事务或事件为单位</font>，例如一个销售订单记录，一比支付数据，作为事实表里一行数据。<font color=red>一旦事务被提交，事实表数据被插入，数据就不再进行更改，其更新方式为增量更新</font>
  - 周期型快照事实表：周期型快照事实表中<font color=red>不会保留所有数据，只保留固定时间间隔的数据</font>，例如月销售，加购物车事实表，收藏事实表额等。
  - 累积型快照事实表：<font color=red>累积型快照事实表用于跟踪业务事实的变化</font>。例如，数据仓库中可能需要累积或存储订单从下订单开始，到订单商品被打包、运输、和签收的各个业务阶段的时间点数据来跟踪订单声明周期的进展情况。当这个业务过程进行时，事实表的记录也要不断更新。

### 数据仓库建模

#### ODS层

- 保持数据原貌不做任何修改，起到数据备份的作用
- 数据进行压缩，减少磁盘存储空间
- 创建分区表（按照天进行分区），避免全表扫描

#### DWD层

- DWD层采用维度建模，采用星型模型，有多个事实表，事实表之间共享一些维度表。构成星座模型

- 维度建模步骤：<font color=red>选择业务过程-->声明粒度-->确认维度-->确认事实</font>

  - 选择业务过程：一条业务线对应一张事实表。比如下单业务，支付业务，退款业务，物流业务，一条业务线对应一张事实表。
  - 声明粒度：声明粒度指数据仓库中<font color=red>保存数据的细化程度或综合程度的级别。</font>声明粒度意味着精确定义事实表中的一行数据表示什么，应该尽可能选择最小粒度，以此来应对各种各样的需求。
    - 典型的粒度声明：
      - 订单中，每个商品项作为下单事实表中的一行
      - 每周的订单次数作为一行，粒度就是每周下单
      - 每月的订单次数作为一行，粒度就是每月下单
  - 确定维度：维度的主要作用是描述业务事实。会将业务系统中的表进行一些合并，即维度退化。
  - 确定事实：此处事实指业务中的度量值（事实表中数值型的度量值）。在DWD层中，以业务过程为建模驱动，基于每个具体以业务过程的特点，构建最细粒度的明细层事实表。

- [![fpvuSf.png](https://z3.ax1x.com/2021/08/02/fpvuSf.png)](https://imgtu.com/i/fpvuSf)

* |                  | ***时间*** | ***用户*** | ***地区*** | ***商品*** | ***优惠券*** | ***活动*** | ***编码*** | ***度量值*** |
  | ---------------- | ---------- | ---------- | ---------- | ---------- | ------------ | ---------- | ---------- | ------------ |
  | ***订单***       | √          | √          | √          |            |              | √          |            | 件数/金额    |
  | ***订单详情***   | √          |            | √          | √          |              |            |            | 件数/金额    |
  | ***支付***       | √          |            | √          |            |              |            |            | 金额         |
  | ***加购***       | √          | √          |            | √          |              |            |            | 件数/金额    |
  | ***收藏***       | √          | √          |            | √          |              |            |            | 个数         |
  | ***评价***       | √          | √          |            | √          |              |            |            | 个数         |
  | ***退款***       | √          | √          |            | √          |              |            |            | 件数/金额    |
  | ***优惠券领用*** | √          | √          |            |            | √            |            |            | 个数         |

* 至此，数仓的维度建模完成。DWS，DWT和ADS层和维度建模已经没有关系了。DWS和DWT都是建宽表，宽表(通常是指业务主题相关的指标、维度、属性关联在一起的一张数据库表。由于把不同的内容都放在同一张表存储，宽表已经不符合三范式的模型设计规范，随之带来的主要坏处就是数据的大量冗余，与之相对应的好处就是查询性能的提高与便捷。)都是按照主题去建。主题相当于观察问题得到角度。对应着维度表。

#### DWS层，DWT层

* DWS层统计各个主题对象的当天行为，服务于DWT层的主题宽表。
  - 每日设备行为
  - 每日会员行为
  - 每日商品行为
  - 每日地区统计
  - 每日活动统计
* DWT层：以分析的主题对象为建模驱动，基于上层的应用和产品的指标需求，构建主题对象的全量宽表。
  - 设备主题
  - 用户主题
  - 商品主题
  - 地区主题
  - 营销活动主题

#### ADS

* 对电商系统各大主题指标分别进行分析。

### Hive环境准备

* 安装配置Spark
  - spark需要重新编译（spark本身就有hive依赖，不需要hive的相关依赖，防止与hive冲突）
* Hive on spark
* 配置多队列，yarn默认容量调度器且默认只有一个default队列，再配置一个hive队列。在capacity-scheduler.xml中进行配置。
* set mapreduce.job.queuename=hive;

## 数仓搭建

### ODS层

* 业务数据根据不同的数据同步策略，通过脚本将数据写入到ODS层。日志数据先按字符串处理，再到DWD层将数据解析出来。

- 保持数据源码不做修改，起到备份数据的作用，采用LZO压缩。

- 创建分区表，防止全表扫描

- 创建外部表

  ````
  STORED AS
    INPUTFORMAT 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
    OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
  ````

- 创建输入数据是LZO输出是text，支持json解析的分区表。采用LZO压缩的外部表

### DWD层（重点）

* 列式压缩存储。有些表指定采用LZO压缩。优点：查询速度快，占用磁盘空间少（压缩比非常高）

* 采用列式存储后会有默认的压缩方式。

  ````
  PARTITIONED BY (dt string)
  stored as parquet
  location '/warehouse/gmall/dwd/dwd_start_log/'
  TBLPROPERTIES('parquet.compression'='lzo');
  ````

  

* 分区表，外部表

  ````
  PARTITIONED BY (dt string)
  stored as parquet
  location '/warehouse/gmall/dwd/dwd_start_log/'
  TBLPROPERTIES('parquet.compression'='lzo');
  ````

  

* 主要操作
  - 对用户行为数据进行解析，对核心数据进行判空过滤
  - 维度建模（维度退化）

#### 日志数据

* 启动日志解析
  - get_json_object函数使用，使用get_json_object函数将启动日志的字段解析出来
  
* 事件日志解析
  
  - 先创建事件日志基础明细表
  
  - [![4oW8YR.png](https://z3.ax1x.com/2021/09/30/4oW8YR.png)](https://imgtu.com/i/4oW8YR)
  
  - 自定义UDF函数，解析公共字段(一进一出)
    - 定义类继承UDF，重写evaluate() 方法
    
    - UDF函数的返回值是什么evaluate()方法的返回值就是什么
    
    - 函数的输入参数是什么evaluate()方法的参数就是什么
    
      ````java
      package com.zt.gmall.hive;
      
      import org.apache.commons.lang.StringUtils;
      import org.apache.hadoop.hive.ql.exec.UDF;
      import org.json.JSONObject;
      
      public class LogUDF extends UDF {
          //UDF函数的返回值与evaluate方法的返回值类型相同
          //UDF函数的参数和evaluat方法的参数相同
          //line指事件日志，key指需要的数据，
          // 如果是"st"，返回servertime;
          //如果是"et",返回事件数组
          //如果是公共字段的值,返回各个公共字段的值
          //去除空数据
          public String evaluate(String line, String key) {
              if (StringUtils.isBlank(line)) {
                  return "";
              }
              //split中的参数为一个正则表达式，
              // 而|在正则表示中有含义需要\转义，
              // 而\在java中也有特殊含义，所以又需要转义
              String[] split = line.split("\\|");
              if (split.length != 2) {
                  return "";
              }
              String serverTime = split[0];
              String jsonStr = split[1];
              JSONObject jsonObject = new JSONObject(jsonStr);
              if("st".equals(key)){
                  return serverTime;
              }
              else if("et".equals(key)){
                  if(jsonObject.has("et")) {
                      return jsonObject.getString("et");
                  }
              }else {
                  //获取到cm子JSON对象，公共字段解析
                  JSONObject cm = jsonObject.getJSONObject("cm");
                  if(cm.has(key)){
                      return cm.getString(key);
                  }
              }
              return "";
          }
      }
      ````
      
      
    
  - 自定义UDTF函数解析具体事件（解析json数组）
    - 定义类继承抽象类GenericUDTF，实现initialize()（自定义输出的列名和类型）；process() （具体的处理，将结果返回forward(result)）；close()
    
    - 输出事件名和事件json 对象
    
      ````java
      package com.zt.gmall.hive;
      
      import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
      import org.apache.hadoop.hive.ql.metadata.HiveException;
      import org.apache.hadoop.hive.ql.udf.generic.GenericUDTF;
      import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
      import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorFactory;
      import org.apache.hadoop.hive.serde2.objectinspector.StructField;
      import org.apache.hadoop.hive.serde2.objectinspector.StructObjectInspector;
      import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
      import org.json.JSONArray;
      
      import java.util.ArrayList;
      import java.util.List;
      
      public class LogUDTF extends GenericUDTF {
      
          @Override
          public void close() throws HiveException {
          }
          //initialize方法可以校验传入参数类型是否合法
          //ObjectInspector对象检查器  封装了数据类型（封装了输出类型）
          //处理时间数组
          @Override
          public StructObjectInspector initialize(StructObjectInspector argOIs) throws UDFArgumentException {
              List<? extends StructField> allStructFieldRefs = argOIs.getAllStructFieldRefs();
              //入参的校验
              if(allStructFieldRefs.size()!=1){
                  throw new UDFArgumentException("参数个数只能为1");
              }
              //这里返回的类型是hive的数据类型
              if(!"string".equals(allStructFieldRefs.get(0).getFieldObjectInspector().getTypeName())){
                  throw new UDFArgumentException("参数类型只能为string");
              }
              ArrayList<String> fieldNames = new ArrayList<String>();
              ArrayList<ObjectInspector> fieldOIs = new ArrayList<ObjectInspector>();
              //返回回去的两个列
              fieldNames.add("event_name");
              fieldNames.add("event_json");
              fieldOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);
              fieldOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);
              return ObjectInspectorFactory.getStandardStructObjectInspector(fieldNames,
                      fieldOIs);
          }
          //完成initialize方法后，将每一行交给process()方法，每一行经过处理变成多行，传递给forward()，forward将结果带出
          @Override
          public void process(Object[] args) throws HiveException {
              String eventArray = args[0].toString();
              JSONArray jsonArray = new JSONArray(eventArray);
              for (int i = 0; i <jsonArray.length() ; i++) {
                  String[] result=new String[2];
                  result[0]=jsonArray.getJSONObject(i).getString("en");
                  result[1]=jsonArray.getString(i);
                  forward(result);
              }
          }
          
      }
      ````
    
      
    
  - 把jar包打包上传到HDFS上的user/hive/jars路径下，创建永久函数与开发好的Java class关联
  
    ````
    create function base_analizer as 'com.zt.udf.BaseFieldUDF' using jar 'hdfs://hadoop100:9000/user/hive/jars/hivefunction-1.0-SNAPSHOT.jar';
    
    create function flat_analizer as 'com.zt.udtf.EventJsonUDTF' using jar 'hdfs://hadoop100:9000/user/hive/jars/hivefunction-1.0-SNAPSHOT.jar'; 
    ````
  
  - 通过处理得到事件解析日志基础表，再在事件日志解析基础表的基础上，创建具体的事件日志表。用get_json_object获取数据。

#### 业务数据

* 事实表分类

  - 事实表也可以做适当的宽表化处理。

  - 事务型事实表（增量同步）

    - 订单详情事实表
      - 以订单业务作为具体的业务过程（订单详情表与订单表（提供省份ID字段）连接），与<font color=red>时间，地区，商品</font>维度表相关联。以<font color=red>商品数量，商品金额</font>作为度量值。
    - 支付事实表
      - 以支付业务为具体的业务过程（支付流水表与订单表（提供省份ID字段）连接），与<font color=red>时间，地区</font>维度表关联，以<font color=red>支付金额</font>作为度量值。
    - 退款事实表
      - 以退款业务为具体的业务过程（退款表），与<font color=red>时间，用户，商品</font>维度表关联，以<font color=red>退款数量，退款金额</font>作为度量值。
    - 评价事实表
      - 以评价业务为具体的业务过程（商品评论表），与<font color=red>时间，用户，商品</font>维度表关联，以<font color=red>数量</font>作为度量值
    - 只会新增，不会修改

  - 周期型快照事实表（全量同步）

    - 周期型快照事实表的劣势：存储的数据量会比较大。解决办法：周期型快照事实表存储的数据比较讲究时效性，时间太久了的意义不大，可以删除以前的数据。

    - 加购事实表
      - 由于购物车的数量会发生变化，不适合导入增量。每天做一次快照，全量导入
      - 以加购物车为具体的业务过程（商品加购物车表），与<font color=red>时间，用户，商品</font>维度表关联，以<font color=red>数量，金额</font>作为度量值，。
    - 收藏事实表
      - 以收藏为具体业务过程（商品收藏表），与<font color=red>时间，用户，商品</font>维度表关联。以<font color=red>数量</font>作为度量值。
    - 数据周期性变化，可能增加，也可能删除（但是并不关心变化的过程，只关心周期性的一个数据结果）。所以选择全量同步。

  - 累积型快照事实表（新增及变化同步）

    - 优惠卷领用事实表
      - 优惠卷的生命周期：领取优惠卷-->使用优惠卷下单-->优惠卷参与支付
      - 累积型快照事实表的使用：统计优惠卷领取次数，优惠卷下单次数，优惠卷参与支付次数。
      - 以优惠卷为具体业务过程，与<font color=red>时间，用户，优惠卷</font>维度表关联，以<font color=red>数量</font>为度量值。
    - 订单事实表
      - 订单生命周期：创建时间-->支付时间-->取消时间-->完成时间-->退款时间-->退款完成时间
      - 以订单业务为具体的业务过程，与<font color=red>时间，用户，地区，活动</font>维度表关联，以<font color=red>数量，金额</font>为度量值。
    - 数据是会累积的，适用于随时间变化的。适用于周期性的业务。比如优惠卷领取时间，使用时间（下单），使用时间（支付）。如订单事实表中的创建时间，支付时间，取消时间，完成时间，退款时间，退款完成时间。

* 维度表

  - 全量同步
    - 商品维度表
      - 维度退化：以SKU表为主体，与商品三级，二级，一级分类表和SPU表，品牌表连接选择相应字段加入SKU表中，形成商品维度表
    - 优惠卷维度表
      - 以优惠卷表为主体建立优惠卷维度表
    - 活动维度表
      - 维度退化：以活动表为主体，与活动规则表连接选择相应字段建立活动维度表。
  - 特殊同步（导一次）
    - 地区维度表
      - 一般不会更改，将数据一次导入
      - 维度退化：将省份表和地区表合并作为地区维度表
    - 时间维度表
      - 可以设计将时间数据一次性导入（将很多年的时间都导入，后续就不用再导表了）
  - 拉链表
    - 用户维度表
      - 以用户表为主体，<font color= red>最好有”有效开始日期“，"有效结束日期"</font>,拉链表根据这两个日期判断更新，用户最新状态等信息。
    - 用户表中的数据每日既有可能新增，也有可能修改，但修改频率并不高，属于缓慢变化维度，此处采用拉链表存储用户维度数据。
    - 拉链表，记录每条信息的生命周期，一旦一条记录的生命周期结束，就重新开始一条新的记录，并把当前日期放入生效开始日期，结束日期设为最大值，再将上一条修改的结束日期改为当前日期-1。
    - 拉链表适合于数据会发生变化，但是大部分是不变的。（即缓慢变化）
    - 拉链表的更新：用户**当天**全部数据和MySQL中每天变化的数据拼接在一起，然后insert overwrite回旧的拉链表。insert overwrite会形成一个临时的拉链表。用临时的拉链表覆盖旧的拉链表数据。
    - [![4TkIpj.png](https://z3.ax1x.com/2021/09/30/4TkIpj.png)](https://imgtu.com/i/4TkIpj)

* [![fpvuSf.png](https://z3.ax1x.com/2021/08/02/fpvuSf.png)](https://imgtu.com/i/fpvuSf)

### DWS层

* 列式存储
* 宽表：字面意思就是说字段比较多的数据库表，通常是指业务主题的指标，维度，属性关联在一起的一张数据库表。由于把不同的内容都放在同一张表存储，宽表已经不符合三范式的模式设计规范，随之带来的坏处就是大量冗余，与之相应的好处就是查询性能的提高与便捷。
* DWS层的宽表字段，是站在不同维度的视角去看事实表。重点关注事实表的度量值。
* 业务
  - 每日会员行为
  - 每日商品行为
  - 每日活动统计
  - 每日地区统计
* 用户行为
  - 每日设备行为

### DWT层

* 列式存储

- 设备主题宽表
- 会员主题宽表
- 商品主题宽表
- 活动主题宽表
- 地区主题宽表

### ADS层

* 对电商系统各大主题指标分别进行分析。
* 设备主题：
  - 活跃设备数（日，周，月）
  - 每日新增设备
  - 流失用户数
  - 留存率
  - 最近连续三周活跃用户数
  - 最近七天内连续三天活跃用户数
* 会员主题
  - 会员主题信息
* 商品主题
  - 商品销量排行
  - 商品差评率
  - 商品退款率排名（最近30天）
* 营销主题（活动主题）
  - 下单数目统计
  - 支付信息统计
* 地区主题
  - 地区主题信息


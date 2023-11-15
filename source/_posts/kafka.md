---
title: kafka
date: 2021-06-24 14:41:50
tags:
- 大数据
- kafka
categories: 
- 大数据
- Kafka
index_img: https://tse2-mm.cn.bing.net/th/id/OIP-C.Y5uqThiNNfiD-p6shXMsIQHaEa?pid=ImgDet&rs=1
banner_img: https://tse2-mm.cn.bing.net/th/id/OIP-C.Y5uqThiNNfiD-p6shXMsIQHaEa?pid=ImgDet&rs=1
---

# kafka

## Kafka概述

* kafaka是一个分布式的基于发布/订阅模式的消息队列，主要应用于大数据实时处理领域。

* 消息队列一般分为两种模式：

  1. 点对点模式（一对一，消费者主动拉取数据，消息收到后消息清除）
  2. 发布/订阅模式（一对多，消费者消费数据之后不会清除消息）

* 基础架构

  [![RgX9C4.png](https://z3.ax1x.com/2021/07/03/RgX9C4.png)](https://imgtu.com/i/RgX9C4)

  - producer:消息生产者，向Kafka broker发消息的客户端
  - consumer：消息消费者，向Kafka broker取消息的客户端
  - consumer group：消费者组，由多个consumer组成。消费者组内每个消费者负责消费不同分区的数据，一个分区只能由一个消费者消费；消费者组之间互不影响。所有的消费者都属于某个消费者组，即消费者组是逻辑上的一个订阅者。
  - broker：一台kafka服务器就是一个broker。一个Kafak集群由多个broker组成。一个broker可以容纳多个topic。
  - topic：可以理解为一个队列，生产者和消费者面向的都是一个topic
  - partition：为了实现扩展性，一个非常大的topic可以分布到多个broker（即服务器）上，一个topic可以分为多个partition，每个partition是一个有序的队列；
  - replica：副本，为保证集群中的某个节点发生故障时，该节点上的partition数据不丢失，且kafka仍然能够继续工作，kafka提供了副本机制，一个topic的每个分区都有若干个副本，一个leader和若干个follower
  - leader：每个分区多个副本的“主”，生产者发送数据的对象，以及消费者消费数据的对象都是leader。
  - follower：每个分区多个副本中的“从”，实时从leader中同步数据，保持和leader数据的同步。leader发生故障时，某个follower会成为新的leader。

## 架构深入

### 文件存储机制

* Kafka中的消息使以topic进行分类的，生产者生产消息，消费者消费消息都是面向topic的。

* topic是逻辑的一个概念，partition是物理上的一个概念，每一个partition对应一个log文件，log文件中存放生产者生产的数据。每条数据也有自己的offset，消费者组中的每一个消费者，都会实时记录自己消费到了哪个offset，以便于出错时恢复，从上次的位置继续消费。

* [![RgXeUO.png](https://z3.ax1x.com/2021/07/03/RgXeUO.png)](https://imgtu.com/i/RgXeUO)

* 当log文件过大时就会分成多个segment,主要是为了加快索引速度，而且一个log文件分成多个segment都是在磁盘上连续存储的，Kafka这样的设计可以大幅度提高数据读写速度。

* 一个segment对应三个文件，一个log文件，两个index文件，一个.index文件和一个.timeindex文件。

* “.index”文件存储大量的索引信息，“.log”文件存储大量的数据，索引文件中的元数据指向对应数据文件中message的物理偏移地址。

* index和log文件以当前segment的第一条消息的offset命名

  [![RgXQxA.png](https://z3.ax1x.com/2021/07/03/RgXQxA.png)](https://imgtu.com/i/RgXQxA)

### Kafka生产者

* Kafka的数据也是类似于键值对形式的数据。例如<String,String>

#### 分区策略

* 分区的原因：1.方便在集群中扩展。2.可以提高并发，以partition为单位进行读写。

* 分区写入策略：

  - 所谓轮询策略，即按顺序轮流将每条数据分配到每个分区中。

    - 举个例子，假设主题test有三个分区，分别是分区A，分区B和分区C。那么主题对接收到的第一条消息写入A分区，第二条消息写入B分区，第三条消息写入C分区，第四条消息则又写入A分区，依此类推。

      轮询策略是默认的策略，故而也是使用最频繁的策略，它能最大限度保证所有消息都平均分配到每一个分区。除非有特殊的业务需求，否则使用这种方式即可。

  - 随机策略，也就是每次都随机地将消息分配到每个分区。其实大概就是先得出分区的数量，然后每次获取一个随机数，用该随机数确定消息发送到哪个分区。

    - 在比较早的版本，默认的分区策略就是随机策略，但其实使用随机策略也是为了更好得将消息均衡写入每个分区。但后来发现对这一需求而言，轮询策略的表现更优，所以社区后来的默认策略就是轮询策略了。

  - 按键保存策略，就是当生产者发送数据的时候，可以指定一个key，计算这个key的hashCode值，按照hashCode的值对不同消息进行存储。

    - 只要让生产者发送的时候指定key就行。刚刚不是说默认的是轮询策略吗？其实啊，kafka默认是实现了两个策略，没指定key的时候就是轮询策略，有的话那激素按键保存策略了。

#### 数据可靠性的保证

* producer向server发信息时是异步通信，为确保数据的可靠性，需要向producer发送ACK（acknowledgement确认收到）。如果producer收到ack，就会进行下一轮的发送，否则重新发送数据。这时会出现三种返回ack的时机：

  1.收到后还没写立刻发送。最不安全

  2.leader写完数据后发送ack。

  3.ISR中所有副本都写完数据后发送ack。kafka默认的选择。优点：容忍n台节点故障，只需要n+1个副本。

* 根据这三种情况，将ack的值分别分为0，1，all(-1)。

* 在第三种情况中，会出现一种意外情况：leader收到数据，所有follower都开始同步数据，但有一个follower，因为某种故障，迟迟不能与leader进行同步，那leader就要一直等下去，直到它完成同步，才能发送ack。这个问题怎么解决呢？

* Kafka引入一个Leader维护了一个动态的in-sync replica set (ISR)，解决上述问题。和leader保持同步的follower在ISR中，如果Follower长时间未向leader同步数据，该follower会被踢出ISR，实践阈值由***replica.lag.time.max.ms***参数设定。leader故障则会重新选举leader。

  [![RgXWRJ.png](https://z3.ax1x.com/2021/07/03/RgXWRJ.png)](https://imgtu.com/i/RgXWRJ)

  * 当follower故障时会被临时踢出ISR，待待该follower恢复后，follower会读取本地磁盘记录的上次的HW，并将log文件高于HW的部分截取掉，从HW开始向leader进行同步。等该***follower的LEO大于等于该Partition的HW***，即follower追上leader之后，就可以重新加入ISR了。
  * leader发生故障之后，会从ISR中选出一个新的leader，之后，为保证多个副本之间的数据一致性，其余的follower会先将各自的log文件高于HW的部分截掉，然后从新的leader同步数据。
  * 这只能保证副本之间的数据一致性，并不能保证数据不丢失或者不重复

* exactly once语义：At Least Once + 幂等性 = Exactly Once。

* 幂等性就是指Producer不论向Server发送多少次重复数据，Server端都只会持久化一条。

* 将服务器的ACK级别设置为-1，可以保证Producer到Server之间不会丢失数据，即At Least Once语义。

* 要启用幂等性，只需要将Producer的参数中enable.idompotence设置为true即可。Kafka的幂等性实现其实就是将原来下游需要做的去重放在了数据上游。开启幂等性的Producer在初始化的时候会被分配一个PID，发往同一Partition的消息会附带Sequence Number。而Broker端会对<PID, Partition, SeqNumber>做缓存，当具有相同主键的消息提交时，Broker只会持久化一条。

* 局限性：但是PID重启就会变化，同时不同的Partition也具有不同主键，所以幂等性无法保证跨分区跨会话的Exactly Once。

### Kafka消费者

#### 消费方式

* 消费方式：consumer采用pull(拉)模式从broker中读取数据。
* pull模式不足之处是，如果kafka没有数据，消费者可能会陷入循环中，一直返回空数据。针对这一点，Kafka的消费者在消费数据时会传入一个时长参数timeout，如果当前没有数据可供消费，consumer会等待一段时间之后再返回，这段时长即为timeout。

#### 分区分配策略

* 理想状况是一个consumergroup中每一个consumer负责拉取一个分区的数据。

* roundrobin：当分区数大于consumer数量时，轮询分配，类似于斗地主一张一张的发牌。
* range:类似于斗地主一次性发几张牌

#### offset维护

* 由于consumer在消费过程中可能会出现断电宕机等故障，consumer恢复后，需要从故障前的位置的继续消费，所以consumer需要实时记录自己消费到了哪个offset，以便故障恢复后继续消费。
* 将offset放在Kafka内置的一个topic中，__consumer_offsets。由50个分区。

#### Zookeeper在Kafka中作用

* Kafka集群中有一个broker会被选举为Controller，负责管理集群broker的上下线，所有topic的分区副本分配和leader选举等工作。Controller的选举就是比谁快。

* Controller的管理工作都是依赖于Zookeeper的。

  [![RgXXzd.png](https://z3.ax1x.com/2021/07/03/RgXXzd.png)](https://imgtu.com/i/RgXXzd)

* leader挂掉之后，Controller会选举新的leader，更新永久节点state中的信息。state存放某个topic,某个分区的以些必要信息。

#### Kafka事务

* 为了实现跨分区跨会话的事务，需要引入一个全局唯一的Transaction ID，并将Producer获得的PID和Transaction ID绑定。这样当Producer重启后就可以通过正在进行的Transaction ID获得原来的PID。

### KafkaAPI

* produceAPI

* Kafka的Producer发送消息采用的是***异步发送***的方式。在消息发送的过程中，涉及到了**两个线程——main线程和Sender线程**，以及***一个线程共享变量——RecordAccumulator***。main线程将消息发送给RecordAccumulator，Sender线程不断从RecordAccumulator中拉取消息发送到Kafka broker。

  [![RGBi1f.png](https://z3.ax1x.com/2021/06/26/RGBi1f.png)](https://imgtu.com/i/RGBi1f)

  * 相关参数：

    ***batch.size******：***只有数据积累到batch.size之后，sender才会发送数据。

    ***linger.ms******：***如果数据迟迟未达到batch.size，sender等待linger.time之后就会发送数据。

* ConsumerAPI

* Consumer消费数据时的可靠性是很容易保证的，因为数据在Kafka中是持久化的，故不用担心数据丢失问题。

  由于consumer在消费过程中可能会出现断电宕机等故障，consumer恢复后，需要从故障前的位置的继续消费，所以consumer需要实时记录自己消费到了哪个offset，以便故障恢复后继续消费。

  所以offset的维护是Consumer消费数据是必须考虑的问题。

### Exactly Once语义

* At Least Once 是Kafka默认提供的语义，它保证每条消息都能至少接收并处理一次，缺点是可能有重复数据。
* At Most Once 最多一次就是保证一条消息只发送一次，这个其实最简单，异步发送一次然后不管就可以，缺点是容易丢数据，所以一般不采用。
* 要实现Exactly Once语义首先要弄清楚哪里会丢数据，哪里会重复数据
  - 首先是生产者丢失信息：
    - Producer客户端有一个ack的配置，异步通信，通过ack来确定数据接收情况。要达到最严格的无消息丢失配置，应该是要将ack的参数设置为-1（all）。**同时还需要使用带有回调的producer api，来发送数据**
    - Kafka 有一个配置参数min.insync.replicas，默认是1（也就是只有leader，实际生产应该调高），该属性规定了最小的ISR数。这意味着当acks为-1（即all）的时候，这个参数规定了必须写入的ISR集中的副本数，如果没达到，那么producer会产生异常
  - Broker丢失数据
    - 首先是replication.factor配置参数，这个配置决定了副本的数量，默认是1。注意这个参数不能超过broker的数量
    - unclean.leader.election.enable参数设置为false，这个参数表示，当ISR集合中没有副本可以成为leader时，要不要从ISR之外的比较慢的副本选出leader，这样会导致丢失数据，虽然可以提高一些可用性，但是我们这里考虑的时精确一次消费，所以我们需要将这个参数置为false
  - 消费者丢失数据
    - 消费者丢失的情况，其实跟消费者offset处理不当有关。消费者消费的offset提交有一个参数，enable.auto.commit，默认是true，决定是否要让消费者自动提交位移。如果开启，那么consumer每次都是先提交位移，再进行消费。这样也会导致丢失数据（当消费者提交offset后，数据未消费完就挂了，但是offset的记录已经不对了，会导致重启后数据也找不到就丢失了）
    - 可以将enable.auto.commit设置为false，改为手动提交offset，消费完之后再提交offset信息。但是这样又有可能导致重复消费。毕竟exactly once处理一直是一个问题呀（/摊手）。遗憾的是kafka目前没有保证consumer幂等消费的措施，如果确实需要保证consumer的幂等，可以对每条消息维持一个全局的id，每次消费进行去重，当然耗费这么多的资源来实现exactly once的消费到底值不值，那就得看具体业务了。

* 这是无消息丢失的几个主要配置

  - producer的acks设置位-1，同时min.insync.replicas设置大于1。并且使用带有回调的producer api发生消息。
  - 默认副本数replication.factor设置为大于1，或者创建topic的时候指定大于1的副本数。
  - unclean.leader.election.enable 设置为false，防止定期副本leader重选举
  - 消费者端，自动提交位移enable.auto.commit设置为false。在消费完后手动提交位移。

* 实现Exactly需要的几个配置

  - 首先是开启幂等性

    - 在kafka中，幂等性意味着一个消息无论重复多少次，都会被当作一个消息来持久化处理。
    - 开启幂等性后，ack默认已经设置为-1了
    - 创建producer客户端的时候，添加这一行配置 ：props.put("enable.idempotence", ture)
    - 底层实现也很简单，就是对每条消息生成一个id值，broker会根据这个id值进行去重，从而实现幂等
    - 幂等性的缺陷：幂等性只能保证单个Producer对于同一个分区的Exactly Once语义
      - 幂等性的producer只能做到单分区上的幂等性，即单分区消息不重复，多分区无法保证幂等性
      - 只能保持单会话的幂等性，无法实现跨会话的幂等性，也就是说如果producer挂掉再重启，无法保证两个会话间的幂等（新会话可能会重发）。因为broker端无法获取之前的状态信息，所以无法实现跨会话的幂等。

  - 在幂等性缺陷无法解决的时候就要考虑使用事务了

    - 事务可以支持多分区的数据完整性，原子性。并且支持跨会话的exactly once处理语义，也就是说如果producer宕机重启，依旧能保证数据只处理一次。

    - 开启事务也很简单，首先需要开启幂等性，即设置enable.idempotence为true。然后对producer发送代码做一些小小的修改。

    - ````java
      //初始化事务
      producer.initTransactions();
      try {
          //开启一个事务
          producer.beginTransaction();
          producer.send(record1);
          producer.send(record2);
          //提交
          producer.commitTransaction();
      } catch (KafkaException e) {
          //出现异常的时候，终止事务
          producer.abortTransaction();
      }
      ````

    - 但无论开启幂等还是事务的特性，都会对性能有一定影响，这是必然的。所以kafka默认也并没有开启这两个特性，而是交由开发者根据自身业务特点进行处理。

    - 为了实现这种效果，应用程序必须提供一个稳定的（重启后不变）唯一的ID，也即Transaction ID。Transactin ID与PID可能一一对应。区别在于Transaction ID由用户提供，而PID是内部的实现对用户透明。另外，为了保证新的Producer启动后，旧的具有相同Transaction ID的Producer即失效，每次Producer通过Transaction ID拿到PID的同时，还会获取一个单调递增的epoch。由于旧的Producer的epoch比新Producer的epoch小，Kafka可以很容易识别出该Producer是老的Producer并拒绝其请求。

    - 跨Session的数据幂等发送。当具有相同Transaction ID的新的Producer实例被创建且工作时，旧的且拥有相同Transaction ID的Producer将不再工作。

      跨Session的事务恢复。如果某个应用实例宕机，新的实例可以保证任何未完成的旧的事务要么Commit要么死亡，使得新实例从一个正常状态开始工作。

  - 需要注意的是，上述的事务保证是从Producer的角度去考虑的。从Consumer的角度来看，该保证会相对弱一些。尤其是不能保证所有被某事务Commit过的所有消息都被一起消费

  - 原因

    - 对于压缩的Topic而言，同一事务的某些消息可能被其它版本覆盖

      事务包含的消息可能分布在多个Segment中（即使在同一个Partition内），当老的Segment被删除时，该事务的部分数据可能会丢失

      Consumer在一个事务内可能通过seek方法访问任意Offset的消息，从而可能丢失部分消息

      Consumer可能并不需要消费某一事务内的所有Partition，因此它将永远不会读取组成该事务的所有消息

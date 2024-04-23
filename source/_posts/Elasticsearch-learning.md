---
title: Elasticsearch_learning
date: 2024-04-15 11:54:01
tags:
- 大数据
categories:
- 大数据
index_img: https://tse1-mm.cn.bing.net/th/id/OIP-C.kGk4b5irwRgV11Ouu00AOQHaEC?w=293&h=180&c=7&r=0&o=5&pid=1.7
banner_img: https://tse1-mm.cn.bing.net/th/id/OIP-C.kGk4b5irwRgV11Ouu00AOQHaEC?w=293&h=180&c=7&r=0&o=5&pid=1.7
---

# Elasticsearch

* Elaticsearch，简称为es，**es是一个开源的高扩展的分布式全文检索引擎 **，它可以近乎实时的存储、检索数据；本身扩展性很好，可以扩展到上百台服务器，处理PB级别的数据。es也使用Java开发并使用 `Lucene` 作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的 RESTful API 来隐藏 Lucene 的复杂性，从而让全文搜索变得简单。**近实时搜索平台框架**
* Lucene是apache软件基金会的项目，**是一个开放源代码的全文检索引擎工具包**，但它不是一个完整的全文检索引擎，而是一个全文检索引擎的架构
* 类似的工具有`Solr`

* ELK
  * ELK是`Elasticsearch`、`Logstash`、`Kibana`三大开源框架首字母大写简称。市面上也被成为 ElasticStack 。
  * Elasticsearch 是一个基于 Lucene、分布式、通过 Restful 方式进行交互的**近实时搜索平台框架**。
  * Logstash是 ELK 的**中央数据流引擎**，用于从不同目标（文件/数据存储/MQ）收集的不同格式数据，经过过滤后支持输出到不同目的地（文件/MQ/redis/elasticsearch/kafka等）。
  * Kibana可以将 elasticsearch 的数据**通过友好的页面展示出来，提供实时分析的功能**。
*  **ELK 不仅仅适用于日志分析，它还可以支持其它任何数据分析和收集的场景，日志分析和收集只是更具有代表性，并非唯一性**。

## ES核心概念

* ES是面向文档的**非关系型数据库**
* elasticsearch(集群)中可以包含多个索引(数据库)，每个索引中可以包含多个类型(表)，每个类型下又包含多个文档(行)，每个文档中又包含多个字段(列)
* 文档
  - es是面向文档的，那么就意味着索引和收索数据的最小单位就是文档
* 类型
  - 类型是文档的逻辑容器，就像关系型数据库一样，表格是行的容器。
  - 类型中对于字段的定义称为映射，比如name映射为字符串类型
* 索引
  - 索引是映射类型的容器，es中的索引是一个非常大的文档集合。索引存储了映射类型的字段和其他设置。
* 物理设计
  - 一个es集群至少有一个节点，一个节点就是一个es进程，节点可以有多个索引。如果创建索引，那么索引将会有5个分片（primary shard，又称主分片）构成的，每一个主分片会有一个副本(replica shard，又称复制分片)
  - 一个分片是一个`lucene`索引，一个包含倒排索引的文件目录，倒排索引可以使es在不扫描全部文档的情况下，可以知道哪些文档包含特定的关键字。
* 倒排索引
  - elasticsearch 使用的是一种称为`倒排索引`的结构，采用`Lucene`倒排索引作为底层。这种结构适用于快速的全文搜索， 一个索引由文档中所有不重复的列表构成，对于每一个词，都有一个包含它的文档列表。

## 基础操作

### 分词

* IK分词器

  - 分词：即把一段中文或者别的内容划分成一个个的关键字，我们在搜索时候会把自己的信息进行分词，是因为数据库中或者索引库中的数据也会进行分词，然后进行一个匹配操作

  - `ik_max_word` 是**细粒度分词**，会穷尽一个语句中所有分词可能 `ik_smart` 是**粗粒度分词**，优先匹配最长词，不会有重复的数据

    ````shell
    GET _analyze
    {
      "analyzer":"ik_smart",
      "text": "梦想家"
    }
    
    GET _analyze
    {
      "analyzer":"ik_max_word",
      "text": "梦想家"
    }
    ````

### Rest风格

* **一种软件架构风格，而不是标准，只是提供了一组设计原则和约束条件。它主要用于客户端和服务器交互类的软件。基于这个风格设计的软件可以更简洁，更有层次，更易于实现缓存等机制**。
* RESTFUL是一种网络应用程序的设计风格和开发方式，**基于HTTP**，**可以使用 XML 格式定义或 JSON 格式定义**。最常用的数据格式是JSON。由于JSON能直接被JavaScript读取，所以，**使用JSON格式的REST风格的API具有简单、易读、易用的特点**。



### 增删改查操作

* 创建一个索引

  - PUT /索引名/类型名/文档id {请求id}

  - ````shell
    # 命令解释 
    # PUT 创建命令 test1 索引 type1 类型 1 id
    PUT /test1/type1/1
    {
      "name":"大数据梦想家",
      "age":21
    }
    get /test1
    #查看test1 的结构，我们没有指定文档字段类型，但是es会默认配置类型
    
    get _cat/health
    #查看集群的健康情况
    ````

  - put创建索引，并设置字段类型

    ````shell
    PUT /test2
    {
      "mappings": {
        "properties": {
          "name":{
            "type":"text"
          },
          "age":{
            "type":"long"
          },
          "birthday":{
            "type":"date"
          }
        }
      }
    }
    
    PUT /test3/_doc/1
    {
      "name":"大数据梦想家",
      "age":21,
      "birthday":"2000-02-06"
    }
    ````

  - 更新数据

    ````shell
    PUT /test3/_doc/1
    {
      "name":"大数据梦想家",
      "age":21,
      "birthday":"2000-02-06"
    }
    # 这种put方式更新数据，如果遗漏了字段，那么数据就会被新数据覆盖，一般不用这种方式更新数据
    
    #可以用post的方式，update数据
    post /test3/_doc/1/_update
    {
      "doc":{
        "age":24
      }
    }
    
    
    ````

  - 删除索引

    ````shell
    #delete语句删除索引
    delete test3
    ````

* 查询数据

  - 先创建一个索引，并添加一些样例数据

  - ````shell
    PUT /alice/user/1
    {
      "name":"爱丽丝",
      "age":21,
      "desc":"在最美的年华，做最好的自己！",
      "tags":["技术宅","温暖","思维活跃"]
    }
    
    PUT /alice/user/2
    {
      "name":"张三",
      "age":23,
      "desc":"法外狂徒",
      "tags":["渣男","交友"]
    }
    
    PUT /alice/user/3
    {
      "name":"路人甲",
      "age":24,
      "desc":"不可描述",
      "tags":["靓仔","网游"]
    }
    
    
    PUT /alice/user/4
    {
      "name":"爱丽丝学Java",
      "age":25,
      "desc":"技术成就自我！",
      "tags":["思维敏捷","喜欢学习"]
    }
    
    PUT /alice/user/5
    {
      "name":"爱丽丝学Python",
      "age":26,
      "desc":"人生苦短，我用Python！",
      "tags":["好学","勤奋刻苦"]
    }
    ````

  - 

  - ````shell
    # 搜索到指定 id 的文档信息
    get alice/user/1
    # 条件查询_search?q=
    # 一般不用这种方式
    GET alice/user/_search?q=name:爱丽丝
    
    # 查询
    get alice/user/_search
    {
      "query":{
        "match": {
          "name": "张三"
        }
      }
    }
    #展示想要的字段，指定字段即可
    get alice/user/_search
    {
      "query":{
        "match": {
          "name": "张三"
        }
      },
      "_source":["name","age"]
    }
    ````

  - 排序查询

    ````shell
    # 排序查询，可以指定from(开始位置)，size(几条数据)
    GET alice/user/_search
    {
      "query":{
        "match": {
          "name": "爱丽丝"
        }
      },
      "sort": [
        { 
          "age": { 
            "order": "asc"
          }
         }
       ],
       "from":0,
       "size": 2
    }
    ````

    - 排序支持的属性
      - 数字
      - 日期
      - ID

  - 分页查询

    ````shell
    # 学到这里，我们也可以看到，我们的查询条件越来越多，开始仅是简单查询，慢慢增加条件查询，增加排序，对返回结果进行限制。所以，我们可以说，对 于 elasticsearch 来说，所有的查询条件都是可插拔的。比如说，我们在查询中，仅对返回结果进行限制:
    
    GET alice/user/_search
    { 
      "query":
      {"match_all": {}
      },
      "from":0,  # 从第n条开始
      "size":4   # 返回n条数据
      }
    ````

  - 布尔查询

    ````shell
    # 多条件查询
    #通过bool属性内使用must来作为查询条件
    GET alice/user/_search
    {
      "query":{
        "bool": {
          "must":[
             {
              "match":{
              "name":"爱丽丝"
             }
          },
          {
            "match":{
              "age":25
              }
            }
          ]
        }
      }
    }
    #查询条件1或条件2
    #should
    GET alice/user/_search
    {
      "query":{
        "bool": {
          "should":[
             {
              "match":{
              "name":"爱丽丝"
             }
          },
          {
            "match":{
              "age":25
              }
            }
          ]
        }
      }
    }
    #查询不是的条件：must_not
    GET alice/user/_search
    {
      "query":{
        "bool": {
          "must_not":[
          {
            "match":{
              "age":25
              }
            }
          ]
        }
      }
    }
    
    
    ````

  - filter过滤

    ````shell
    #filter进行数据过滤
    #查询名称为爱丽丝，年龄>=10and年龄<=25
    get alice/user/_search
    {
      "query":{
        "bool":{
          "must":[
            {
              "match":{
                "name":"爱丽丝"
              }
            }
            ],
          "filter": [
            {"range": {
              "age": {
                "gte": 10,
                "lte": 25
              }
            }}
          ]
        }
      }
    }
    #gt表示大于
    #gte表示大于等于
    #lt表示小于
    #lte表示小于等于
    ````

  - 短语检索

    ````shell
    #查询tags中包含"男"的数据
    GET alice/user/_search
    {
      "query":{
        "match":{
          "tags":"男"
        }
      }
    }
    #匹配多个标签
    GET alice/user/_search
    {
      "query":{
        "match":{
          "tags":"男 女"
        }
      }
    }
    ````

  - 精确查询

    ````shell
    #term查询是直接通过倒排索引指定的词条进程精确查找的
    #term,不经过分词，直接查询精确的值
    #match,会使用分词器解析(先分析文档，然后再通过分析的文档进行查询)
    # 创建一个索引，并指定类型
    PUT testdb
    {
      "mappings": {
        "properties": {
        
          "name":{
            "type": "text"
          },
        "desc":{
          "type":"keyword"
         }
        }
      }
    }
    
    # 插入数据
    PUT testdb/_doc/1
    {
      "name":"爱丽丝学大数据name",
      "desc":"爱丽丝学大数据desc"
    }
    
    PUT testdb/_doc/2
    {
      "name":"爱丽丝学大数据name2",
      "desc":"爱丽丝学大数据desc2"
    }
    # keyword类型不会被分析器处理
    GET _analyze
    {
      "analyzer": "keyword",
      "text": "爱丽丝学大数据 name"
    }
    # text 会被分析器分析 查询
    GET _analyze
    {
      "analyzer": "standard",
      "text": "爱丽丝学大数据 name"
    }
    
    # text 会被分析器分析 查询
    #通过查询可以验证
    #name是text类型，会被分析器分析，可以查出两条数据
    GET testdb/_search         
    {
      "query": {
        "term": {
            "name": "爱"
          }
        }
    }
    # keyword 不会被分析所以直接查询 
    #desc是keyword类型,不会被分析器分析，要完全匹配才可查出数据
    GET testdb/_search          
    {
      "query": {
        "term": {
            "desc": "爱丽丝学大数据desc"
          }
        }
    }
    
    ````

    - 分词解析器
      - **keyword 字段类型不会被分析器分析**

  - 查找多个精确值

    ````shell
    #插入一些测试数据
    PUT testdb/_doc/3
    {
      "t1":"22",
      "t2":"2021-03-01"
    }
    
    PUT testdb/_doc/4
    {
      "t1":"33",
      "t2":"2021-03-01"
    }
    #查询t1=22 or t1=23的数据
    GET testdb/_search
    {
      "query": {
        "bool":{
          "should": [
            {
              "term": {
                "t1":"22"
              }
            },
            {
              "term": {
                "t1":"33"
              }
            }
          ]
        }
      }
    }
    #可以证明：就算是term精确查询，也能够查询多个值。
    
    #也可以直接用这种替代
    GET testdb/_doc/_search
    {
      "query":{
        "terms":{
          "t1":["22","33"]
        }
      }
    }
    ````

* 高亮显示

  - 设置highlight属性，对查询的结果的指定字段做高亮显示

  - ````shell
    #观察返回的结果，我们可以发现搜索相关的结果，被加上了高亮标签<em>
    GET alice/user/_search
    {
      "query":{
         "match": {
           "name": "爱丽丝"
         }
      },
      "highlight":{
        "fields": {
          "name": {}
        }
      }
    }
    
    #自定义样式
    GET alice/user/_search
    {
      "query":{
         "match": {
           "name": "爱丽丝"
         }
      },
      "highlight":{
        "pre_tags": "<b class='key' style='color:red'>", 
        "post_tags": "</b>",
        "fields": {
          "name": {}
        }
      }
    }
    ````

#### 字段类型

* 字符串类型
  - **text,keyword**
* 数值类型
  - **long,integer,short,byte,double,float,half_float,scaled_float**
* 日期类型
  - **date**
* 布尔值类型
  - **boolean**
* 二进制类型
  - **binary**
* 还有一些其他的类型参考[链接](https://zhuanlan.zhihu.com/p/136981393)


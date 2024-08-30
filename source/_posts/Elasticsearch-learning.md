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
* [参考链接1](https://zhuanlan.zhihu.com/p/358744225)
* [参考链接2](https://www.cnblogs.com/chenhuabin/p/13800715.html)
* [参考链接3](https://learnku.com/docs/elasticsearch73/7.3/data-in-documents-and-indices/6446)

## ES核心概念

* ES是面向文档的**非关系型数据库**

* elasticsearch(集群)中可以包含多个索引(数据库)，每个索引中可以包含多个类型(表)，每个类型下又包含多个文档(行)，每个文档中又包含多个字段(列)

* ``GET /zt_test/_doc/2``

  - zt_test：index的概念：**索引是文档(Document)的容器，是一类文档的集合。**三种意思：

    - 索引（名次）：相当于关系型数据库中的(database),索引由其名称(**必须为全小写字符**)进行标识
    - 索引（动词）：保存一个文档到索引（名词）的过程。类似于sql中的insert或update
    - 倒排索引：关系型数据库通过给某个字段增加一个b+树索引到指定的列，提升检索速度。es使用了一个叫做倒排索引的结构来达到相同的目的。

  - _doc：type的概念

    - 之前的版本中，索引和文档中间还有个类型的概念，每个索引下可以建立多个类型，文档存储时需要指定index和type。从6.0.0开始单个索引中只能有一个类型，

      7.0.0以后将将不建议使用，8.0.0 以后完全不支持。

      ##### 弃用该概念的原因：

      我们虽然可以通俗的去理解Index比作 SQL 的 Database，Type比作SQL的Table。但这并不准确，因为如果在SQL中,Table 之前相互独立，同名的字段在两个表中毫无关系。

      但是在ES中，同一个Index 下不同的 Type 如果有同名的字段，他们会被 Luecence 当作同一个字段 ，并且他们的定义必须相同。所以我觉得Index现在更像一个表，

      而Type字段并没有多少意义。目前Type已经被Deprecated，在7.0开始，一个索引只能建一个Type为`_doc`

  - 2:document的概念

    - `Document` Index 里面单条的记录称为Document（文档）。**等同于关系型数据库表中的行**。

* 文档

  - es是面向文档的，那么就意味着索引和收索数据的最小单位就是文档

* 类型

  - 类型是文档的逻辑容器，就像关系型数据库一样，表格是行的容器。

  - 类型中对于字段的定义称为映射，比如name映射为字符串类型

  - `Type` 可以理解成关系数据库中Table。

    之前的版本中，索引和文档中间还有个类型的概念，每个索引下可以建立多个类型，文档存储时需要指定index和type。从6.0.0开始单个索引中只能有一个类型，

    7.0.0以后将将不建议使用，8.0.0 以后完全不支持。

    ##### 弃用该概念的原因：

    我们虽然可以通俗的去理解Index比作 SQL 的 Database，Type比作SQL的Table。但这并不准确，因为如果在SQL中,Table 之前相互独立，同名的字段在两个表中毫无关系。

    但是在ES中，同一个Index 下不同的 Type 如果有同名的字段，他们会被 Luecence 当作同一个字段 ，并且他们的定义必须相同。所以我觉得Index现在更像一个表，

    **而Type字段并没有多少意义。目前Type已经被Deprecated，在7.0开始，一个索引只能建一个Type为`_doc`**

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
    #type的概念已经被高版本弃用，不在使用，写成_doc即可
    PUT /test1/type1/1
    {
      "name":"大数据梦想家",
      "age":21
    }
    # 也可以创建一个索引，_id会自动生成一个
    POST /zt_test/_doc/
    {
      "name":"dcx",
      "age":3208
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
    
    #查看索引结构
    GET /索引名/_mapping?pretty
    GET /patent_index/_mapping?pretty
    
    #根据查到的结构创建索引
    #settings可以设置一些配置参数
    #number_of_shards：分片数量（按机器节点数量计算，创建后不能更改）
    #number_of_replicas：副本数量
    PUT comprehensive_suggest_predict_v3_zt
    {
      "settings": {
        "number_of_shards": 6,
        "number_of_replicas": 1
      }, 
        "mappings" : {
          "properties" : {
            "title" : {
              "type" : "completion",
              "analyzer" : "standard",
              "preserve_separators" : true,
              "preserve_position_increments" : true,
              "max_input_length" : 50,
              "contexts" : [
                {
                  "name" : "tag",
                  "type" : "CATEGORY"
                }
              ]
            }
          }
        }
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
    # 指定id删除
    DELETE policy_project_library_index/_doc/1827261404195741698
    ````

* 查询数据

  - 先创建一个索引，并添加一些样例数据

  - 全匹配查询：``GET book/_search``

    - ````shell
      # 全匹配查询
      GET book/_search
      {
        "query": {
          "match_all": {}
        }
      }
      #size设置分页查询
      GET book/_search
      {
        "query": {
          "match_all": {}
        },
        "size": 100
      }
      
      ````

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
    
    #exists关键字存在
    # 存在age字段的数据
    GET alice/user/_search
    {
      "query":{
        "bool": {
          "must_not":[
          {
            "exists":{
              "field":"age"
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
    #range查询
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

  - ````shell
    PUT my_index
    {
      "mappings": {
        "_doc": {
          "properties": {
            "date": {
              "type": "date" 
            }
          }
        }
      }
    }
    
    PUT my_index/_doc/1
    { "date": "2015-01-01" } 
    
    PUT my_index/_doc/2
    { "date": "2015-01-01T12:10:30Z" } 
    
    PUT my_index/_doc/3
    { "date": 1420070400001 } 
    
    GET my_index/_search
    {
      "sort": { "date": "asc"} 
    }
    #es的date类型支持多种格式，上面的添加数据都可以
    #也可以指定格式
    PUT my_index
    {
      "mappings": {
        "_doc": {
          "properties": {
            "date": {
              "type":   "date",
              "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
            }
          }
        }
      }
    }
    #规定格式后，新增的数据必须符合这个格式，不然就会跑错
    ````

  - 可用的格式

    - yyyy-MM-dd HH:mm:ss
    - yyyy-MM-dd
    - epoch_millis (毫秒值)

* 布尔值类型

  - **boolean**

* 二进制类型

  - **binary**

* 复杂类型

  - Array

    - 在Elasticsearch中，**数组不需要专用的字段数据类型**。默认情况下，**任何字段都可以包含零个或多个值**，但是，数组中的所有值都**必须具有相同的数据类型。**

  - object

    - **object类型的字段，也可以有多个值**，形成List<object>的数据结构。

    - **object不允许彼此独立地索引查询**

    - ````shell
      # 添加 属性为object的字段 field3
      PUT toherotest/_mapping/_doc 
      {
        "properties": {
          "field3": {
            "type": "object"
          }
        }
      }
      # 新增数据
      POST /toherotest/_doc/3
      {
        "field3":[ { "name":"tohero1", "age":1 }, { "name":"tohero2", "age":2 } ]
      }
        
      POST /toherotest/_doc/4
      {
        "field3": [ { "name":"tohero1", "age":2 }, { "name":"tohero2", "age":1 } ]
      }
      
      #执行查询语句 
      GET /toherotest/_doc/_search
      {
        "query": {
          "bool": {
            "must": [
              {
                "term": {
                  "field3.name": "tohero1"
                }
              },
              {
                "term": {
                  "field3.age": 1
                }
              }
            ]
          }
        }
      }
      
      #查询结果
      {
        "took": 2,
        "timed_out": false,
        "_shards": {
          "total": 5,
          "successful": 5,
          "skipped": 0,
          "failed": 0
        },
        "hits": {
          "total": 2,
          "max_score": 1.287682,
          "hits": [
            {
              "_index": "toherotest",
              "_type": "_doc",
              "_id": "4",
              "_score": 1.287682,
              "_source": {
                "field3": [
                  {
                    "name": "tohero1",
                    "age": 2
                  },
                  {
                    "name": "tohero2",
                    "age": 1
                  }
                ]
              }
            },
            {
              "_index": "toherotest",
              "_type": "_doc",
              "_id": "3",
              "_score": 1.287682,
              "_source": {
                "field3": [
                  {
                    "name": "tohero1",
                    "age": 1
                  },
                  {
                    "name": "tohero2",
                    "age": 2
                  }
                ]
              }
            }
          ]
        }
      }
      
      #可以看到，两条数据都出来了
      #得出结论：object不允许彼此独立地索引查询
      ````

    - 如果希望object能被独立的索引，可以考虑nested类型

  - nested

* GEO地理位置类型

  - 地图：Geo-point   （web开发常用地图类型）

  - 形状：Geo-shape

  - ````shell
    #案例
    PUT my_index
    {
      "mappings": {
        "_doc": {
          "properties": {
            "location": {
              "type": "geo_point"
            }
          }
        }
      }
    }
    
    PUT my_index/_doc/1
    {
      "text": "Geo-point as an object",
      "location": { 
        "lat": 41.12,
        "lon": -71.34
      }
    }
    
    PUT my_index/_doc/2
    {
      "text": "Geo-point as a string",
      "location": "41.12,-71.34" 
    }
    
    PUT my_index/_doc/3
    {
      "text": "Geo-point as a geohash",
      "location": "drm3btev3e86" 
    }
    
    PUT my_index/_doc/4
    {
      "text": "Geo-point as an array",
      "location": [ -71.34, 41.12 ] 
    }
    
    #查询某个点方圆200km
    GET /my_locations/_search
    {
        "query": {
            "bool" : {
                "must" : {
                    "match_all" : {}
                },
                "filter" : {
                    "geo_distance" : {
                        "distance" : "200km",
                        "pin.location" : {
                            "lat" : 40,
                            "lon" : -70
                        }
                    }
                }
            }
        }
    }
    ````

  - 

* 还有一些其他的类型参考[链接](https://zhuanlan.zhihu.com/p/136981393)



### 创建别名

- **创建别名有很多种方法，可以创建索引同时创建别名，也可以在创建索引后创建，既可以让别名指向多个索引，也可以让别名指向一个索引的部分数据，甚至指向一个字段**

- 合理的使用别名可以方便进行索引的更新切换

  ````shell
  #创建一个索引进行测试
  PUT /zt_user/_doc/1
  {
    "birth-year":2000
  }
  
  
  PUT /zt_user/_doc/2
  {
    "birth-year":2001
  }
  
  PUT /zt_user/_doc/3
  {
    "birth-year":2004
  }
  
  
  # zt_user2
  PUT /zt_user2/_doc/1
  {
    "birth-year":2000
  }
  ````

  

- **创建索引同时创建别名**

  - ````shell
    
    #创建一个索引，并同时创建别名
    #一个名叫myusers的索引，直接指向zt_user
    #一个名叫2000的索引，过滤birth-year=2000的数据
    PUT /zt_user
    {
      "mappings": {
        "properties": {
          "birth-year":{
            "type": "integer"
          }
        }
      },
      "aliases": {
        "myusers": {},
        "2000":{
          "filter": {
            "term": {
              "birth-year": 2000
            }
          }
        }
      }
    }
    ````

- **创建索引后创建别名**

  - ````shell
    # 创建一个名为2004的别名，过滤birth-year=2004的数据
    PUT /zt_user/_alias/2004 
    {
      "filter": {
        "term": {
          "birth-year": 2004
        }
      }
    }
    ````

- **创建字段别名**

  - ````shell
    # 字段设置别名，例如为username设置一个别名为name
    PUT /zt_user1
    {
      "mappings": {
        "properties": {
          "username":{
            "type": "keyword"
          },
          "name":{
            "type":"alias",
            "path":"username"
        }
        }
      }
    }
    ````

### 修改删除别名

* **为同一索引创建多个别名**

  - ````shell
    # 创建别名
    POST /_aliases
    {
      "actions": [
        {
          "add": {
            "index": "zt_user",
            "alias": "zt_user_copy1"
          }
        },
        {
          "add": {
            "index": "zt_user",
            "alias": "zt_user_copy2"
          }
        }
      ]
    }
    ````

  - 

* **删除一个别名**

  - ````shell
    #删除一个别名
    POST /_aliases
    {
      "actions": [
        {
          "remove": {
            "index": "zt_user",
            "alias": "zt_user_copy2"
          }
        }
      ]
    }
    ````

* **重命名一个别名**

  - 重命名操作，先remove再执行add，而且这一操作是原子操作

  - ````shell
    POST /_aliases
    {
      "actions": [
        {
          "remove": {
            "index": "zt_user",
            "alias": "zt_user_copy1"
          }
        },
        {
          "add": {
            "index": "zt_user",
            "alias": "zt_user_copy2"
          }
        }
      ]
    }
    ````

* **创建一个别名指向多个索引**

  - ``indices``:index的复数

  - ````shell
    POST /_aliases
    {
      "actions": [
        {
          "add": {
            "indices": ["zt_user","zt_user2"],
            "alias": "zt_user_copy"
          }
        }
      ]
    }
    ````

  - 

* **创建有过滤条件的别名**

  - ````shell
    POST /_aliases
    {
      "actions": [
        {
          "add": {
            "index": "zt_user",
            "alias": "zt_user_copy",
            "filter": {"term": { "birth-year":2000 }}
          }
        }
      ]
    }
    ````

* **创建可写入别名**

  - 如果一个别名单独指向一个索引，那么使用别名进行写入操作是不会有问题的，但是，一个别名指向多个索引时，是不能进行写入操作的，因为es不知道将文档写入到哪一个索引。**可以在创建别名时设置为可写来解决问题**

  - 尽量不要这么弄吧，感觉很乱qaq...

  - ````shell
    POST /_aliases
    {
      "actions": [
        {
          "add": {
            "index": "zt_user",
            "alias": "zt_user_copy",
            "is_write_index":true
          }
        },
        {
          "add": {
            "index": "zt_user2",
            "alias": "zt_user_copy"
          }
        }
      ]
    }
    ````

  - 

### 查看别名信息

* **查看别名是否存在**
  - ``HEAD /_alias/myusers``
* **查看别名信息**
  - ``GET /_cat/aliases/myusers`` 查看指定别名
  - ``GET /_cat/aliases``查看集群中所有别名

### 聚合（Aggregations）

* 聚合框架有助于基于搜索查询提供聚合数据。它基于称为聚合的简单构建块，可以进行组合以构建复杂的数据摘要。

* 列一些比较常见的聚合查询

  ````shell
  # 过滤数据一部分数据
  # 利用聚合aggs:求project_money的平均值
  POST /policy_enterprise_detail_all/_search
  {
    "size": 0,
    "query": {
      "bool": {
        "must": [
          {"match": {
            "city_id": "4401"
          }}
        ]
      }
    }, 
    "aggs": {
      "avg_money": {
        "avg": {"field": "project_money"}
      }
    }
  }
  ````

  - 地理边界聚合

    ````shell
    PUT /museums
    {
        "mappings": {
            "properties": {
                "location": {
                    "type": "geo_point"
                }
            }
        }
    }
    
    POST /museums/_bulk?refresh
    {"index":{"_id":1}}
    {"location": "52.374081,4.912350", "name": "NEMO Science Museum"}
    {"index":{"_id":2}}
    {"location": "52.369219,4.901618", "name": "Museum Het Rembrandthuis"}
    {"index":{"_id":3}}
    {"location": "52.371667,4.914722", "name": "Nederlands Scheepvaartmuseum"}
    {"index":{"_id":4}}
    {"location": "51.222900,4.405200", "name": "Letterenhuis"}
    {"index":{"_id":5}}
    {"location": "48.861111,2.336389", "name": "Musée du Louvre"}
    {"index":{"_id":6}}
    {"location": "48.860000,2.327000", "name": "Musée d'Orsay"}
    
    #地理边界聚合
    POST /museums/_search?size=0
    {
        "query" : {
            "match" : { "name" : "musée" }
        },
        "aggs" : {
            "viewport" : {
                "geo_bounds" : {
                    "field" : "location", 
                    "wrap_longitude" : true 
                }
            }
        }
    }
    
    #地理重心聚合
    POST /museums/_search?size=0
    {
        "aggs" : {
            "centroid" : {
                "geo_centroid" : {
                    "field" : "location" 
                }
            }
        }
    }
    
    
    ````

  - 最大聚合

    ````shell
    POST /sales/_search?size=0
    {
        "aggs" : {
            "max_price" : { "max" : { "field" : "price" } }
        }
    }
    ````

  - 最小聚合

    - `min`

  - 计数

    - ``value_count``

  - 统计聚合

    - `多值`指标聚合，可根据从聚合文档中提取的数值计算统计信息。这些值可以从文档中的特定数字字段中提取，也可以由提供的脚本生成。

    - 返回的信息包括`min`，`max`，`sum`，`count` 和 `avg`。

    - ````shell
      POST /exams/_search?size=0
      {
          "aggs" : {
              "grades_stats" : { "stats" : { "field" : "grade" } }
          }
      }
      ````

  - 过滤器聚合

    ````shell
    POST /sales/_search?size=0
    {
        "aggs" : {
            "t_shirts" : {
                "filter" : { "term": { "type": "t-shirt" } },
                "aggs" : {
                    "avg_price" : { "avg" : { "field" : "price" } }
                }
            }
        }
    }
    ````

### 常用操作

````shell
#  查询数据量
# 根据etl_time聚合数量
GET policy_index_all/_search
{
  "size": 0,
  "aggs": {
    "by_etltime": {
      "terms": {
        "field": "etl_time"  
      },
      "aggs": {
        "docs_count": {
          "value_count": {
            "field": "_id" 
          }
        }  
      }
    }
  }
}


#直接查询所有数量
GET policy_index_all/_search
{
  "size": 0, 
  "aggs": {
    "total_docs": {
      "value_count": {
        "field": "_id"
      }
    }
  }
}



#删除数据
# 删除小于yyyy-MM-dd的数据
POST policy_index_all/_delete_by_query
{
  "query": {
    "range": {
      "etl_time": {
        "lt": "2023-12-04"
      }
    }
  }
}

#删除etl_time为空的
#删除etl_time不存在的数据
POST policy_index_all/_delete_by_query
{
  "query": {
    "bool": {
      "must_not": {
        "exists": {
          "field": "etl_time"
        }
      }
    }
  }
}

#查询数据
#term,不经过分词，直接查询精确的值
#match,会使用分词器解析(先分析文档，然后再通过分析的文档进行查询)
#includes指定字段
GET enterprise_data_index_all_v8/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "eid": {
              "value": "4c8bd41b-2534-43c0-8643-5bf4dca1991e"
            }
          }
        },
        {
          "match": {
            "new_status_code": "1"
          }
        }
      ]
    }
  },
  "_source": {
    "includes": [
      "name",
      "granted_invent_num",
      "granted_appearance_num",
      "grant_utility_model_num"
    ]
}
}
````


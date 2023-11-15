---
title: project_summarize
date: 2023-02-08 10:58:16
tags:
- 项目总结
hide: true
categories:
- 复盘
index_img: https://pic2.zhimg.com/v2-5b5bf59a17d6947d72b22b358b6805ca_r.jpg
banner_img: https://pic2.zhimg.com/v2-5b5bf59a17d6947d72b22b358b6805ca_r.jpg
---

# 项目总结

## 杭州东站智慧枢纽项目

### 项目背景意义

* 浙江省数字化改革背景下进行的数字化，标准化项目
* 对杭州东站这个综合枢纽来说，数字化具有重大意义，从几个大板块出发，智慧防疫，舆情预警，气象防灾，消防。治安，交通等方面进行数字化的统计，预警

### 我的工作内容

* 对**孪生，看板的指标进行编写**，主要是智慧防疫看板相关的，还有日常对孪生，看板SQL进行维护。后面针对查询较慢的相关**SQL进行相对应的优化**，负责优化的板块如防疫，出租车，数据标牌等板块速度基本都优化到0.0几秒，编写一些存储过程，提高查询速度，其中对于相同类似的指标，将**存储过程**制作成一张大表，多个查询union all 起来，提升查询速度
* MySQL数据库的操作，**Python脚本编写** ，这里做一个重点的总结，脚本分为数据监控脚本，数据同步脚本  
* 几个典型的指标
  - 重点人员指标
    - 解除隔离人数
    - 健康码异常人数
    - 行程卡带星人数
    - 密接人数
    - 次密接人数
    - 体温异常
  - 疫情态势
    - 现有确诊人数
    - 今日新增
    - 中高风险地区数

#### 数据监控脚本

* 钉钉群自建机器人
* 钉钉机器人文档链接：https://open.dingtalk.com/document/robots/customize-robot-security-settings#title-jk6-ksi-zur

- 自定义告警机器人有三种安全设置

  - 自定义关键词

    - 最多可以设置10个关键词，消息中至少包含其中1个关键词才可以发送成功。

      例如添加了一个自定义关键词：**监控报警**，则这个机器人所发送的消息，必须包含**监控报警**这个词，才能发送成功。

  - 加签

    - 把`timestamp+"\n"+`密钥当做签名字符串，使用HmacSHA256算法计算签名，然后进行Base64 encode，最后再把签名参数再进行urlEncode，得到最终的签名（需要使用UTF-8字符集）。

    ````python
    #python 3.8
    import time
    import hmac
    import hashlib
    import base64
    import urllib.parse
    
    timestamp = str(round(time.time() * 1000))
    secret = 'this is secret'
    secret_enc = secret.encode('utf-8')
    string_to_sign = '{}\n{}'.format(timestamp, secret)
    string_to_sign_enc = string_to_sign.encode('utf-8')
    hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
    sign = urllib.parse.quote_plus(base64.b64encode(hmac_code))
    print(timestamp)
    print(sign)
    ````

  - IP地址段

    - 设定后，只有来自IP地址范围内的请求才会被正常处理。支持两种设置方式：IP地址和IP地址段，暂不支持IPv6地址白名单，格式如下。

- 监控脚本思路原理

  - 需要监控数据库各类表的同步情况，根据表中的数据更新时间，先编写一个SQL

    ````sql
    (
    select
    '信令' as type,
    'yxl_region_person_count' as tb,
    case when date_format(time,'%Y%m%d%H') =date_format(now(),'%Y%m%d%H') then 0 else 1 end as value
    from yxl_region_person_count order by time desc limit 1)
    union all
    
    (
    select
    '公交' as type,
    'gjd_bus_line' tb,
    case when date_format(sync_time,'%Y%m%d%H') =date_format(now(),'%Y%m%d%H') then 0 else 1 end  as value
    from gjd_bus_line order by sync_time desc limit 1 )  
    ````

    * 查询后得出结果是三个字段
      - 表所属类型
      - 表名
      - 数据中断情况，根据实际情况，判断近十分钟，近1小时有无最新数据同步过来

  - 根据SQL的结果，可以通过钉钉机器人，实现一个数据监控并发送告警信息的功能

    ````python
    import requests
    import json
    import datetime
    import pandas as pd
    import pymysql
    import hmac
    import hashlib
    import base64
    import urllib.parse
    from time import time
    # import time
    from sqlalchemy import create_engine
    class dingdingSendFile():
        def __init__(self):
            self.host = '10.18.155.174'
            self.port = '10018'
            self.database = 'hzdzwlsn'
            self.user = 'hzdzwlsn'
            self.password = 'B4oysCev'
            self.cur_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        def getMysqlData(self):
            '''
            engine = create_engine('dialect+driver://username:password@host:port/database')
            dialect -- 数据库类型
            driver -- 数据库驱动选择
            username -- 数据库用户名
            password -- 用户密码
            host 服务器地址
            port 端口
            database 数据库
            :return:
            '''
            # 创建一个MySQL连接引擎
            engine = create_engine(str(r"mysql+pymysql://%s:" + '%s' + "@%s:%s/%s")%(self.user,self.password,self.host,self.port,self.database))
            # 打开一个文件，创建一个file对象
            sql = open("/root/check/check_sql", 'r', encoding='utf8')
            # 返回文件中所有的行，返回一个列表
            sqltxt = sql.readlines()
            sql.close()
            #join()方法获取迭代对象中的所有项目，并将他们连接为一个字符串，必须将字符串指定为分隔符
            sqlresult = "".join(sqltxt)
            #执行SQL返回DataFrame
            result = pd.read_sql(sqlresult,engine)
            values = result.values.tolist()
            # print(values)
            # 筛选结果非0的告警数据类型
            res = ''
            for v in values:
                # global li
                if v[2] > 0:
                    msg='{}:{} 数据中断'.format(v[0], v[1])
                    res=msg+'\n'+res
    
            return res
    
    
        #钉钉机器人采用加签的安全告警方式
        def get_digest(self):
            timestamp = str(round(time() * 1000))
            secret = 'SEC3ddf16441eb4d5b41876efe272a56f22bc8cc2031056f644f9799a6cf57c30e6'
            secret_enc = secret.encode('utf-8')
            string_to_sign = '{}\n{}'.format(timestamp, secret)
            string_to_sign_enc = string_to_sign.encode('utf-8')
            hmac_code = hmac.new(secret_enc, string_to_sign_enc, digestmod=hashlib.sha256).digest()
            sign = urllib.parse.quote_plus(base64.b64encode(hmac_code))
            return f"&timestamp={timestamp}&sign={sign}"
    
        # 告警配置
        def warning_bot(self,content,digest):
            data = {
                "msgtype": "text",
                "text": {"content": content + '\n'},
            }
            webhook_url = 'https://oapi.dingtalk.com/robot/send?access_token=f192be73e7a6bd5c69b5766174ce4c38e20abb9219a2963a02f2feb05c2b9d9b'
            #发送post请求
            req = requests.post(webhook_url + digest, json=data)
    
        def run(self):
            try:
                res = self.getMysqlData()
                digest = self.get_digest()
                self.warning_bot(res,digest)
                print('成功')
            except Exception :
                print()
                print('失败')
    
    
    if __name__ == '__main__':
        instance = dingdingSendFile()
        instance.run()
    ````

    

#### 数据同步脚本

* 数据同步脚本，主要实现几个数据库之间的数据同步，从其他部门数据库获取数据到东站的Mysql数据库，或者会有一些数据要同步到浙江省数字化平台IRS上，通过几个数据同步脚本实现数据的拉取与推送

* 案例

  ````python
  # title       :  data_sync
  #description  :  同步数据mysqlTomysql,任务异常同步到钉钉群里
  #author       :  zt
  #email        :  zoutao3019@qq.com
  #date         :  2021-10-14 12:00:00
  #version      :  1.0
  #usage        :  python3 MysqlDataExpImpStand.py
  #Question     :  数据落盘csv内存不足
  #python_version: 3.6.2
  #======================================================================================================================================================================================
  #中控数据转移到外网的rds 每小时同步一次
  import pymysql
  import pandas as pd
  from sqlalchemy import create_engine
  import time
  from tqdm import tqdm
  import os
  import datetime
  import sys
  import requests
  import json
  
  class mysqlToMysqlDataPro():
      def __init__(self):
  
          self.path = '/root/sync_ds_data/data/'
          self.mehost = '10.18.155.174'
          self.meport = 10018
          self.meuser = 'hzdzwlsn'
          self.mepassword = 'B4oysCev'
          self.medatabase = 'hzdzwlsn'
          #self.mehost = 'rm-bp161be65d56kbt4nzo.mysql.rds.aliyuncs.com'
          #self.meport = 3306
          #self.meuser = 'dsother'
          #self.mepassword = 'ds123456#'
          #self.medatabase = 'mysqldb'
          self.metableName = 'database_configuration_to_data_production'
          self.today = str(datetime.datetime.strptime(datetime.datetime.now().strftime("%Y-%m-%d"), "%Y-%m-%d"))
          self.access_token = '4243c07db294621c70236b514d66c3ee2bb293710b2fd241c60c978b048be7bd'
  
      # TODO 获取当前时间
      def get_curtime(self):
          """
          获取当前时间
          :return: yyyy-mm-dd hh:mm:ss
          """
          return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
  
  
      # TODO 获取连接
      def get_connect(self,host,port,user,password,database):
          """
          获取mysql连接
          :return: yyyy-mm-dd hh:mm:ss
          """
          _number = 0
          while _number <= 4:
              try:
                  db_conn = pymysql.connect(host=host, port=port, user=user, password=password, database=database)
                  return db_conn
              except:
                  _number += 1
                  print('尝试第{}次连接！'.format(_number),end='')
                  time.sleep(15)
          print('尝试连接失败！程序退出')
  
      # TODO 获取配置文件
      def get_config_data(self):
          con = self.get_connect(self.mehost,self.meport,self.meuser,self.mepassword,self.medatabase)
          cursor = con.cursor()
          sql = 'SELECT * FROM '+self.metableName + ' WHERE is_valid = "1" and runTimeInterval = 60'
          cursor.execute(sql)
          data = cursor.fetchall()
          columnDes = cursor.description  # 获取连接对象的描述信息
          columnNames = [columnDes[i][0] for i in range(len(columnDes))]
          df = pd.DataFrame([list(i) for i in data], columns=columnNames)
          cursor.close()
          con.close()
          print('######################################需要同步的表',len(df),'个###################################')
          return df
  
  
      # TODO 服务器内存不够，不能直接用df插入，先落盘
      def getmysqldata_to_csv(self,host,port,user,password,database,tablename,where):
          """
          获取mysql数据转成df
          :param tablename,where
          :return: 文件 :path+文件名
          """
          try:
              db_conn = self.get_connect(host,port,user,password,database)
              cursor = db_conn.cursor(pymysql.cursors.DictCursor)
              sql = 'SELECT * FROM {}'.format(tablename) +' where '+where
              cursor.execute(sql)
              data = cursor.fetchall()
  
              db_conn.commit()
              cursor.close()
              db_conn.close()
              df = pd.DataFrame(data=data)
              if len(df) >0:
                  df.to_csv(self.path+tablename,sep=',')
                  print(self.get_curtime(),tablename,'导出数据成功,导出数据{}条!'.format(len(df)),end= '')
                  status = '1'
              else:
                  print(self.get_curtime(),tablename,'数据为空!',end= '')
                  status = '0'
              return status
  
          except:
              print(self.get_curtime(),tablename, '导出数据失败！',end='')
  
      # TODO 删除同步的文件
      def deletefile(self,tablename):
          """
          删除对应的文件
          :param tablename
          :return:
          """
          path = self.path + tablename
          if os.path.exists(path):
              os.remove(path)
          else:
              print('no such file:%s' % path,end='')
  
      # TODO 删除表里当天的数据
      def delete_table_data(self,host,port,user,password,database,tablename,where):
          """
          :param tablename
                 where 里面是时间字段 用来过滤当天的数据
          :return:
          """
          db_conn = self.get_connect(host,port,user,password,database)
          cursor = db_conn.cursor(pymysql.cursors.DictCursor)
          try:
              sql = 'delete from  {}  where  {}'.format(tablename,where)
              cursor.execute(sql)
              db_conn.commit()
              cursor.close()
              db_conn.close()
              print('清空数据成功!', end='')
          except Exception as e:
              print('清空数据失败!',e, end='')
  
      # TODO 插入数据到mysql
      def putmysqldata(self,df,host,port,user,password,database,tablename):
          """
          :param df,host,user,port,password,database,table_name
          :return:
          """
          _number = 0
          while _number <= 6:
              try:
                  engine = create_engine(str(r"mysql+pymysql://%s:" + '%s' + "@%s:%s/%s")%(user, password, host, port, database))
                  df.to_sql(tablename,con=engine,if_exists='append',index=False)
                  print(' 插入:{}条'.format(len(df)),'插入数据成功!',end='')
                  break
              except:
                  _number += 1
                  print('插入数据尝试第{}次连接！'.format(_number), end='')
                  time.sleep(15)
  
      # TODO 汇总插入流程
      def insert_mysql_data(self,df,host,port,user,password,database,tablename,where):
          """
          :param: df
                  where 里面是时间字段 用来过滤当天的数据
          :return:
          """
          if len(df) > 0:
              self.delete_table_data(host,port,user,password,database,tablename,where)
              time.sleep(1)
              self.putmysqldata(df,host,port,user,password,database,tablename)
          else:
              print(' 数据为空',end='')
  
      # TODO 汇总整个流程
      def process_start(self):
          configDF = self.get_config_data()
          for i in tqdm(range(len(configDF)),desc='processing'):
              start_time = time.time()
              if configDF['where'][i] == 'all' :
                  where  = ' 1 = 1'
              else:
                  where = configDF['where'][i] +'>= "'+self.today+'"'
              source_table = configDF['source_tablename'][i]
              status = self.getmysqldata_to_csv(configDF['source_host'][i],int(configDF['source_port'][i]),configDF['source_user'][i],configDF['source_password'][i],configDF['source_database'][i],source_table,where)
              if status == '0':
                  print()
                  continue
              # 读取csv 转成df
              dataDF = pd.read_csv(self.path+source_table)
              dataDF.drop(['Unnamed: 0'], axis=1, inplace=True)
              #保证插入的幂等性
              self.insert_mysql_data(dataDF,configDF['sink_host'][i],int(configDF['sink_port'][i]),configDF['sink_user'][i],configDF['sink_password'][i],configDF['sink_database'][i],configDF['sink_tablename'][i],where)
              print(' 用时: %dsecond'%(time.time() - start_time))
              #删除文件
              self.deletefile(source_table)
              time.sleep(10)
  
      #TODO 发送到钉钉群里
      def send_ding_msg(self,content):
          """
          获取中高风险地区数据
          :param content 发送内容
          :return:
          """
          headers = {'Content-Type': 'application/json'}
          webhook = "https://oapi.dingtalk.com/robot/send?access_token=" + self.access_token
          data = {
              "msgtype": "text",
               "text": {"content": content + '\n'},
                     #  "at":{
                      #         "atMobiles":[13977712140],
                       #        "isAtAll":False
                    # }
          }
          x = requests.post(url=webhook, data=json.dumps(data), headers=headers)
          print(x.status_code)
  
      # TODO 开始执行
      def run(self):
          content = self.get_curtime() + '任务失败，请处理！'
          try:
              self.process_start()
          except:
              #print(5)
              self.send_ding_msg(content = content)
  
  
  if __name__ == '__main__':
      instance = mysqlToMysqlDataPro()
      instance.run()
  ````




#### SQL优化手段：

* **有根据性的创建索引，考虑在where和order by命令上涉及的列建立索引**
  - 值分布很稀少地字段不适合建索引
  - 字符字段最好不要做主键
* **避免使用NULL字段，很难查询优化且占用额外的索引空间。例如：在where语句中对NULL进行判断会导致引擎放弃使用索引而进行全表扫描**
* 不用select * ，改成需要查询的字段，可以提升速度以及减少网络传输的压力
* **or 改写成 in 。or的效率是O(n)，in的效率是O(log n) ，in中的个数建议200以内**
* 少用join
* **尽量避免在where中使用!= 或者 <>操作符，否则会导致引擎放弃使用索引而进行全表扫描**
* **对于连续性数值用between不用in**
* **先过滤数据，再进行join**

#### 存储过程+定时器制作中间表

* 如果在实现用户的某些需求时，需要编写一组复杂的SQL语句才能实现的时候，那么我们就可以将这组复杂的SQL语句集提前编写在数据库中，由JDBC调用来执行这组SQL语句。把编写在数据库中的SQL语句集称为存储过程。

* 存储过程：(procedure) 是事先经过编译并存储在数据库中的一段SQL语句的集合。调用存储过程可以简化应用开发人员的很多工作，减少数据在数据库和应用服务器之间的传输，对于提高数据处理的效率是很有好处的。**存储过程就是数据库SQL语言层面的代码封装与重用**
* 优点
  - 简化复杂操作，简化对变动的管理
  - **通常存储过程有助于提高应用程序的性能**。当创建的存储过程被编译之后，就存储在数据库中。
  - 存储过程有助于减少应用程序和数据库服务器之间的流量。
  - 可重用，透明，安全的。
* 缺点
  - 如果大量使用存储过程，那么使用这些存储过程的每个连接的内存使用量将大大增加。此外，如果在存储过程中过度使用大量的逻辑操作，那么CPU的使用率也在增加，因为MySQL数据库最初的设计就侧重于高效的查询，而不是逻辑运算。
  - 开发维护，调试代码困难，**对数据库依赖程度高，移植性较差**。

* 存储过程样例：

  ````sql
  CREATE DEFINER=`root`@`%` PROCEDURE `TEST`(
    IN execDate  VARCHAR(8)
  )
  BEGIN
  
  # 清空表
  TRUNCATE TABLE MYTEST_TEMP; 
  
  INSERT INTO MYTEST_TEMP 
  (
  id,
  author,
  submission_date,
  execute_date
  )
  SELECT 
  id,author,submission_date,DATE_FORMAT(NOW(),'%Y-%m-%d 23:59:59') AS execute_date
  FROM MYTEST
  WHERE submission_date = execDate;
  COMMIT;
  
  END
  
  ````

  

* 一些查询时间比较长，或者结果表类似的指标，做成一个中间表，通过存储过程实现，然后通过定时器定时执行，定期更新，这样查询速度会大大提升。

* 定时器案例

  - 每天凌晨一点执行

  ````sql
  DROP EVENT IF EXISTS user_event ;	
  CREATE EVENT user_event
  on schedule EVERY 1 DAY STARTS date_add(date( ADDDATE(curdate(),1)),interval 1 hour)  
  DO  call TEST();  
  
  ````


## 华夏银行大数据平台升级项目

* 原先部署的数栈平台默认是impala引擎，现在速度太慢，需要更换引擎，后面更换为trino引擎。但是涉及到新旧平台的任务迁移，以及数据的平稳过渡
* Apache Impala 是采用 MPP 架构的查询引擎，本身不存储任何数据，**直接使用内存进行计算**，兼顾数据仓库，具有实时，批处理，多并发等优点。
* Trino 是一个开源的**「分布式 SQL 查询引擎」**，能够通过联邦查询、并行查询、水平集群伸缩等方式解决上述问题。
  - 它是一种工具，一种可以提供访问多种数据源，并且可以处理PB，TB级别的工具。并且能进行数据分析，聚合数据，生成报告（通常 这是OLAP的功能）
* impala,trino都是OLAP系统的查询引擎,速度比较快
* 首先是任务迁移，以前在调度的任务，根据不同分行，先将任务的依赖去掉，然后利用SQL转换脚本先统一转换，当出现转换失败的任务，则需要我们数据开发手动进行修改，引擎不一样有一些SQL语法，函数会有区别，所以我们需要手动修改。
* 修改完成后，加上任务依赖，然后进行数据的校验工作。
* 数据校验的基本思路：
  - 首先是数据的条数，比如一个表，在新老环境中，每天的数据量要保证一致性
  - 其次校验数据的一致性，采用union 的操作，将新老环境同一张表进行union，union会去掉重复的数据，如果两边的数据一致，那么union后的结果条数会是一张表的条数。
  - 完成这两项之后，基本可以确定这个任务的迁移完成



## 宁波交警数据大屏项目

* 使用公司的数栈平台，首先是接入各个厂商的数据到数据中台中来，采用公司自研的flinkx框架。
* 前期接入数据，制定一些数据的规范，
* 首先，根据数据源的情况，制定数据的同步策略
  - 每天全量  （通行证的几张表）
  - 每天增量更新  （）
  - 新增及修改   （事故处理的几张表）
  - 码表定时更新   （比如车辆基础信息的码表）
* 对于接入的数据，创建spark sql任务进行处理，得到指标数据落盘到MySQL中
* spark任务根据指标的不同，有天调度任务，小时调度任务，尽量保证实时性与正确性。

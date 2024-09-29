-- 累计求和
-- 思路：利用开窗，累积数据
with t1 as (select 'u01' as uid, '2017/1/21' as date_t, 5 as visitCount
            union all
            select 'u02' as uid, '2017/1/23' as date_t, 6 as visitCount
            union all
            select 'u03' as uid, '2017/1/22' as date_t, 8 as visitCount
            union all
            select 'u04' as uid, '2017/1/20' as date_t, 3 as visitCount
            union all
            select 'u01' as uid, '2017/1/23' as date_t, 6 as visitCount
            union all
            select 'u01' as uid, '2017/2/21' as date_t, 8 as visitCount
            union all
            select 'u02' as uid, '2017/1/23' as date_t, 6 as visitCount
            union all
            select 'u01' as uid, '2017/2/22' as date_t, 4 as visitCount),
     t2 as (select uid, date_format(regexp_replace(date_t, '/', '-'), 'yyyy-MM') as v_date, visitCount from t1)
select uid, v_date, vc, sum(vc) over (partition by uid order by v_date) as s_vc
from (select uid, v_date, sum(visitCount) as vc
      from t2
      group by v_date, uid) tmp1
order by uid, v_date
;



-- top_K问题
-- 1.每个店铺的uv，访客数
with t1 as (select 'u1' as user_id, 'a' as shop
            union all
            select 'u2' as user_id, 'b' as shop
            union all
            select 'u1' as user_id, 'b' as shop
            union all
            select 'u1' as user_id, 'a' as shop
            union all
            select 'u3' as user_id, 'c' as shop
            union all
            select 'u4' as user_id, 'b' as shop
            union all
            select 'u1' as user_id, 'a' as shop
            union all
            select 'u2' as user_id, 'c' as shop
            union all
            select 'u5' as user_id, 'b' as shop
            union all
            select 'u4' as user_id, 'b' as shop
            union all
            select 'u6' as user_id, 'c' as shop
            union all
            select 'u2' as user_id, 'c' as shop
            union all
            select 'u1' as user_id, 'b' as shop
            union all
            select 'u2' as user_id, 'a' as shop
            union all
            select 'u2' as user_id, 'a' as shop
            union all
            select 'u3' as user_id, 'a' as shop
            union all
            select 'u5' as user_id, 'a' as shop
            union all
            select 'u5' as user_id, 'a' as shop
            union all
            select 'u5' as user_id, 'a' as shop)
select count(distinct user_id) as uv, shop
from t1
group by shop;

-- 2.每个店铺访问次数top3的访客信息。输出店铺名称、访客id、访问次数
with t1 as (select 'u1' as user_id, 'a' as shop
            union all
            select 'u2' as user_id, 'b' as shop
            union all
            select 'u1' as user_id, 'b' as shop
            union all
            select 'u1' as user_id, 'a' as shop
            union all
            select 'u3' as user_id, 'c' as shop
            union all
            select 'u4' as user_id, 'b' as shop
            union all
            select 'u1' as user_id, 'a' as shop
            union all
            select 'u2' as user_id, 'c' as shop
            union all
            select 'u5' as user_id, 'b' as shop
            union all
            select 'u4' as user_id, 'b' as shop
            union all
            select 'u6' as user_id, 'c' as shop
            union all
            select 'u2' as user_id, 'c' as shop
            union all
            select 'u1' as user_id, 'b' as shop
            union all
            select 'u2' as user_id, 'a' as shop
            union all
            select 'u2' as user_id, 'a' as shop
            union all
            select 'u3' as user_id, 'a' as shop
            union all
            select 'u5' as user_id, 'a' as shop
            union all
            select 'u5' as user_id, 'a' as shop
            union all
            select 'u5' as user_id, 'a' as shop),
     t2 as (select shop, user_id, count(1) as cnt from t1 group by shop, user_id),
     t3 as (select shop, user_id, cnt, row_number() over (partition by shop order by cnt desc ) as rn
            from t2)
select shop, user_id, cnt
from t3
where rn <= 3;



-- 订单量统计
-- 1给出 2017年每个月的订单数、用户数、总成交金额。
-- 2给出2017年11月的新客数(指在11月才有第一笔订单)
with t1 as (select '2017-01-01' as dt, '10029028' as order_id, '1000003251' as user_id, 33.57 as amount
            union all
            select '2017-01-01' as dt, '10029029' as order_id, '1000003251' as user_id, 33.57 as amount
            union all
            select '2017-01-01' as dt, '100290288' as order_id, '1000003252' as user_id, 33.57 as amount
            union all
            select '2017-02-02' as dt, '10029088' as order_id, '1000003251' as user_id, 33.57 as amount
            union all
            select '2017-02-02' as dt, '100290281' as order_id, '1000003251' as user_id, 33.57 as amount
            union all
            select '2017-02-02' as dt, '100290282' as order_id, '1000003253' as user_id, 33.57 as amount
            union all
            select '2017-11-02' as dt, '10290282' as order_id, '1000003253' as user_id, 234.00 as amount
            union all
            select '2018-11-02' as dt, '10290284' as order_id, '1000003243' as user_id, 234.00 as amount),
     res1 as (select date_format(dt, 'yyyy-MM') as dt_month,
                     count(order_id)            as order_num,
                     count(user_id)             as user_num,
                     sum(amount)                as sum_amount
              from t1
              where date_format(dt, 'yyyy') = '2017'
              group by date_format(dt, 'yyyy-MM')),
     res2 as (select tmp1.user_id as new_user_id
              from (select user_id from t1 where date_format(dt, 'yyyy-MM') >= '2017-11') tmp1
                       left join (select user_id from t1 where date_format(dt, 'yyyy-MM') < '2017-11') tmp2
                                 on tmp1.user_id = tmp2.user_id
              where tmp2.user_id is null)
select *
from res2;


-- yuxing
-- 连续登录三天以上的用户
-- 方法1
with t1 as (select 1 as id, '2019-01-01' as date1
            union all
            select 1 as id, '2019-01-02' as date1
            union all
            select 1 as id, '2019-01-03' as date1
            union all
            select 2 as id, '2019-02-01' as date1
            union all
            select 2 as id, '2019-02-02' as date1
            union all
            select 3 as id, '2019-03-04' as date1
            union all
            select 3 as id, '2019-03-05' as date1
            union all
            select 3 as id, '2019-03-06' as date1
            union all
            select 3 as id, '2019-03-07' as date1),
     -- 如果当天有重复登录的数据，则要先去重再进行计算
     t1_1 as (select id, date1 from t1 group by id, date1),
     t2 as (select id, date1, row_number() over (partition by id order by date1) as rk from t1_1),
     -- 做差求出基准值，基准值相同的，则为连续
     t3 as (select id, date1, rk, date_sub(date1, rk) as date_base from t2)
select id, date_base, count(1) as cnt
from t3
group by id, date_base
having cnt >= 3
;

-- 方法2
-- 根据前一天数据的登录时间，两个时间做差，看是否重复
with t1 as (select 1 as id, '2019-01-01' as date1
            union all
            select 1 as id, '2019-01-02' as date1
            union all
            select 1 as id, '2019-01-04' as date1
            union all
            select 1 as id, '2019-01-06' as date1
            union all
            select 1 as id, '2019-01-08' as date1
            union all
            select 2 as id, '2019-02-01' as date1
            union all
            select 2 as id, '2019-02-02' as date1
            union all
            select 3 as id, '2019-03-04' as date1
            union all
            select 3 as id, '2019-03-05' as date1
            union all
            select 3 as id, '2019-03-06' as date1
            union all
            select 3 as id, '2019-03-07' as date1),
     -- 如果当天有重复登录的数据，则要先去重再进行计算
     t1_1 as (select id, date1 from t1 group by id, date1),
     -- lag,取滞后的值，从上往下看的话，就是取上面的值
     t2 as (select id, date1, lag(date1, 1, '0000-00-00') over (partition by id order by date1) as last_date from t1_1) ,
-- 与上次登录时间做差,如果为默认值或者与上一个值相差为1则标识为连续
     t3 as (select id,
                   date1,
                   last_date,
                   case
                       -- 为第一个值时
                       when last_date = '0000-00-00' then 0
                       -- 与上一个值相差1时,视为连续
                       when datediff(date1, last_date) = 1 then 0
                       else 1 end as is_continue
            from t2)
select id, is_continue, count(1) as cnt
from t3
where is_continue = 0
group by id, is_continue
having cnt >= 3
;

-- 方法三
-- 开窗函数
-- 方法3
with t1 as (select 1 as id, '2019-01-01' as date1
            union all
            select 1 as id, '2019-01-02' as date1
            union all
            select 1 as id, '2019-01-04' as date1
            union all
            select 1 as id, '2019-01-06' as date1
            union all
            select 1 as id, '2019-01-08' as date1
            union all
            select 2 as id, '2019-02-01' as date1
            union all
            select 2 as id, '2019-02-02' as date1
            union all
            select 3 as id, '2019-03-04' as date1
            union all
            select 3 as id, '2019-03-05' as date1
            union all
            select 3 as id, '2019-03-06' as date1
            union all
            select 3 as id, '2019-03-07' as date1),
     -- 利用开窗函数rows between 2 preceding and current row
     -- 从上往下看数据行的话：数字 + preceding 就是向上几行，数字 + following就是向下几行
     -- current row 当前行
     -- unbounded preceding 表示从上面的起点开始，即第一行开始
     -- unbounded following 表示到后面的终点，即到最后一行结束
     t2 as (select id,
                   date1,
                   collect_list(date1)
                                over (partition by id order by date1 rows between 2 preceding and current row )         as rows3,
                   collect_list(date1)
                                over (partition by id order by date1 rows between current row and 2 following)          as test_following3,
                   collect_list(date1)
                                over (partition by id order by date1 rows between unbounded preceding and current row ) as test_unbounded_preceding,
                   collect_list(date1)
                                over (partition by id order by date1 rows between 1 preceding and unbounded following ) as test_unbounded_following
            from t1)
select id, date1, rows3
from t2
where size(rows3) = 3
  and datediff(date_format(rows3[1], 'yyyy-MM-dd'), date_format(rows3[0], 'yyyy-MM-dd')) = 1
  and datediff(date_format(rows3[2], 'yyyy-MM-dd'), date_format(rows3[1], 'yyyy-MM-dd')) = 1;

-- 连续登录最大天数用户
with t1 as (select 1 as id, '2019-01-01' as date1
            union all
            select 1 as id, '2019-01-02' as date1
            union all
            select 1 as id, '2019-01-03' as date1
            union all
            select 1 as id, '2019-01-09' as date1
            union all
            select 2 as id, '2019-02-01' as date1
            union all
            select 2 as id, '2019-02-02' as date1
            union all
            select 3 as id, '2019-03-04' as date1
            union all
            select 3 as id, '2019-03-05' as date1
            union all
            select 3 as id, '2019-03-06' as date1
            union all
            select 3 as id, '2019-03-07' as date1),
     -- 如果当天有重复登录的数据，则要先去重再进行计算
     t1_1 as (select id, date1 from t1 group by id, date1),
     t2 as (select id, date1, row_number() over (partition by id order by date1) as rk from t1_1),
-- 利用row_number做差求出基准值，基准值相同的，则为连续
     t3 as (select id, date1, rk, date_sub(date1, rk) as date_base from t2),
     t4 as (select id, date_base, count(1) as cnt
            from t3
            group by id, date_base),
     -- 在连续登录的基础上，选择每个用户登录次数最多那次,以及它的首次登录时间
     t5 as (select id, max(cnt) as max_cnt from t4 group by id)
select t5.id, t5.max_cnt, date_add(t4.date_base, 1)
from t5
         left join t4 on t5.id = t4.id and t5.max_cnt = t4.cnt
;



-- 波峰波谷
-- 波峰：当天的价格大于前一天和后一天
-- 波谷：当天的价格小于前一天和后一天
with t1 as (select 1 as id, '2019-01-01' as date1, 10001 as price
            union all
            select 1 as id, '2019-01-03' as date1, 1001 as price
            union all
            select 1 as id, '2019-01-02' as date1, 10002 as price
            union all
            select 1 as id, '2019-01-04' as date1, 999 as price
            union all
            select 1 as id, '2019-01-05' as date1, 1002 as price
            union all
            select 1 as id, '2019-01-06' as date1, 1003 as price
            union all
            select 1 as id, '2019-01-07' as date1, 1004 as price
            union all
            select 1 as id, '2019-01-08' as date1, 998 as price
            union all
            select 1 as id, '2019-01-09' as date1, 997 as price
            union all
            select 1 as id, '2019-01-10' as date1, 996 as price
            union all
            select 2 as id, '2019-01-01' as date1, 10001 as price
            union all
            select 2 as id, '2019-01-02' as date1, 10002 as price
            union all
            select 2 as id, '2019-01-03' as date1, 10003 as price
            union all
            select 2 as id, '2019-01-04' as date1, 10002 as price
            union all
            select 2 as id, '2019-01-05' as date1, 1002 as price
            union all
            select 2 as id, '2019-01-06' as date1, 1003 as price
            union all
            select 2 as id, '2019-01-07' as date1, 1004 as price
            union all
            select 2 as id, '2019-01-08' as date1, 998 as price
            union all
            select 2 as id, '2019-01-09' as date1, 997 as price
            union all
            select 2 as id, '2019-01-10' as date1, 996 as price),
     -- 当天的价格大于前一天和后一天
     -- 考虑使用lag(),lead()
     t2 as (select id,
                   date1,
                   price,
                   lag(price, 1, null) over (partition by id order by date1)  as last_day_price,
                   lead(price, 1, null) over (partition by id order by date1) as next_day_price
            from t1)
select id, date1, price, last_day_price, next_day_price, '波峰' as type
from t2
where (last_day_price is not null and next_day_price is not null)
  and (price > last_day_price and price > next_day_price)
union all
select id, date1, price, last_day_price, next_day_price, '波谷' as type
from t2
where (last_day_price is not null and next_day_price is not null)
  and (price < last_day_price and price < next_day_price);



-- 三种排序
-- 排序开窗,topn问题
-- 每个学生成绩第二高的科目
with t1 as (select 'a' as class, 'nxx' as student, 100 as score
            union all
            select 'c' as class, 'nxx1' as student, 60 as score
            union all
            select 'b' as class, 'nxx' as student, 80 as score
            union all
            select 'b' as class, 'nxx1' as student, 80 as score
            union all
            select 'c' as class, 'nxx' as student, 90 as score
            union all
            select 'c' as class, 'nxx2' as student, 90 as score),
-- 开窗排序
     t2 as (select class, student, score, row_number() over (partition by student order by score desc ) as rn from t1)
select *
from t2
where rn = 2;



-- 累计汇总（聚合开窗，一步步求累计）
-- 1.统计每个用户每月访问次数 和 累计访问次数
with t1 as (select 'u01' as userid, '2017/1/21' as visit_date, 5 as visitcount
            union all
            select 'u02' as userid, '2017/1/23' as visit_date, 6 as visitcount
            union all
            select 'u03' as userid, '2017/1/22' as visit_date, 8 as visitcount
            union all
            select 'u04' as userid, '2017/1/20' as visit_date, 3 as visitcount
            union all
            select 'u01' as userid, '2017/1/23' as visit_date, 6 as visitcount
            union all
            select 'u01' as userid, '2017/2/21' as visit_date, 8 as visitcount
            union all
            select 'u02' as userid, '2017/1/23' as visit_date, 6 as visitcount
            union all
            select 'u01' as userid, '2017/2/22' as visit_date, 4 as visitcount),
     t2 as (select userid, date_format(regexp_replace(visit_date, '/', '-'), 'yyyy-MM-dd') as visit_date, visitcount
            from t1),
     -- 用户每月访问次数
     res1 as (select userid,
                     date_format(visit_date, 'yyyy-MM') as dt_month,
                     sum(visitcount)                    as month_sum
              from t2
              group by userid, date_format(visit_date, 'yyyy-MM')),
     -- 用户每月访问次数累计
     res2 as (select userid,
                     dt_month,
                     month_sum,
                     sum(month_sum) over (partition by userid order by dt_month) as sum_month_sum
              from res1)
select *
from res2;
select 12*0.3+12;
select 12*0.25+12;

/*
 以下是用户的加购流水和后续的支付情况，小时维度更新，下单件量等于加购件量
 题目：输出不同用户每个小时的下列指标
1) 每小时加购件量
2）每小时下单，且下单日期等于加购日期，的下单件量
3）每小时，当日加入购物车的商品中，累计未下单的商品件量
 用户id	商品id	    加入购物车时间	    下单时间	      件量
 */


with t1 as (select '1'                as uid,
                   'good1'            as good_id,
                   '2023-05-01 03:00' as cart_time,
                   '2023-05-01 07:00' as pay_time,
                   3                  as cart_qty
            union all
            select '1' as uid, 'good2' as good_id, '2023-05-01 04:30' as cart_time, null as pay_time, 4 as cart_qty
            union all
            select '1'                as uid,
                   'good3'            as good_id,
                   '2023-05-01 05:59' as cart_time,
                   '2023-05-01 09:00' as pay_time,
                   3                  as cart_qty
            union all
            select '1' as uid, 'good4' as good_id, '2023-05-01 06:29' as cart_time, null as pay_time, 4 as cart_qty
            union all
            select '1'                as uid,
                   'good5'            as good_id,
                   '2023-05-01 07:30' as cart_time,
                   '2023-05-02 08:00' as pay_time,
                   5                  as cart_qty
            union all
            select '1'                as uid,
                   'good6'            as good_id,
                   '2023-05-01 08:30' as cart_time,
                   '2023-05-01 09:00' as pay_time,
                   6                  as cart_qty
            union all
            select '2'                as uid,
                   'good7'            as good_id,
                   '2023-05-02 06:30' as cart_time,
                   '2023-05-02 22:00' as pay_time,
                   7                  as cart_qty
            union all
            select '2'                as uid,
                   'good8'            as good_id,
                   '2023-05-02 07:30' as cart_time,
                   '2023-05-02 22:00' as pay_time,
                   8                  as cart_qty
            union all
            select '2'                as uid,
                   'good9'            as good_id,
                   '2023-05-02 08:30' as cart_time,
                   '2023-05-03 00:30' as pay_time,
                   9                  as cart_qty
            union all
            select '2'                as uid,
                   'good10'           as good_id,
                   '2023-05-02 09:30' as cart_time,
                   '2023-05-02 22:00' as pay_time,
                   10                 as cart_qty
            union all
            select '2' as uid, 'good11' as good_id, '2023-05-02 10:30' as cart_time, null as pay_time, 11 as cart_qty),
     q1 as (select uid, hour(cart_time) as cart_h, sum(if(cart_qty is null, 0, cart_qty)) as cart_num
            from t1
            group by uid, hour(cart_time)),
     q2 as (select uid, hour(pay_time) pay_h, sum(cart_qty) as pay_num
            from t1
            where pay_time is not null
              and date_format(cart_time, 'yyyy-MM-dd') = date_format(pay_time, 'yyyy-MM-dd')
            group by uid, hour(pay_time)),
     -- q3 每小时，当日加入购物车的商品中，累计未下单的商品件量
     q3 as (select uid,
                   good_id,
                   cart_time,
                   pay_time,
                   cart_qty,
                   hour(cart_time)                                                                           as cart_hour,
                   sum(if(pay_time is null, cart_qty, 0))
                       over (partition by uid,date_format(cart_time, 'yyyy-MM-dd') order by hour(cart_time)) as sum_goods
            from t1)
select *
from q3;



-- 留存计算
-- 平台七日留存率计算
-- 留存率：(N日后仍然活跃的用户数/N日前的初始用户数)
-- 思路：一天多次登录先去重,自连接，且date1<date2
-- 根据date1,date2的差值确定是否留存
with data as (select 1 as uid, '2019-01-01 00:00:00' as date_v
              union all
              select 2 as uid, '2019-01-01 01:00:00' as date_v
              union all
              select 1 as uid, '2019-01-02 00:00:00' as date_v
              union all
              select 1 as uid, '2019-01-03 00:00:00' as date_v
              union all
              select 2 as uid, '2019-02-01 00:00:00' as date_v
              union all
              select 2 as uid, '2019-01-02 00:00:00' as date_v
              union all
              select 3 as uid, '2019-03-04 00:00:00' as date_v
              union all
              select 3 as uid, '2019-03-05 00:00:00' as date_v
              union all
              select 3 as uid, '2019-03-06 00:00:00' as date_v
              union all
              select 3 as uid, '2019-03-07 00:00:00' as date_v),
     -- 每天多次登录先去重
     t1 as (select uid, substr(date_v, 0, 10) as date1 from data group by uid, substr(date_v, 0, 10)),
     t2 as (select uid, substr(date_v, 0, 10) as date2 from data group by uid, substr(date_v, 0, 10)),
     -- 数据通过uid连接，但是date1<date2
     tmp as (select t1.uid,
                    date1,
                    date2,
                    datediff(date2, date1)                                 as date_diff,
                    case when datediff(date2, date1) = 1 then 1 else 0 end as date_diff_flag
             from t1
                      left join t2 on t1.uid = t2.uid and t1.date1 < t2.date2)
-- 可以求出每日登录用户的留存率情况
select date1,
       sum(case when datediff(date2, date1) = 1 then 1 else 0 end) / count(distinct uid) as lat1date_rate, -- 次日留存率
       sum(case when datediff(date2, date1) = 3 then 1 else 0 end) / count(distinct uid) as lat3date_rate, -- 三日留存率
       sum(case when datediff(date2, date1) = 7 then 1 else 0 end) / count(distinct uid) as lat7date_rate  -- 七日留存率
from tmp
group by date1;

-- 炸裂函数
-- 字段：球员，比赛场次，得分，地点，比赛时间
-- 计算该球员1-100分，101-200分，201-300分的比赛场次，以及对应比赛场次在该区间中的得分
with data as (select 'curry' as player, 1 as match_number, 30 as point, '北京' as area, '2022-02-02' as dt
              union all
              select 'curry' as player, 2 as match_number, 28 as point, '上海' as area, '2022-02-07' as dt
              union all
              select 'curry' as player, 3 as match_number, 36 as point, '广州' as area, '2022-02-12' as dt
              union all
              select 'curry' as player, 4 as match_number, 57 as point, '深圳' as area, '2022-02-17' as dt
              union all
              select 'curry' as player, 5 as match_number, 19 as point, '南京' as area, '2022-02-22' as dt
              union all
              select 'curry' as player, 6 as match_number, 22 as point, '武汉' as area, '2022-02-27' as dt
              union all
              select 'curry' as player, 7 as match_number, 32 as point, '成都' as area, '2022-03-04' as dt
              union all
              select 'curry' as player, 8 as match_number, 23 as point, '厦门' as area, '2022-03-09' as dt),
     -- 利用posexplode+space函数生成连续的分数
     t1 as (select player,
                   match_number,
                   point,
                   area,
                   dt,
--                    ceil(count(1) over ( order by match_number,dt) / 100) as part,
                   row_number() over (order by match_number,dt) as rn
            from data lateral view posexplode(split(space(point - 1), '')) tmp as pos, value
            where player = 'curry'),
     -- 根据分数划分区间
     t2 as (select player,
                   match_number,
                   point,
                   area,
                   dt,
                   rn,
                   1                                                                 as flag,-- 每一行算一分
                   ceil(rn / 100)                                                    as part,
                   concat(ceil(rn / 100) * 100 - 100 + 1, '-', ceil(rn / 100) * 100) as part_name
            from t1)
-- 累加区间的分数得出结果
select player, match_number, point, area, dt, part_name, part_point
from (select player,
             match_number,
             point,
             area,
             dt,
             rn,
             part,
             part_name,
             sum(flag) over (partition by match_number,part_name order by match_number,dt)     as part_point,
             row_number() over (partition by match_number,part_name order by match_number,dt ) as rn2 -- 最终区间内排序，取一条数据即可
      from t2) tmp
where rn2 = 1;


-- 直播间最大人数
-- 扩展，每个小时内的bobo间在线人数
with data as (select 'a'                   as room_id,
                     1                     as user_id,
                     '2020-11-25 12:00:00' as login_time,
                     '2020-11-25 13:00:00' as logout_time
              union all
              select 'a'                   as room_id,
                     1                     as user_id,
                     '2020-11-25 12:30:00' as login_time,
                     '2020-11-25 12:40:00' as logout_time
              union all
              select 'a'                   as room_id,
                     2                     as user_id,
                     '2020-11-25 12:30:30' as login_time,
                     '2020-11-25 14:35:00' as logout_time
              union all
              select 'a'                   as room_id,
                     3                     as user_id,
                     '2020-11-25 12:35:30' as login_time,
                     '2020-11-25 15:40:00' as logout_time
              union all
              select 'a'                   as room_id,
                     4                     as user_id,
                     '2020-11-25 12:38:30' as login_time,
                     '2020-11-25 12:40:00' as logout_time),
     t1 as (select room_id,
                   user_id,
                   login_time,
                   logout_time,
                   hour(login_time)                     as login_hour,
                   hour(logout_time)                    as logout_hour,
                   hour(logout_time) - hour(login_time) as watch_hour -- 观看时长,利用这个时间可以看跨小时连续观看的情况
            from data),
     t2 as (select room_id,
                   user_id,
                   login_time,
                   logout_time,
                   login_hour,
                   logout_hour,
                   watch_hour,
                   pos,
                   login_hour + pos as on_time -- 利用posexplode(split(space(10) 生成连续的数与初始时间相加，得出这个小时断的数据
            from t1 lateral view posexplode(split(space(watch_hour), '')) tmp as pos, val)
-- 聚合得出访问次数的结果
select room_id, on_time, count(distinct user_id) as on_time_visit
from t2
group by room_id, on_time;


-- 相互关注(共同好友)
/*
 fans 表 关注表，记录关注动作记录的表
 from_user 关注用户  to_user 被关注用户
 -- 互相关注，考虑自连接
 */
with fans as (select 'A' as from_user, 'B' to_user, '2022-11-28 12:12:12' as dt
              union all
              select 'A' as from_user, 'C' to_user, '2022-11-28 12:12:13' as dt
              union all
              select 'A' as from_user, 'D' to_user, '2022-11-28 12:12:14' as dt
              union all
              select 'B' as from_user, 'A' to_user, '2022-11-28 12:12:16' as dt
              union all
              select 'B' as from_user, 'E' to_user, '2022-11-28 12:12:16' as dt
              union all
              select 'C' as from_user, 'A' to_user, '2022-11-28 12:12:17' as dt),
     -- 方法1
     res1 as (select t1.from_user as u1, t2.from_user as u2
              from fans t1
                       left join fans t2 on t1.to_user = t2.from_user
              where t1.from_user = t2.to_user),
     -- 方法2
     res2 as (select u1, u2
              from (select from_user u1, to_user u2
                    from fans
                    union all
                    select to_user u1, from_user u2
                    from fans) tmp
              group by u1, u2
              having count(1) = 2),
     -- 方法3:大数据量的场景下
     res3 as (select from_user, to_user, arr_list, sort_arr_list, sum(flag) over (partition by sort_arr_list) as cnt
              from (select from_user,
                           to_user,
                           `array`(from_user, to_user)             as arr_list,
                           sort_array(`array`(from_user, to_user)) as sort_arr_list,
                           1                                       AS flag
                    from fans) tmp)
-- select *
-- from res3
-- where cnt > 1;
-- 结果去重
select *
from (select u1,
             u2,
             `array`(u1, u2)                                                         as arr_list,
             sort_array(`array`(u1, u2))                                             as sort_arr_list,
             row_number() over (partition by sort_array(`array`(u1, u2)) order by 1) as rn
      from res1) tmp1
where rn = 1;


-- id,uid,tel,create_time
-- 排序相关 collect_list collect_set 可以搭配开窗函数适用可以使内部有序
with data as (select 1 as id, '1' as uid, '12312345671' as tel, '2024-09-27' as create_time
              union all
              select 2 as id, '1' as uid, '12312345672' as tel, '2024-09-20' as create_time
              union all
              select 3 as id, '2' as uid, '12312345673' as tel, '2024-09-19' as create_time
              union all
              select 4 as id, '3' as uid, '12312345674' as tel, '2024-09-18' as create_time
              union all
              select 5 as id, '3' as uid, '12312345675' as tel, '2024-09-17' as create_time
              union all
              select 2 as id, '1' as uid, '0521-7896544' as tel, '2024-01-20' as create_time)
select *
from (select uid,
             concat_ws(',', collect_list(tel) over (partition by uid order by create_time)) as tels,
             create_time,
             row_number() over (partition by uid order by create_time desc )                as rn
      from data) tmp
where rn = 1;

SELECT memberid,
       concat_ws(',', collect_list(airways) over (partition by memberid order by legcount)) as airways_res,
       legcount
from (select 1 as memberid, 'A' as airways, 3 as legcount
      union ALL
      select 1 as memberid, 'B' as airways, 2 as legcount
      union ALL
      select 1 as memberid, 'D' as airways, 1 as legcount
      union ALL
      select 1 as memberid, 'C' as airways, 4 as legcount
      union ALL
      select 2 as memberid, 'C' as airways, 4 as legcount
      union ALL
      select 2 as memberid, 'D' as airways, 3 as legcount) as t;

-- 每一门课大于60分的学生的所有科目成绩
/*
 student学生表有id,student_name。class课程表中有id,class_name,sc选课表中属性有sid,cid,score
 一个学生可以选多门课，一门课可以有多个学生，每个课程分数都大于60分意味着这个学生得分最低的课程大于60分
 */
with
    -- 学生表
    student as (select 1 as id, 'wang' as student_name
                union all
                select 2 as id, 'de' as student_name
                union all
                select 3 as id, 'fa' as student_name),
    -- 课程表
    class as (select 1 as id, 'yuwen' as class_name
              union all
              select 2 as id, 'shuxue' as class_name
              union all
              select 3 as id, 'yingyu' as class_name),
    -- 选课表
    sc as (select 1 as sid, 1 as cid, 61 as score
           union all
           select 1 as sid, 2 as cid, 62 as score
           union all
           select 1 as sid, 3 as cid, 63 as score
           union all
           select 2 as sid, 1 as cid, 59 as score
           union all
           select 2 as sid, 2 as cid, 71 as score
           union all
           select 3 as sid, 2 as cid, 71 as score
           union all
           select 3 as sid, 3 as cid, 72 as score),
    t1 as (select sid, student_name, cid, class_name, score
           from sc
                    left join student on sc.sid = student.id
                    left join class on sc.cid = class.id)
select t1.sid, student_name, cid, class_name
from t1
         left join
     -- 分数都大于六十，且每门课都考了的学生
         (select sid, min(sc.score) as min_score, count(sc.cid) as class_num
          from sc
          group by sc.sid
          having min(sc.score) >= 60
             and count(sc.cid) = (select count(1) from class)) t2 on t1.sid = t2.sid
where t2.sid is not null;

-- 7
/**
题目
注意点:一个部门的人数是包含下级所有部门的人数，一个HR可以同时负责多个部门，包括负责上下级部门，且部门信息表中部门层级不固定
求每个HR负责的部门的人数之和
CREATE TABLE test.hrd(
hr_id String comment 'hr的ID'
,dept_id String comment'负责的部门ID!)engine MergeTree
order by hr_id
comment'hr与部门关系映射表
CREATE TABLE test.dept (
dept id varchar(64)comment'部门ID
dept_parent_id varchar(64)comment'上级部门ID
emp_cnt int comment'部门员工数'
)engine MergeTree
order by dept_id
comment'部门信息表
INSERT INTo test.hrd('hr_id`,`dept_id`)VALUES
('hr1'.'2')
('hr1','3')
('hr1'.'4')
('hr2','b')
('hr2','c')
('hr2','d')
INSERT INTo test.dept(`dept_id`,`dept_parent_id`,`emp_cnt`) VALUES
('1','',5000)
('2','1',2000)
('3','2'300)
('4','3',40)
('a','',4000)
('b','a',2000)
('c','b' 300)
('d','c',40)
题目
注意点:一个部门的人数是包含下级所有部门的人数，一个HR可以同时负责多个部门，包括负责上下级部门，且部门信息表中部门层级不固定
 */
-- select 11500+2400-1800-1200;
with hrd as (select 'har1' as hr_id, '2' as dept_id
             union all
             select 'har1' as hr_id, '3' as dept_id
             union all
             select 'har1' as hr_id, '4' as dept_id
             union all
             select 'har2' as hr_id, 'b' as dept_id
             union all
             select 'har2' as hr_id, 'c' as dept_id
             union all
             select 'har2' as hr_id, 'd' as dept_id),
     dept as (select '1' as dept_id, '' as dept_parent_id, 5000 as emp_cnt
              union all
              select '2' as dept_id, '1' as dept_parent_id, 2000 as emp_cnt
              union all
              select '3' as dept_id, '2' as dept_parent_id, 300 as emp_cnt
              union all
              select '4' as dept_id, '3' as dept_parent_id, 40 as emp_cnt
              union all
              select 'a' as dept_id, '' as dept_parent_id, 4000 as emp_cnt
              union all
              select 'b' as dept_id, 'a' as dept_parent_id, 2000 as emp_cnt
              union all
              select 'c' as dept_id, 'b' as dept_parent_id, 300 as emp_cnt
              union all
              select 'd' as dept_id, 'c' as dept_parent_id, 40 as emp_cnt),
     -- 两表关联
     t1 as (select hr_id, hrd.dept_id, dept_parent_id, emp_cnt
            from hrd
                     left join dept on hrd.dept_id = dept.dept_id),
     -- 每个hr所管理的部门合集
     t2 as (select hr_id, collect_list(dept_id) as dept_ids
            from t1
            group by hr_id),
     -- 判读每个hr所管理的部门，是不是他所管理部门的子部门
     t3 as (select t1.hr_id,
                   dept_id,
                   dept_ids,
                   dept_parent_id,
                   emp_cnt,
                   array_contains(dept_ids, dept_parent_id) as if_sub_dept_id
            from t1
                     left join t2 on t1.hr_id = t2.hr_id)
-- 为了防止重复累加，只累加当前hr所管理的最高父级部门
select hr_id, sum(emp_cnt) as sum_emp_cnt
from t3
where if_sub_dept_id = false
group by hr_id;




-- 应该重点突破的技术点:SR,Flink就可以了。数仓的内容就维度建模和SQL的编写


-- 数仓项目：
-- 要进行充分的业务调研和需求分析。这是数据仓库建设的基石，业务调研和需求分析做得是否充分直接决定了数据仓库建设是否成功。
-- 其次，进行数据总体架构设计，主要根据数据域对数据进行划分；按照维度建模理论，构建总线矩阵、抽出业务过程和维度。
-- 再次，对报表需求进行抽象整理出相关指标体系，使用 OneData 工具完成指标规范定义和模型设计。
-- 数仓搭建的前期工作：业务调研，需求分析，数据域的划分，总线矩阵的设计，指标体系怎么做的？
-- 业务调研：对业务系统的业务进行了解，政策运营系统，企业信息系统，知识产权系统，科研资源系统等
-- 需求分析：企业画像SDK的需求，企业基础的标签，类型，资质等。内部定义的企业标签。政策数据展示的需求，企业获取奖补的信息的获取。政策匹配的需求。
-- 需求分析主要与数据产品经理，数据分析师获取主要的需求
-- 知识产权数据，专利，软著，商标等数据的构建，与企业对应的关系。
-- 数据域划分：根据主要的几个系统，划分企业域，政策域，产业域，知识产权域，科研资源域，人才域，园区域。数据域划分的矩阵
-- 数据域需要抽象提炼，并且长期维护和更新，但不轻易变动。在划分数据域时，既能涵盖当前所有的业务需求，又能在新业务进入时无影响地被包含进已有的数据域中或者扩展新的数据域。
-- 总线矩阵怎么做的：1.明确每个数据域下有哪些业务过程；2.业务过程与哪些维度相关，并定义每个数据域下的业务过程和维度
-- 基础的指标体系：


-- 数仓搭建过程中：维度建模的内容，怎么设计维度表，事实表，拉链表怎么设计的。维度退化怎么做的
-- ODS操作数据层：数据同步清洗，保存历史
-- 公共维度模型层CDM（DWD明细数据层（明细事实数据）,DWS汇总数据层（公共指标汇总数据），DIM维表数据）
-- CDM的功能1：组合相关和相似数据：采用明细宽表，复用关联计算，减少数据扫描。
-- CDM的功能2：公共指标统 加工：基于 OneData 体系构建命名规范、口径和算法统一的统计指标，为上层数据产品、应用和服务提供公共指标 建立逻辑汇总宽表。
-- CDM的功能3：建立一致性维度：建立一致的数据分析维表，降低数据计算口径、算法不统一的风险。
-- 应用数据层（ADS）：
-- 个性化指标加工：不公用性、复杂性（指数型、比值型、排名型 指标）。
-- 基于应用的组装：大宽表集市、横表转纵表、趋势指标串。

-- 事实表：事务型事实表，周期快照型事实表，累积快照事实表 (DWD)
-- 公共维度表（DIM）
-- 公共汇总宽表层-面向分析主题建模 (DWS)
-- CDM层的一些简单的规范：1.高内聚，低耦合。2.数据可回滚（多次运行，结果一致）。3.命名清晰，可理解，一致性（表和字段命名清晰，相同含义字段在不同表命名要相同）
-- 1.选择业务过程。2.声明粒度。3.确定维度。4.确定事实
-- OneData理论：1.选择业务过程以及确定事实表类型。2.声明粒度。3.确定维度。4.确定事实。5.冗余维度（维度退化）
-- 案例：1.政策立项拆解全量周期快照事实表。2.粒度：一行数据表示企业所获的一个奖补。3.确定维度，确定粒度实际就确定了主键，企业id，政策id。主要的维度就是企业维度，政策维度。4.确定事实：奖补金额就是事实的度量值。5.把企业维度，政策维度常用的维度属性冗余

-- 维度是维度建模的基础和灵魂。怎样设计出企业级的一致性维度？
-- 维度的设计过程就是确定维度属性的过程，如何生成维度属性以及所生成维度属性的优劣，是数仓易用性的关键
-- 1.选择维度或者新建维度。2.确定主维表。3.确定相关维表。4.确定维度属性
-- 案例：1.选择政策维度。2.确定主维表（政策主表）。3.确定相关维表（政策分类，类型，地区，部门）4.确定维度属性，政策类型，政策分类，地区，部门，地区等

-- 拉链表怎么设计的？
-- 1.一般适用于缓慢变化的维度数据，比起全量数据来说，每天的新增不会很多，比如系统的用户表。
-- 2.维度建模理论中，处理缓慢变化维有三种方式：1.新的维度属性直接覆盖旧的维度属性，不保留历史数据；2.增加新的维度行；3.增加维度列，设计时包含两列，新属性和旧属性。（缺点：扩展性不好，保留历史数据有限）
-- 3.根据业务场景综合考虑下：我们采用增加新的维度行的方式来实现。然后就是要考虑到分区的的设计怎么合适。
-- 大概有四种方式，首先拉链表的话，我们一般都会给表添加一个start_date(开始时间)，end_date（结束时间）
-- 第一种：用start_date作为分区键。缺点：查询最新分区数据无法走分区;(select * from dwd.dwd_zip_tab where end_date='9999-12-31')
-- 查询某一天数据数据时，end_date无法走分区(select * from dwd.dwd_zip_tab where start_date='2024-07-19' and end_date='9999-12-31')
-- 加工历史拉链表数据时，end_date=9999-12-31的结果数据不方便入库
-- 第二种：使用end_date作为分区键。优点：查找最新数据可以走分区；（select * from dwd.dwd_zip_tab where end_date='9999-12-31'）
-- 加工历史拉链表数据时，方便入库，直接覆盖对应end_date即可。insert overwrite table dwd.dwd_zip_tab (partition (end_date = '9999-12-31'))
-- 缺点：查询某一天数据时start_date限制条件无法走分区 （select * from dwd.dwd_zip_tab where start_date='2020-01-31'）
-- 第三种：使用start_date和end_date作为联合分区键，start_date为父分区。优点：查询某一天的数据或者最新数据都可以走分区(优点是查询数据时start_date和end_date的限制条件都可以走分区)
-- （（比如当前日期是2020-04-01，SQL语句需改为select * from table_name where start_day <= ‘2020-04-01’ and end_day > '2020-04-01'，即查询最新数据的写法））
-- 缺点：缺点是加工历史拉链表数据时，end_date=9999-12-31和end_date=2020-02-01的结果数据都不方便入库；
-- 而且分区数会越来越多，一年下来最多可能产生365*364/2=66430个分区；
-- 第四种：使用start_date和end_date作为联合分区键，end_date为父分区。和方式三类似，主要区别是：
-- 加工历史拉链表数据时，结果数据入库相对方便（首先将结果数据存入临时表，然后清空拉链表的分区end_date=9999-12-31和end_date=2020-02-01，最后将临时表数据以insert into方式入库）
-- 综合四种方式来说：从第二种或者第四种选择方案
-- 第二种：查询某一天的维度状态数据，消耗的计算资源会越来越多。可考虑删除或者备份部分历史数据至其他地方。
-- 选择方式4，需要考虑随着时间的推移，分区数量会越来越多。可考虑定期重构历史拉链表，比如在每个月月初强制重新开始做历史拉链表（比如在20200401时，先将end_day=30001231的数据修改为end_day=20200401，再基于最新全量快照表生成一份start_day=20200401，end_day=30001231的数据）。
-- 选择方式2，因为需求主要是需要查询最新的数据


-- 数据同步的策略怎么设计，工作流调度的规划，数据质量有没有保障
-- 全量表：每日全量，就是每天存储一份完整数据，作为一个分区
-- 增量表：每日增量，就是每天存储一份增量数据，作为一个分区
-- 新增及变化表：存储新增加的数据和变化的数据，每日新增及变化，就是存储创建时间和操作时间都是今天的数据。
-- 工作流调度的规划，给个数据域之间的表，存在血缘的依赖，如何合理的规划数据工作流的之间的关系，
-- 数据表之间尽量解除耦合性，尽量实现单域数据，单块数据可以独立更新
-- 数据质量的保障，空值，数据量，数据量的波动，重点字段的波动情况
-- 数据批处理如何保障能在规定的时间出数据，没有DataWorks的基线功能，如何实现一个简单基线功能，实现预警，告警

-- 集群规模 25台datanode 每台24G可用内存。25*24=600G

-- dws层的怎么设计的，有印象很深的指标或者标签吗？怎么设计的


-- 科创服务平台
-- 是一个什么样的平台？

-- 对数仓1.0进行改造，改造了什么，优化了哪些方面，带来了哪些效果

-- UDF函数开发，举一个例子，开发逻辑，扩展UDTF,UDAF的开发方式
-- UDF开发：1.继承GenericUDF抽象类,重写initialize(),evaluate(),getDisplayString()方法即可。
-- 1.1 initialize(ObjectInspector[] arguments)方法主要 初始化此GenericUDF。这将被调用一次，并且每次只调用一次。return返回值的ObjectInspector。主要功能就是对入参的类型长度等进行判断，确定出参的类型
-- 1.2 evaluate(DeferredObject[] arguments) 方法，就是实现UDF的具体功能。
-- 1.3 getDisplayString(String[] children)方法，返回的是 explain 时展示的信息。（方法的源码的描述是这样）可以把children中的内容返回，出错时可以去到yarn查到日志（children数组就是当时数据传入的数据）
-- UDF开发：2.继承UDF类，重写evaluate()方法。一些简单临时的udf可以用这种方式，因为这种方式在高版本已经被弃用，不推荐。测试环境测试逻辑的时候可以适用（更快更简单）
-- 1.1 在evaluate()方法中编写代码逻辑。


-- UDTF开发：1.继承GenericUDTF抽象类,重写initialize(StructObjectInspector argOIs),process(Object[] objects),close()方法
-- 1.1 initialize方法可以校验传入参数类型是否合法。对返回的内容进行定义。
-- 1.2 完成initialize方法后，将每一行交给process()方法，每一行经过处理变成多行，传递给forward()，forward将结果带出
-- 1.3 close()方法。可以做一些收尾工作，关掉一些打开的资源。
-- 各个数据域之间的关系怎么打通

-- 利用StarRocks做了哪些事情？怎么把OLAP平台推广起来，怎么给其他部门

-- 引入kafka+flink+SR的实时架构，你有哪些想法，具体怎么实施，能带来哪些价值。

-- 介绍你们的数据资产，怎么让他们更好的利用起来。


-- 1.MR,SPARK,FLINK任务提交方式。对比记忆
-- 2.MR，SPARK shuffl的流程，对比记忆
-- 3.HDFS的小文件处理，读写流程
-- 1.写数据8步，读数据4步
-- 4.mysql的一些问题
-- 4.1 innodb和myisam的区别
-- 4.2 btree 和b+tree索引的区别
-- 4.3 Row size too large。记录长度超过65535字节。建表时遇到的问题
-- 4.4 mysql根据配置文件会限制server接受的数据包大小。max_allowed_packet，字段内容超出限制会报错
-- 4.5 timestamp的默认值问题
-- 5.项目内容还是重点吧，把项目梳理一遍，突出重点


---
title: Linux
date: 2021-05-11 18:43:10
tags:
- Linux
categories:
- 大数据
index_img: https://tse3-mm.cn.bing.net/th/id/OIP.MRvVM6gs0F-4wBqhEvbhogHaNK?w=115&h=186&c=7&o=5&dpr=1.25&pid=1.7
banner_img: https://tse3-mm.cn.bing.net/th/id/OIP.MRvVM6gs0F-4wBqhEvbhogHaNK?w=115&h=186&c=7&o=5&dpr=1.25&pid=1.7
---
# Linux

## vim的三种模式

### 一般模式
  - 以vi/vim编辑器打开一个文件就进入了一般默认，是默认的默认
  - 在一般模式中可以对文件进行复制、粘贴、删除、撤销
  - 常用的命令
    - yy
      - 复制一行
    - y数字y
      - 复制多行
    - dd
      - 删除一行
    - d数字d
      - 删除多行
    - p
      - 粘贴
    - u
      - 撤销
    - ^
      - 回到行头
    - $
      - 回到行尾
    - gg或1+G
      - 回到页头
    - G
      - 回到页尾
    - 数字+G
      - 回到某一行
### 编辑模式
  - 在一般模式中输入i、o、a或I、O、A时就进入了编辑模式
  - 在编辑模式中按Esc又回到一般模式
  - 常用的命令
    - i
      - 在光标前插入
    - o
      - 在下一行插入
### 命令模式
  - 在一般模式中输入:、/或？时就进入了命令模式
  - 在命令模式中按Esc又回到一般模式
  - 常用的命令
    - :w
      - 保存
    - :q
      - 推出
    - :!
      - 强制执行
    - :wq！
      - 保存并强制退出
    - ZZ
      - 如果没有修改直接退出，修改了保存后退出
    - :%s/old 字符/new 字符
      - 批量替换字符
    - :nohl
      - 取消高亮显示
    - /要查找的词或?要查找的词
      - 通过n或N进行向上或向下的查找
    - :set nu
      - 设置显示行号
    - :set nonu
      - 取消显示行号

## 网络相关命令

- ifconfig
  - 查询ip地址
- hostname
  - 查看主机名
  - 修改主机名
    - vim /etc/sysconfig/network
  - 配置ip地址与主机名的映射关系
    - vim /etc/hosts
- service 管理后台服务
  - service 服务名 start
    - 开启某个服务
  - service 服务名 stop
    - 关闭某个服务
  - service 服务名 status
    - 查看服务的状态
- chkconfig 查看开机启动状态
  - chkconfig 服务名 on
    - 开启某个服务开机自启
  - chkconfig 服务名 off
    - 关闭某个服务开机自启
  - chkconfig 服务名 --list
    - 查看某个服务的开机自启状态
    - 一共有7个运行级别（0到6）
      - 如果2、3、4、5这四个运行级别是开启的则当前服务就是开机自启的

## 帮助相关命令

- man和help
  - 查询命令的帮助信息
- 常用的快捷键
  - ctrl + l
    - 清屏
  - ctrl + c
    - 停止进程
  - 一定要善用Tab键
    - 可以帮助我们自动补全路径，防止出错
  - 通过上下键查询最近输入过的命令
  - ctrl + alt
    - 鼠标在虚拟机之间和主机之间切换

## 文件相关命令

- pwd
  - 查看当前所在的工作目录
- cd
  - 进入某个目录
    - 通过绝对路径和相对路径都可以进入某个目录
  - cd -
    - 返回上一次所在的目录
  - cd或cd ~
    - 回到自己的家目录
- rm -rf 
  - 强制删除文件或目录，不提示
- touch 文件名
  - 创建一个空文件
- mkdir
  - 创建目录
- echo "要输出的内容"
  - 输出内容到控制台
- cat 文件
  - 查看小文件
- less 文件
  - 查看大文件
    - 通过pageup和pagedown键翻页
- cp 源文件 目录
  - 将某个文件复制到某个目录下
- mv
  - mv 老名字 新名字
    - 给文件重命名
  - mv 源文件 目录
    - 剪切文件到某个目录下

## 搜索查找类命令

- find 某个目录 [选项] 内容
  - 在某个目录下查找相关内容
  - 选项
    - -name 
      - 根据文件名称查找
    - -user
      - 根据文件所属的用户查找
    - -size
      - 根据文件的大小查找
- grep
  - 通常结合管道符 | 进行过滤查找
  - ll /root | grep -n atguigu.txt
    - 查找/root目录下是否包含atguigu.txt文件，并且会显示出行号
- which
  - 查询某个命令在那个目录下

## 压缩解压缩类命令

- tar -zcvf  xxx.tar.gz 要压缩的内容
  - 压缩文件
- tar -zxvf xxx.tar.gz
  - 解压缩tar包

## 进程线程类命令

- ps -aux | grep xxx
  - 查看内存和CPU的占用率
- ps -ef | grep xxx
  - 查看进程和父进程的ID
- kill -9 进程ID
  - 通过进程ID杀死进程
- killall 进程名
  - 通过进程名杀死进程
- netstat -nlp | grep 端口号
  - 查看端口号是否被占用

## RPM软件包和YUM仓库

- rpm -qa
  - 查询安装的所有的rpm软件包
- rpm -qa | grep 软件名
  - 查询安装的某个软件的rpm软件包名
- rpm -e --nodeps rpm软件包名
  - 不检查依赖协助某个rpm软件包
- rpm -ivh rpm软件包名
  - 安装rpm软件包
- yum -y install
  - 安装rpm软件包
- yum -y update
  - 更新rpm软件包
- yum -y check-update
  - 检查某个rpm软件包是否有更新
- yum -y remove
  - 卸载rpm软件包
- yum list
  - 查询所有缓存的rpm软件包
- yum clean all
  - 清除缓存
- yum makecache
  - 建立缓存
- yum deplist
  - 显示yum软件包的所有依赖关系

## 文件权限管理
- 文件属性
  - Linux系统是一种典型的多用户系统，不同的用户处于不同的地位，拥有不同的权限。为了保护系统的安全性，Linux系统对不同的用户访问同一文件（包括目录文件）的权限做了不同的规定。在Linux中我们可以使用ll或者ls -l命令来显示一个文件的属性以及文件所属的用户和组。
  - [![ga5mY6.md.png](https://z3.ax1x.com/2021/05/11/ga5mY6.md.png)](https://imgtu.com/i/ga5mY6)
  - 首位表示类型
    - 符号 - 代表文件
    - 符号 d 代表目录
    - 符号 l 代表链接文档
  - 第1-3位确定属主（该文件的所有者）拥有该文件的权限。---User 
  - 第4-6位确定属组（所有者的同组用户）拥有该文件的权限，---Group 
  - 第7-9位确定其他用户拥有该文件的权限 ---Other 
- chmod修改权限
  - 方式一：
    - chmod  [{ugoa}{+-=}{rwx}] 文件或目录 
    - chmod g+x houge.txt
    - chmod u-x,o+x houge.txt
  - 方式二：
    - chmod  [mode=421 ]  [文件或目录]
    - u:所有者  g:所有组  o:其他人  a:所有人(u、g、o的总和)
    - r=4 w=2 x=1        rwx=4+2+1=7 
    - chmod 777 houge.txt

## Crontab调度

* 基本语法

  - crontab -e：修改crontab文件。如果文件不存在会自动创建
  - crontab -l：显示crontab文件
  - crontab -r：删除crontab文件
  - crontab -ir：删除crontab文件前提醒用户

* 脚本加执行权限

  ````shell
  sudo chmod +x my.sh
  ````

* 时间显示

* ```
  例子：
      # 每月的最后1天
      0 0 L * * *
  
      说明：
      Linux
      *    *    *    *    *
      -    -    -    -    -
      |    |    |    |    |
      |    |    |    |    +----- day of week (0 - 7) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
      |    |    |    +---------- month (1 - 12) OR jan,feb,mar,apr ...
      |    |    +--------------- day of month (1 - 31)
      |    +-------------------- hour (0 - 23)
      +------------------------- minute (0 - 59)
  ```

* 

* | 字段         | 是否必填 | 允许值          | 允许特殊字符 | 备注                                                         |
  | :----------- | :------- | :-------------- | :----------- | :----------------------------------------------------------- |
  | Seconds      | 是       | 0–59            | `*,-`        | 标准实现不支持此字段。                                       |
  | Minutes      | 是       | 0–59            | `*,-`        |                                                              |
  | Hours        | 是       | 0–23            | `*,-`        |                                                              |
  | Day of month | 是       | 1–31            | `*,-?LW`     | `?LW`只有部分软件实现了                                      |
  | Month        | 是       | 1–12 or JAN–DEC | `*,-`        |                                                              |
  | Day of week  | 是       | 0–7 or SUN–SAT  | `*,-?L#`     | `?L#`只有部分软件实现了 Linux和Spring的允许值为0-7，0和7为周日 Quartz的允许值为1-7，1为周日 |
  | Year         | 否       | 1970–2099       | `*,-`        | 标准实现不支持此字段。                                       |

* 标准字段
  - `,`用于分隔列表。例如，在第5个字段（星期几）中使用`MON,WED,FRI`表示周一，周三和周五
  - `-`字符定义范围。例如，`2000-2010`，表示2000年至2010年期间的每年，包括2000年和2010年
* 非标准字段
  - **“L”**代表“Last”
  - “day of month”字段可以使用**“W”**字符。指定最接近给定日期的工作日（星期一-星期五）
  - 分钟字段设置 `*/5`表示每5分钟一次，注意：这里指的是能被5整除的分钟数。


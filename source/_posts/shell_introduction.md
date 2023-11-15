---
title: shell介绍
date:
updated:
tags:
- shell
- 大数据
categories:
- 大数据
index_img: https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1709216491,2536617744&fm=26&gp=0.jpg
banner_img: https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1709216491,2536617744&fm=26&gp=0.jpg
---
# shell介绍

## shell简介

- shell是一个命令行解释器，它接受应用程序或者用户命令，然后调用操作系统内核

- Linux提供的解释器有：

  ````shell
  [root@hadoop101 ~]$ cat /etc/shells 
  /bin/sh
  /bin/bash
  /sbin/nologin
  /bin/dash
  /bin/tcsh
  /bin/csh
  ````

- Centos默认的解析器是bash

- bash和sh的关系：sh是引用了bash，最终sh实际上还是bash命令

  ````shell
  [root@hadoop101 bin]$ ll | grep bash
  -rwxr-xr-x. 1 root root 941880 5月  11 2016 bash
  lrwxrwxrwx. 1 root root      4 5月  27 2017 sh -> bash
  ````

  

## shell脚本基本格式

- 脚本以<font color=red>#!/bin/bash</font>开头

  ````shell
  [root@hadoop101 datas]$ touch helloworld.sh
  [root@hadoop101 datas]$ vi helloworld.sh
  
  在helloworld.sh中输入如下内容
  #!/bin/bash
  echo "helloworld"
  ````

- 执行方式

  - 采用bash或sh+脚本的相对路径或绝对路径（不用赋予脚本+x权限）

    ````shell
    sh helloworld.sh
    bash helloworld.sh
    ````

    

  - 采用输入脚本的绝对路径或相对路径执行脚本（必须具有可执行权限+x）

    ````shell
    chmod +x helloworld.sh
    ````

    

- 第一种执行方法，本质是bash解析器帮你执行脚本，所以脚本本身不需要执行权限。第二种执行方法，本质是脚本需要自己执行，所以需要执行权限。

## shell中的变量

### 系统变量

- 常用系统变量

  ````shell
  [root@hadoop101 datas]$ echo $HOME
  /home/atguigu
  # 常用系统变量 $HOME、$PWD、$SHELL、$USER
  #显示当前shell中所有变量
  set
  ````

  

### 自定义变量

- （1）定义变量：变量=值 

  （2）撤销变量：unset 变量

  （3）声明静态变量：readonly变量，注意：不能unset

  ````shell
  [root@hadoop101 datas]$ A=5
  [root@hadoop101 datas]$ echo $A
  5
  [root@hadoop101 datas]$ unset A
  [root@hadoop101 datas]$ echo $A
  ````

### 特殊变量

````shell
#	$n	（功能描述：n为数字，$0代表该脚本名称，$1-$9代表第一到第九个参数，十以上的参数，十以上的参数需要用大括号包含，如${10}）
# $#	（功能描述：获取所有输入参数个数，常用于循环）。
#	$*	（功能描述：这个变量代表命令行中所有的参数，$*把所有的参数看成一个整体）
#	$@	（功能描述：这个变量也代表命令行中所有的参数，不过$@把每个参数区分对待）
# $？	（功能描述：最后一次执行的命令的返回状态。如果这个变量的值为0，证明上一个命令正确执行；如果这个变量的值为非0（具体是哪个数，由命令自己来决定），则证明上一个命令执行不正确了。）

````



## 运算符

````shell
#（1）“$((运算式))”或“$[运算式]”
#（2）expr  + , - , \*,  /,  %    加，减，乘，除，取余
#注意：expr运算符间要有空格
expr 2 + 3
````



## 条件判断

````shell
#[ condition ]（注意condition前后要有空格）
#注意：条件非空即为true，[ atguigu ]返回true，[] 返回false。
#两个整数之间比较
#2. 常用判断条件
字符串比较

字符串比较：
    =       等于,如:if [ "$a" = "$b" ]
    ==     等于,如:if [ "$a" == "$b" ], 与=等价
               注意:==的功能在[[]]和[]中的行为是不同的,如下:
               1 [[ $a == z* ]]    # 如果$a以"z"开头(模式匹配)那么将为true
               2 [[ $a == "z*" ]] # 如果$a等于z*(字符匹配),那么结果为true
               3
               4 [ $a == z* ]      # File globbing 和word splitting将会发生
               5 [ "$a" == "z*" ] # 如果$a等于z*(字符匹配),那么结果为true

    !=      不等于,如:if [ "$a" != "$b" ]， 这个操作符将在[[]]结构中使用模式匹配.
    <       小于,在ASCII字母顺序下.如:
               if [[ "$a" < "$b" ]]
               if [ "$a" \< "$b" ]     在[]结构中"<"需要被转义.
    >       大于,在ASCII字母顺序下.如:
           if [[ "$a" > "$b" ]]
           if [ "$a" \> "$b" ]  在[]结构中">"需要被转义.
    -z       字符串为"null".就是长度为0.
    -n       字符串不为"null"
#（1）两个整数之间比较
#-lt 小于（less than）			-le 小于等于（less equal）
#-eq 等于（equal）				-gt 大于（greater than）
#-ge 大于等于（greater equal）	-ne 不等于（Not equal）
#（2）按照文件权限进行判断
#-r 有读的权限（read）			-w 有写的权限（write）
#-x 有执行的权限（execute）
#（3）按照文件类型进行判断
#-f 文件存在并且是一个常规的文件（file）
#-e 文件存在（existence）		-d 文件存在并是一个目录（directory）
````

## 流程控制

- if语句

````shell
#（1）[ 条件判断式 ]，中括号和条件判断式之间必须有空格
#（2）if后要有空格
#!/bin/bash

if [ $1 -eq "1" ]
then
        echo "banzhang zhen shuai"
elif [ $1 -eq "2" ]
then
        echo "cls zhen mei"
fi

````

- case语句

  ````shell
  #1)case行尾必须为单词“in”，每一个模式匹配必须以右括号“）”结束。
  #2)双分号“;;”表示命令序列结束，相当于java中的break。
  #3)最后的“*）”表示默认模式，相当于java中的default。
  #!/bin/bash
  
  case $1 in
  "1")
          echo "banzhang"
  ;;
  
  "2")
          echo "cls"
  ;;
  *)
          echo "renyao"
  ;;
  esac
  ````

  

- for循环

  ````shell
  # 基本语法一：
  #!/bin/bash
  
  s=0
  for((i=0;i<=100;i++))
  do
          s=$[$s+$i]
  done
  # 基本语法二：
  #!/bin/bash
  #打印数字
  
  for i in $*
      do
        echo "ban zhang love $i "
      done
  ````

  

- while循环

  ````shell
  # while循环从1叫到100
  #!/bin/bash
  s=0
  i=1
  while [ $i -le 100 ]
  do
          s=$[$s+$i]
          i=$[$i+1]
  done
  
  echo $s
  ````

  

## read读取控制台输入

````shell
#	read(选项)(参数)
#	选项：
#-p：指定读取值时的提示符；
#-t：指定读取值时等待的时间（秒）。
#参数
#	变量：指定读取值的变量名
#
#
#!/bin/bash

read -t 7 -p "Enter your name in 7 seconds " NAME
echo $NAME
````

## 函数

- 系统函数

- basename [string / pathname] [suffix]  （功能描述：basename命令会删掉所有的前缀包括最后一个（‘/’）字符，然后将字符串显示出来。

- 选项：

  suffix为后缀，如果suffix被指定了，basename会将pathname或string中的suffix去掉。

  ````shell
  [root@hadoop101 datas]$ basename /home/atguigu/banzhang.txt 
  banzhang.txt
  [root@hadoop101 datas]$ basename /home/atguigu/banzhang.txt .txt
  banzhang
  ````

- dirname 文件绝对路径		（功能描述：从给定的包含绝对路径的文件名中去除文件名（非目录的部分），然后返回剩下的路径（目录的部分））

  ````shell
  [root@hadoop101 ~]$ dirname /home/atguigu/banzhang.txt 
  /home/atguigu
  ````

- 自定义函数

  ````shell
  #1．基本语法
  #[ function ] funname[()]
  #{
  #	Action;
  #	[return int;]
  #}
  #funname
  #2．经验技巧
  #	（1）必须在调用函数地方之前，先声明函数，shell脚本是逐行运行。不会像其它语言一样先编译。
  #	（2）函数返回值，只能通过$?系统变量获得，可以显示加：return返回，如果不加，将以最后一条#命令运行结果，作为返回值。return后跟数值n(0-255)
  #!/bin/bash
  function sum()
  {
      s=0
      s=$[ $1 + $2 ]
      echo "$s"
  }
  
  read -p "Please input the number1: " n1;
  read -p "Please input the number2: " n2;
  sum $n1 $n2;
  ````

  

## shell工具

### cut

- cut:cut的工作就是“剪”，具体的说就是在文件中负责剪切数据用的。cut 命令从文件的每一行剪切字节、字符和字段并将这些字节、字符和字段输出。

- cut [选项参数]  filename     说明：默认分隔符是制表符

- | 选项参数 | 功能                         |
  | :------- | ---------------------------- |
  | -f       | 列号，提取第几列             |
  | -d       | 分隔符，按照指定分隔符分割列 |
  | -c       | 指定具体字符                 |

  ```shell
  [root@hadoop101 datas]$ touch cut.txt
  [root@hadoop101 datas]$ vim cut.txt
  dong shen
  guan zhen
  wo  wo
  lai  lai
  le  le
  
  [root@hadoop101 datas]$ cut -d " " -f 2,3 cut.txt 
  shen
  zhen
   wo
   lai
   le
   
   [root@hadoop101 datas]$ cut -d " " -f 1 cut.txt 
  dong
  guan
  wo
  lai
  le
  
  [root@hadoop101 datas]$ cat cut.txt | grep "guan" | cut -d " " -f 1
  guan
  ```

  

### sed

* sed是一种流编辑器，它一次处理一行内容。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”，接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有改变，除非你使用重定向存储输出。

* 1. 基本用法

  sed [选项参数]  ‘command’  filename

  2. 选项参数说明

  

  | 选项参数 | 功能                                  |
  | -------- | ------------------------------------- |
  | -e       | 直接在指令列模式上进行sed的动作编辑。 |
  | -i       | 直接编辑文件                          |

  3. 命令功能描述

  

  | 命令  | 功能描述                                              |
  | ----- | ----------------------------------------------------- |
  | **a** | 新增，a的后面可以接字串，在下一行出现,a前面可以指定行 |
  | d     | 删除                                                  |
  | s     | 查找并替换                                            |

- command中可以匹配正则表达式

  ````shell
  # 将“mei nv”这个单词插入到sed.txt第二行下，打印。
  [root@hadoop102 datas]$ sed '2a mei nv' sed.txt 
  dong shen
  guan zhen
  mei nv
  wo  wo
  lai  lai
  le  le
  # 文件内容并没有改变
  [root@hadoop102 datas]$ cat sed.txt 
  dong shen
  guan zhen
  wo  wo
  lai  lai
  le  le
  # 注意：‘g’表示global，全部替换
  [atguigu@hadoop102 datas]$ sed 's/wo/ni/g' sed.txt 
  dong shen
  guan zhen
  ni  ni
  lai  lai
  le  le
  
  ````

  

### awk

* 一个强大的文本分析工具，把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行分析处理。

* 1. 基本用法

  awk [选项参数] ‘pattern1{action1} pattern2{action2}...’ filename

  pattern：表示AWK在数据中查找的内容，就是匹配模式

  action：在找到匹配内容时所执行的一系列命令

  2. 选项参数说明

  | 选项参数 | 功能                 |
  | -------- | -------------------- |
  | -F       | 指定输入文件折分隔符 |
  | -v       | 赋值一个用户定义变量 |

  ````shell
  
  #（1）搜索passwd文件以root关键字开头的所有行，并输出该行的第7列。
  [root@hadoop102 datas]$ awk -F: '/^root/{print $7}' passwd 
  /bin/bash
  #（2）搜索passwd文件以root关键字开头的所有行，并输出该行的第1列和第7列，中间以“，”号分割。
  [root@hadoop102 datas]$ awk -F: '/^root/{print $1","$7}' passwd 
  root,/bin/bash
  #注意：只有匹配了pattern的行才会执行action
  #（3）只显示/etc/passwd的第一列和第七列，以逗号分割，且在所有行前面添加列名user，shell在#最后一行添加"dahaige，/bin/zuishuai"。
  [root@hadoop102 datas]$ awk -F : 'BEGIN{print "user, shell"} {print $1","$7} END{print "dahaige,/bin/zuishuai"}' passwd
  user, shell
  root,/bin/bash
  bin,/sbin/nologin
  。。。
  atguigu,/bin/bash
  dahaige,/bin/zuishuai
  #注意：BEGIN 在所有数据读取行之前执行；END 在所有数据执行之后执行。
  #（4）将passwd文件中的用户id增加数值1并输出
  [root@hadoop102 datas]$ awk -v i=1 -F: '{print $3+i}' passwd
  1
  2
  3
  4
  ````

- awk的内置变量

  | 变量     | 说明                                   |
  | -------- | -------------------------------------- |
  | FILENAME | 文件名                                 |
  | NR       | 已读的记录数                           |
  | NF       | 浏览记录的域的个数（切割后，列的个数） |

### sort

- sort命令是在Linux里非常有用，它将文件进行排序，并将排序结果标准输出。

- 基本语法

  sort(选项)(参数)

| 选项 | 说明                     |
| ---- | ------------------------ |
| -n   | 依照数值的大小排序       |
| -r   | 以相反的顺序来排序       |
| -t   | 设置排序时所用的分隔字符 |
| -k   | 指定需要排序的列         |

参数：指定待排序的文件列表
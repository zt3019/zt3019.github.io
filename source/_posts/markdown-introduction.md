---
title: Markdown语法介绍
date:
updated:
tags:
- Blog
categories:
- Blog
index_img: 
https://tse1-mm.cn.bing.net/th/id/R-C.8d7bf15d009a53c6cda164bb4ecfe3f3?rik=zGSkSlp5E6L7RA&riu=http%3a%2f%2ffile.qqtouxiang.com%2fpic%2fwm%2f2020-07-20%2fea9e0624c5bcf82506b486ec8d3a14eb.jpeg&ehk=8rZo4a5OqRimf%2f%2bZwpcpe6tMXwo0%2bpTKVXJXqe95TRw%3d&risl=&pid=ImgRaw&r=0
banner_img: 
https://tse1-mm.cn.bing.net/th/id/R-C.8d7bf15d009a53c6cda164bb4ecfe3f3?rik=zGSkSlp5E6L7RA&riu=http%3a%2f%2ffile.qqtouxiang.com%2fpic%2fwm%2f2020-07-20%2fea9e0624c5bcf82506b486ec8d3a14eb.jpeg&ehk=8rZo4a5OqRimf%2f%2bZwpcpe6tMXwo0%2bpTKVXJXqe95TRw%3d&risl=&pid=ImgRaw&r=0
---
# markdow语法的简单介绍

> + 第一项：markdown标题  
>>    + 用“#”号的个数来表示标题的级数
>>    * 使用 = 和 - 标记一级和二级标题
> * 第二项：段落格式
>>    + Markdown 段落没有特殊的格式  
直接编写文字，**段落的换行是使用两个以上空格加回车,也可以在段落后面使用一个空行来表示重新开始一个段落**  
>>    * ***字体：***  
markdown可以使用斜体文本（一个*或_在文字的两边），粗体文本（两个*或_在文字的两边），粗斜体文本（三个）    
*斜体文本*    
_斜体文本_    
**粗体文本**    
__粗体文本__    
***粗斜体文本***    
___粗斜体文本___    
>>    * ***分隔线：***    
你可以在一行中用三个以上的星号、减号、底线来建立一个分隔线，行内不能有其他东西。你也可以在星号或是减号中间插入空格。    
***
---
* * * * *

>>    * ***删除线：***    
删除线： 如果段落上的文字要添加删除线，只需要在文字的两端加上两个波浪线 ~~ 即可    
~~删除线~~
>>    * **下划线：**
下划线可以通过 HTML 的 <u> 标签来实现</u>    
<u>下划线</u>
>>    * **脚注：**
脚注是对文本的补充说明。    
创建脚注格式类似这样 [^RUNOOB]。    
[^RUNOOB]: 菜鸟教程 -- 学的不仅是技术，更是梦想！！！
>* 第三项：列表   
无序列表使用星号(*)、加号(+)或是减号(-)作为列表标记，这些标记后面要添加一个空格，然后再填写内容     
>>    * **嵌套列表：**    
列表嵌套只需在子列表中的选项前面添加四个空格即可    
>* 第四项：**区块**    
Markdown 区块引用是在段落开头使用 > 符号 ，然后后面紧跟一个空格符号    
另外区块是可以嵌套的，一个 > 符号是最外层，两个 > 符号是第一层嵌套，以此类推  
区块中可以使用列表，列表中也可以使用区块
>* 第五项：**markdown代码**    
`printf()`函数    
如果是段落上的一个函数或片段的代码可以用反引号把它包起来(`)    
>>    * 代码区块：   
     四个空格或者制表符（代码区块使用 4 个空格或者一个制表符（Tab 键）。）      
 ![展示](https://www.runoob.com/wp-content/uploads/2019/03/6DC89E5C-B41A-4938-97D8-D7D06B879F91.jpg "结果展示")
 你也可以用 ``` 包裹一段代码，并指定一种语言（也可以不指定）    
```c    
include <bits/stdc++.h>    
int main(){    
        cout<<"hello world"<<endl;    
    return 0;    
}    
```
> * **第六项：Markdown 链接:**    
参考[菜鸟教程](https://www.runoob.com/markdown/md-tutorial.html)
> * **第七项：markdown 表格**
Markdown 制作表格使用 | 来分隔不同的单元格，使用 - 来分隔表头和其他行。  

|  表头   | 表头  |
|  ----  | ----  |
| 单元格  | 单元格 |
| 单元格  | 单元格 |
我们可以设置表格的对齐方式：

    -: 设置内容和标题栏居右对齐。
    :- 设置内容和标题栏居左对齐。
    :-: 设置内容和标题栏居中对齐。
    
| 左对齐 | 右对齐 | 居中对齐 |
| :-----| ----: | :----: |
| 单元格 | 单元格 | 单元格 |
| 单元格 | 单元格 | 单元格 |
> * **第八项：markdown高级技巧**    
参考连接[菜鸟教程](https://www.runoob.com/markdown/md-advance.html)
***
***
本文参考菜鸟教程的markdown教学，超链接上文已给出。（https://www.runoob.com/markdown/md-tutorial.html）
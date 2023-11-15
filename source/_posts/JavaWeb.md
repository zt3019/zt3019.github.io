---
title: JavaWeb
date: 2021-05-26 19:49:21
tags:
- Java
categories: 
- Java
index_img: https://img.zcool.cn/community/01c8f15aeac135a801207fa16836ae.jpg@1280w_1l_2o_100sh.jpg
banner_img: https://img.zcool.cn/community/01c8f15aeac135a801207fa16836ae.jpg@1280w_1l_2o_100sh.jpg
---



# JavaWeb

## 网页的组成

- 结构（HTML)
  - 超文本标记语言
  - 网页的主要内容通过html来实现
  - 用来写网页的语言
- 表现（CSS)
  - 层叠样式表
  - 网页的字体颜色、背景色、背景图片等通过它来实现
  - 用来美化网页
- 行为（JavaScript/jQuery）
  - 用来实现网页上的一下动态的效果
- 一个良好的网页要求结构、表现、行为三者分离

## HTML

- 常用的标签

  - 标题标签

    - 一共六个（h1到h6）

    ```html
    <h1>
        一级标题
    </h1>
    <h2>
        二级标题
    </h2>
    ...
    <h6>
        六级标题
    </h6>
    ```

  - 超链接

    - 通过a标签创建一个超链接

      - 通过a标签中的href属性指定要跳转的页面的地址

      ```html
      <a href="设置要跳转的页面的地址">我是超链接</a>
      ```

  - 表格

    - 通过table标签创建一个表格
      - 表格中的行通过tr标签来表示
        - 表格中的表头通过th标签来表示
        - 表格中的列（单元格）通过td标签来标签
          - 通过rowspan属性跨行合并单元格
          - 通过colspan属性跨列合并单元格

    ```html
    <table>
        <tr>
        	<th>姓名</th>
            <th>性别</th>
            <th>年龄</th>
        </tr>
        <tr>
        	<td>盖伦</td>
            <td>男</td>
            <td>19</td>
        </tr>
    </table>
    ```

  - 表单

    - 使用form标签创建一个表单
      - 通过action属性指定要提交的服务器的地址
      - 通过method属性指定提交的请求方式
      - 通过input标签创建表单项
        - type值是text的是文本框
        - type值是password的是密码框
        - type值是submit的是提交按钮
        - type值不可用任意指定，通过alt+/根据提示选择
        - 必须给input指定name属性值
          - name属性值可用任意指定

    ```html
    <!-- 通过form标签创建一个表单 
    		action属性：设置要提交的服务器的地址
    		method属性：设置请求方式
    			get：将发送一个GET请求，此时用户输入的数据是通过浏览器的地址栏进行传输
    			post：将发送一个POST请求，此时用户输入的数据通过HTTP协议中请求报文中的请求体进行传输
    	-->
    	<form action="success.html" method="post">
    		<!-- 
    			表单中的表单项通过input标签来创建，表单项的类型通过type属性来指定；
    			必须给表单项指定name属性值，用户输入的数据通过name属性值进行携带，并以键值对的形式发送到
    			服务器，多个键值对之间使用 &符号分隔，例如：username=admin&password=123456
    		 -->
    		用户名称：<input type="text" name="username"><br>
    		用户密码：<input type="password" name="password"><br>
    		<!-- 提交按钮上显示的文字通过value指定 -->
    		<input type="submit" value="登录">
    	</form>
    ```

## CSS

- CSS样式可用书写的位置

  - 1）写在标签的style属性中

    - 结构与表现相耦合，不建议使用

    ```html
    <p style="color: red;font-size: ">我是一个段落</p>
    ```

    

  - 2）写在style标签中，style标签放在head标签中

    - 开发测试阶段使用这种方式

    ```html
    <style type="text/css">
    	#rd{
    		color: #FBA
    	}
    </style>
    ```

    

  - 3）引入外部的css文件

    - 项目上线后使用这种方式

    ```html
    <link rel="stylesheet" type="text/css" href="style.css" />
    ```

- CSS种的基本选择器

  - 标签选择器

  ```css
  h1 {
  	color: red
  }
  ```

  

  - ID选择器
    - 格式：#id属性值

  ```css
  #p1 {
  	color: green
  }
  ```

  

  - 类选择器
    - 格式：.class属性值

  ```css
  .p2 {
  	color: blue
  }
  ```

  

  - 分组选择器

  ```css
  #p1, .p2 {
  	font-size: 20px
  }
  ```

## JavaScript

- JavaScript可用书写的位置跟CSS类似，一共三种方式

- 变量

  - 通过var关键字声明一个变量
  - 在使用变量的过程种可用给它赋任意值

  ```javascript
  var a; a=123; a="hello";a=函数；a=对象；
  var a = "javascript";
  ```

- 函数

  - 通过function关键字声明一个函数
  - 在声明函数时不需要指定返回值的类型及形参的类型

  ```javascript
  //方式一：
  //不带参数的函数
  function fun(){
      //函数体
  }
  function sum(a,b){
      return a + b;
  }
  //方式二：
  var sum2 = function(a,b,c){
      return a + b + c;
  }
  //我们通常是通过方式二这种方式将一个函数赋给对象的事件属性
  ```

- DOM

  - 全称：Document Object Model，文档对象模型
  - DOM种常用的属性和方法
    - document.getElementById("id属性值")
      - 根据标签的id属性值获取一个具体的标签对象
    - 对象.innerHTML
      - 获取或设置成对出现的标签中的文本内容
        - 对象.innerHTML
          - 获取文本内容
        - 对象.innerHTML="new valule"
          - 设置文本内容
      - 在jQuery中与之对应的是text()/html()方法
    - 对象.onclick
      - 给对象绑定单击事件
      - 在jQuery中与之对应的是click()方法
    - 对象.onfocus
      - 给对象绑定获取焦点事件
      - 在jQuery中与之对应的是focus()方法
    - 对象.onblur
      - 给对象绑定失去焦点的事件
      - 在jQuery中与之对应的是blur()方法
    - 对象.onchange
      - 给对象内容改变的事件
      - 在jQuery中与之对应的是change()方法

## Servlet

- Servlet是服务器端的一个组件，用来处理用户的请求
- 直接new一个Sersvlet，然后配置映射的请求地址即可
- doGet和doPost方法中的两个参数request和response的作用
  - request的作用
    - 获取请求参数
    - 转发
    - 它是一个域对象
  - response的作用
    - 给浏览器响应一个字符串或一个页面
    - 重定向

```java
//处理GET请求的方法
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doGet方法被调用");
		//request的作用
		//1.获取请求参数
		/*
		 * GET请求的请求中文乱码问题的解决方案：
		 * 在Tomcat的配置文件server.xml中的第一个Connector标签中添加属性URIEncoding="UTF-8"
		 */
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		System.out.println(username);
		System.out.println(password);
		//2.转发
		//获取转发器
		RequestDispatcher requestDispatcher = request.getRequestDispatcher("WEB-INF/success.html");
		//进行请求的转发
		requestDispatcher.forward(request, response);
		//3.request是一个域对象（下回分解）
	}
	//处理POST请求的方法
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("doPost方法被调用");
		/*
		 * POST请求的请求中文乱码问题的解决方案：
		 * 在第一次获取请求参数之前，通过request设置字符集位UTF-8
		 */
		request.setCharacterEncoding("UTF-8");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		System.out.println(username);
		System.out.println(password);
		//response的作用
		//1.给浏览器响应一个字符串或一个页面
		/*
		 * 响应中文乱码的解决方案：
		 * 	在获取流之前设置内容的类型，内容的类型中包含UTF-8字符集
		 */
		response.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = response.getWriter();
//		writer.write("Response Success!");
//		writer.write("响应成功！");
//		writer.write("<!DOCTYPE html>\r\n" + 
//				"<html>\r\n" + 
//				"<head>\r\n" + 
//				"<meta charset=\"UTF-8\">\r\n" + 
//				"<title>Insert title here</title>\r\n" + 
//				"</head>\r\n" + 
//				"<body>\r\n" + 
//				"	<h1>请求处理成功！</h1>\r\n" + 
//				"</body>\r\n" + 
//				"</html>");
		//2.重定向
		response.sendRedirect("WEB-INF/success.html");
		
		/*
		 * 转发与重定向的区别：
		 * 	1.转发浏览器发送一次请求；重定向浏览器发送两次请求
		 * 	2.转发浏览器地址栏地址无变化；重定向浏览器地址栏地址有变化
		 * 	3.转发可以访问WEB-INF目录下的资源；重定向不可以访问WEB-INF目录下的资源
		 * 	4.转发可以共享request域中的数据；重定向不可以共享request域中的数据
		 */
	}

```

## JSP

- JSP必须运行服务器上，它本质上是一个Servlet

- HTML和Servlet能实现的功能JSP都可用实现

- JSP中的基本语法

  - JSP脚本片段
    - 格式：<%   %>
    - 作用：在里面写Java代码
  - JSP表达式
    - 格式：<%=  %>
    - 作用：用来输出对象

  ```jsp
  <%
  		for(int i = 0 ; i < 10 ; i++){
  			//out.print("伊朗要干美国了！");
  	%>
  	<h1>伊朗要干美国了！</h1>
  	<%	
  		}
  	%>
  
   <%="我是通过JSP表达式输出的" %>
  ```

- 四个域

  - page域
    - 范围：当前页面
    - 对应的域对象：pageContext
    - 域对象的类型：PageContext
  - request域
    - 范围：当前请求（一次请求）
    - 对应的域对象：request
    - 域对象的类型：HttpServletRequest
  - session
    - 范围：当前会话（一次会话）
    - 对应的域对象：session
    - 域对象的类型：HttpSession
  - application域
    - 范围：当前Web应用
    - 对应的域对象：application
    - 域对象的类型：ServletContext
  - 四个域对象都有以下三个方法
    - void setAttribute(String key , Object value)
    - Object getAttribute(String key)
    - void removeAttribute(String key)

  ```jsp
  <!-- 在当前页面中分别向四个域中添加四个属性 -->
  	 <%
  	 	pageContext.setAttribute("pageKey", "pageValue");
  	 	request.setAttribute("reqKey", "reqValue");
  	 	session.setAttribute("sessKey", "sessValue");
  	 	application.setAttribute("appKey", "appValue");
  	 %>
  	 <h1>在当前页面中分别获取四个域中的属性值</h1>
  	 page域中的属性值是：<%=pageContext.getAttribute("pageKey") %><br>
  	 request域中的属性值是：<%=request.getAttribute("reqKey") %><br>
  	 session域中的属性值是：<%=session.getAttribute("sessKey") %><br>
  	 application域中的属性值是：<%=application.getAttribute("appKey") %><br>
  ```

- EL

  - EL全称是Expression Language，是JSP的内置表达式
  - 格式：${表达式}
  - 作用：主要用来获取域对象中的属性值，用来代替JSP的表达式
  - EL表达式获取数据时才输出，获取不到数据则什么也不输出
  - EL中的四个Scope对象
    - pageScope
      - 获取page域中的属性值
    - requestScope
      - 获取request域中的属性值
    - sessionScope
      - 获取session域中的属性值
    - applicationScope
      - 获取application域中的属性值

  ```jsp
  <%
  	 	Date date = new Date();
  	 	//分别向四个域中添加四个属性
  	 	pageContext.setAttribute("date", date+"-");
  	 	request.setAttribute("date", date+"--");
  	 	session.setAttribute("date", date+"---");
  	 	application.setAttribute("date", date+"----");
  	 %>
  	 通过JSP表达式获取域对象中的属性值：<%=pageContext.getAttribute("date") %><br>
  	 通过EL表达式获取域对象中的属性值：${date }<br>
  	 通过EL表达式获取request域中的属性值：${requestScope.date }
  ```

## Ajax

- 全称：Asynchronous JavaScript And XML，通过JavaScript发送请求，使用XML作为响应数据，后来XML已经被另外一种数据格式JSON所替代

- 同步请求和异步请求的区别

  - 同步请求
    - 发送请求之后必须等待服务器的响应成功之后才能发送其他请求，有一个等待的过程
    - 响应成功之后会刷新整个页面
  - 异步请求
    - 发送请求之后无需等待服务器的响应即可发送其他请求
    - 响应成功之后不会刷新整个页面，可用局部更新页面中的内容

- 如果通过jQuery发送ajax请求

  - 使用$.ajax()方法发送Ajax请求

    - ajax()方法中的常用选项
      - url
        - 必须的。用来设置请求地址，值是一个字符串
      - type
        - 可选的。用来设置请求方式。GET或POST，默认是GET，值是一个字符串
      - data
        - 可选的。用来设置请求参数，值是一个字符串
      - success
        - 可选的。用来设置一个回调函数，当响应成功之后系统会自动调用该函数，响应数据会以参数的形式传入到该函数中
      - dataType
        - 可选的。用来设置响应数据的类型，如 text、json等

    ```javascript
    $.ajax({
    				url:"AjaxServlet",
    				type:"get",
    				data:"username=admin&password=123456",
    				success:function(res){
    					//将响应数据设置到span标签中
    					$("#msg").text(res);
    				},
    				dataType:"text"
    			});
    ```

  - JSON

    - JOSN格式
      - JSON对象
      - JSON数组
    - JSON中接受的数据类型
      - 字符串
      - 数字
      - null
      - 布尔类型
      - 数组
      - 对象
    - 在JS中JSON对象和JSON字符串之间的转换
      - JSON对象转JSON字符串
        - JSON.stringify(JSON对象)
      - JSON字符串转JSON对象
        - JSON.parse(JSON字符串)

    ```javascript
    //JSON的格式：
    	//1.JSON对象
    	//属性名必须使用双引号括起来；属性名和属性值之间使用冒号分隔；多个属性之间使用逗号分隔
    	var jsonObj = {"name":"孙悟空","age":520};
    // 	alert(jsonObj);
    	//2.JSON数组
    	var jsonArry = ["猪八戒",1500,true,null,jsonObj];
    	//获取jsonArry中的jsonObj中的age属性值
    // 	alert(jsonArry[4].age);
    	
    	//在JS中将JSON对象转换为JSON字符串
    	var objToStr = JSON.stringify(jsonObj);
    // 	alert(objToStr);
    	//声明一个JSON字符串
    	var jsonStr = '{"name":"唐僧","age":18}';
    // 	alert(jsonStr);
    	//在JS中将JSON字符串转换为JSON对象
    	var strToObj = JSON.parse(jsonStr);
    // 	alert(strToObj.name);
    ```

    - 在Java中对象与JSON字符串之间的转换

      - 借助于第三方工具json-lib、jackson、gson等可用将Java对象转换为JSON字符串，也可用将JSON字符串转换回Java对象

      - 通常是前端发送一个Ajax请求，在后台查询到对象之后将对象转换为JOSN字符串响应到前端

      - 通过发送Ajax请求接收JSON格式的响应数据

        - 前端代码

        ```javascript
        //发送Ajax请求接收JSON格式的响应数据
        			$.ajax({
        				url:"JSONServlet",
        				success:function(res){
        					alert(res.id);
        				},
        				dataType:"json"
        			});
        ```

        

        - 后端代码

        ```java
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
        			throws ServletException, IOException {
        		response.setContentType("text/html;charset=UTF-8");
        		//假设从数据库中查询到员工的信息
        		Employee employee = new Employee(1, "张三", "zhangsan@atguigu.com");
        		//创建Gson对象
        		Gson gson = new Gson();
        		//将Employee对象转换为JSON字符串
        		String json = gson.toJson(employee);
        		System.out.println(json);
        		//给浏览器响应一个JSON格式的字符串
        		response.getWriter().write(json);
        	}
        ```

        
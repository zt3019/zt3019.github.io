---
title: Java网络编程基础
date: 2021-04-23 09:29:34
tags:
- Java
- 网络编程
categories:
- Java
index_img: https://th.bing.com/th/id/OIP.rOyHYyDwWsrEtAShUh3ghQHaE8?w=296&h=197&c=7&o=5&dpr=1.25&pid=1.7
banner_img: https://th.bing.com/th/id/OIP.rOyHYyDwWsrEtAShUh3ghQHaE8?w=296&h=197&c=7&o=5&dpr=1.25&pid=1.7
---
# Java网络编程基础
## 实例代码
````Java
package network;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.time.LocalDateTime;

import org.junit.Test;

public class NetTest {
	@Test
	public void server3() {
		ServerSocket server = null;
		try {
			server = new ServerSocket(8888); // 绑定端口
			while (true) {
				System.out.println("服务器在8888端口监听中.....");
				final Socket socket1 = server.accept();
				;
				Runnable runner = new Runnable() {
					@Override
					public void run() {
						BufferedWriter bufferedWriter = null;
						try {
							bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket1.getOutputStream()));
							bufferedWriter.write("我是服务器, 现在时间 : " + LocalDateTime.now());
							bufferedWriter.newLine();
							bufferedWriter.flush(); // 把数据真的刷入网线中
						} catch (Exception e) {
							e.printStackTrace();
						} finally {
							if (bufferedWriter != null) {
								try {
									bufferedWriter.close();
								} catch (Exception e2) {
								}
							}
							if (socket1 != null) {
								try {
									socket1.close();
								} catch (Exception e2) {
								}
							}
						}
						try {
							Thread.sleep(5000);
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
					}
				};
				new Thread(runner).start();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			if (server != null) {
				try {
					System.out.println("服务器关闭....");
					server.close();
				} catch (Exception e2) {
				}
			}
		}
	}

	@Test
	public void client3() {
		Socket socket2 = null;
		BufferedReader bufferedReader = null;
		try {
			socket2 = new Socket("localhost", 8888);
			bufferedReader = new BufferedReader(new InputStreamReader(socket2.getInputStream()));
			String readLine = bufferedReader.readLine();
			System.out.println(readLine);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (Exception e2) {
				}
			}
			if (socket2 != null) {
				try {
					socket2.close();
				} catch (Exception e2) {
				}
			}
		}
	}

	// 从客户端发送文件给服务端，服务端保存到本地。并返回“发送成功”给客户端。并关闭相应的连接。
	@Test
	public void server2() {
		ServerSocket server = null;
		Socket socket1 = null;// 网络套接字

		InputStream nis = null;
		FileOutputStream fos = null;
		BufferedWriter netWriter = null;

		try {
			server = new ServerSocket(7777);// 指定服务器接口
			socket1 = server.accept();
			nis = socket1.getInputStream();
			fos = new FileOutputStream("朴树 - 猎户星座2.mp3");
			netWriter = new BufferedWriter(new OutputStreamWriter(socket1.getOutputStream()));

			byte[] buf = new byte[8192];
			int realCount = nis.read(buf);
			while (realCount != -1) {
				fos.write(buf, 0, realCount);
				realCount = nis.read(buf);
			}
			netWriter.write("发送成功");
			netWriter.newLine();
			netWriter.flush();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (netWriter != null) {
				try {
					netWriter.close();
				} catch (Exception e2) {
				}
			}
			if (fos != null) {
				try {
					fos.close();
				} catch (Exception e2) {
				}
			}
			if (nis != null) {
				try {
					nis.close();
				} catch (Exception e2) {
				}
			}
			if (socket1 != null) {
				try {
					socket1.close();
				} catch (Exception e2) {
				}
			}
			if (server != null) {
				try {
					server.close();
				} catch (Exception e2) {
				}
			}
		}
	}

	@Test
	public void client2() {
		Socket socket2 = null;// 网络套接字

		FileInputStream fis = null;// 文件输入流
		OutputStream nos = null;// 网络输出流
		BufferedReader netReader = null;// 网络输入流
		try {
			socket2 = new Socket("127.0.0.1", 7777);
			fis = new FileInputStream("src/朴树 - 猎户星座.mp3");// 要传到服务器端的文件，先读入到客户端
			nos = socket2.getOutputStream();// 传输到服务器端的文件输出流
			netReader = new BufferedReader(new InputStreamReader(socket2.getInputStream()));// 读取服务器端返回的数据

			byte[] buf = new byte[8192];
			// 读取数据
			int realCount = fis.read(buf);
			while (realCount != -1) {
				// 1) 处理已经读的数据
				nos.write(buf, 0, realCount);
				// 2) 继续读
				realCount = fis.read(buf);
			}
			nos.flush();// 将在缓存中的数据全部输出去
			socket2.shutdownOutput();// 关闭输出流

			String readLine = netReader.readLine();// 接受服务器端的数据
			System.out.println(readLine);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {// 关闭相应的资源
			if (netReader != null) {
				try {
					netReader.close();
				} catch (Exception e2) {
				}
			}
			if (nos != null) {
				try {
					nos.close();
				} catch (Exception e2) {
				}
			}
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception e2) {
				}
			}
			if (socket2 != null) {
				try {
					socket2.close();
				} catch (Exception e2) {
				}
			}
		}
	}

	@Test
	public void server() {
		ServerSocket server = null;
		Socket socket1 = null;
		BufferedReader bufferedReader = null;
		try {
			server = new ServerSocket(9999); // 绑定9999端口.
			socket1 = server.accept(); // 接受客户端的连接请求, 此方法会引起阻塞.
			System.out.println(socket1);
			// 服务器端的socket1和客户端的socket2就建立了双向的网络通道
			InputStream inputStream = socket1.getInputStream();
			InputStreamReader isr = new InputStreamReader(inputStream);

			bufferedReader = new BufferedReader(isr);
			String readLine = bufferedReader.readLine();
			System.out.println(readLine);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (Exception e2) {
				}
			}

			if (socket1 != null) {
				try {
					socket1.close();
				} catch (Exception e2) {
				}
			}

			if (server != null) {
				try {
					server.close();
				} catch (Exception e2) {
				}

			}
		}
	}

	@Test
	public void client() {
		// 连接服务器, 必须知道ip和端口.
		Socket socket2 = null;
		BufferedWriter bufferedWriter = null;
		try {
			socket2 = new Socket("127.0.0.1", 9999);
			System.out.println(socket2);
			// 客户端的socket2和服务器端的socket1就建立了双向的网络通道
			OutputStream outputStream = socket2.getOutputStream();
			OutputStreamWriter osw = new OutputStreamWriter(outputStream);
			bufferedWriter = new BufferedWriter(osw);
			bufferedWriter.write("你好, 服务器, 俺是客户端.....");
			bufferedWriter.newLine();// 必须要有换行
			bufferedWriter.flush();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (bufferedWriter != null) {
				try {
					bufferedWriter.close();
				} catch (Exception e2) {
				}
			}

			if (socket2 != null) {
				try {
					socket2.close();
				} catch (Exception e2) {
				}
			}
		}
	}
}

````
## 杀死本机被占用的端口号
````
netstat -ano   查看操作系统所有占用端口的进程
netstat -ano | findstr "9999" 获取占用了9999端口的进程
taskkill /F /pid 1234 关闭进程号为1234的进程
````
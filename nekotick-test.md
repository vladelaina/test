# Test

# Mar&#x6B;**`down 语法全面测试`**

**`这是一份完整的 Markdown、LaTeX 和 GFM 扩展语法测试文档。`**



nihao 

我是



1

## 2

你好啊，就是你用的是


## 基础 Markdown

### 标题测试



# 一级标题

## 二级标题

### 三级标题

#### 四级标题

##### 五级标题

###### 六级标题




### 文本格式

这是普通文本。

**这是粗体文本**

*这是斜体文本*

***这是粗斜体文本***

~~这是删除线文本~~

`这是行内代码`

### 列表

无序列表：

* 项目 1
* 项目 2
  * 嵌套项目 2.1
  * 嵌套项目 2.2
* 项目 3

有序列表：

1. 第一项
2. 第二项
   &#x20;  3\. 嵌套第一项
   &#x20;  4\. 嵌套第二项
3. 第三项

### 任务列表 (GFM)

* [ ] 未完成任务
* [x] 已完成任务
* [ ] 另一个未完成任务

### 引用

> 这是一段引用文本。可以有多行。这是嵌套引用。

### 链接和图片

[这是一个链接](https://example.com)

[带标题的链接](https://example.com)



### 分割线

***

***

***

## GFM 表格

| 左对齐   | 居中对齐 | 右对齐  |
| ----- | ---- | ---- |
| 单元格1  | 单元格2 | 单元格3 |
| 数据A   | 数据B  | 数据C  |
| 长文本内容 | 中等   | 短    |

## 代码块

### 基础代码块

```javascript
function hello() {
  console.log("Hello, World!");
  return 42;
}
```

### 带行号的代码块

```typescript
interface User {
&#x20; id: number;
&#x20; name: string;
&#x20; email: string;
}

function getUser(id: number): User {
&#x20; return {
&#x20;   id,
&#x20;   name: "John",
&#x20;   email: "john@example.com"
&#x20; };
}
```

### 代码行高亮

```python
def fibonacci(n):
&#x20;   if n <= 1:
&#x20;       return n
&#x20;   return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
```

### 多种语言

```rust
fn main() {
&#x20;   println!("Hello, Rust!");
}
```

```go
package main

import "fmt"

func main() {
&#x20;   fmt.Println("Hello, Go!")
}
```

```sql
SELECT * FROM users WHERE age > 18 ORDER BY name;
```

```shellscript
echo "Hello, Shell!"
npm install
```

## LaTeX 数学公式

### 行内公式

爱因斯坦质能方程：$E = mc^2$

二次方程求根公式：$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$

欧拉公式：$e^{i\pi} + 1 = 0$

### 块级公式

$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$

$\sum_{n=1}^{\infty} \frac{1}{n^2} = \frac{\pi^2}{6}$

# \$\$ \begin{pmatrix} a & b \ c & d \end{pmatrix} \begin{pmatrix} x \ y \end{pmatrix}

\begin{pmatrix} ax + by \ cx + dy \end{pmatrix} \$\$

$\nabla \times \vec{E} = -\frac{\partial \vec{B}}{\partial t}$

## 扩展语法

### 高亮文本

这是 ==高亮文本== 的示例。

你可以 ==高亮多个词语== 来强调重点。

### 上标和下标

水的化学式是 H~~2~~O。

爱因斯坦的质能方程 E=mc^2^ 很著名。

2^10^ = 1024

CO~~2~~ 是二氧化碳。

### 脚注

这是一段带脚注的文本[^1](vscode-webview://0e86f2odopq52tfrudnj4m87sq0ffn0d5ttkrdme9k41iol4r2do/%E8%BF%99%E6%98%AF%E7%AC%AC%E4%B8%80%E4%B8%AA%E8%84%9A%E6%B3%A8%E7%9A%84%E5%86%85%E5%AE%B9%E3%80%82)。

这里还有另一个脚注[^note](vscode-webview://0e86f2odopq52tfrudnj4m87sq0ffn0d5ttkrdme9k41iol4r2do/%E8%BF%99%E6%98%AF%E5%91%BD%E5%90%8D%E8%84%9A%E6%B3%A8%E7%9A%84%E5%86%85%E5%AE%B9%EF%BC%8C%E5%8F%AF%E4%BB%A5%E6%9B%B4%E9%95%BF%E4%B8%80%E4%BA%9B%E3%80%82)。

### 自动链接

访问 [www.google.com](http://www.google.com/) 获取更多信息。

也可以访问 [https://github.com](https://github.com/) 查看代码。

发送邮件到 [test@example.com](mailto:test@example.com) 联系我们。

### Wiki 链接

查看 \[\[另一篇笔记]] 了解更多。

也可以链接到 \[\[项目/子笔记]] 子目录。

### 缩写

HTML 规范由 W3C 维护。

\*\[HTML]: Hyper Text Markup Language \*\[W3C]: World Wide Web Consortium

### 目录

\[TOC]

## Callout / 提示块

> 💡 这是一个提示 callout 块。可以包含多行内容。

> ⚠️ 这是一个警告块。请注意这个重要信息。

> ✅ 这是一个成功提示。

> ❌ 这是一个错误提示。

## Mermaid 图表

```mermaid
graph TD
&#x20;   A[开始] --> B{判断条件}
&#x20;   B -->|是| C[执行操作1]
&#x20;   B -->|否| D[执行操作2]
&#x20;   C --> E[结束]
&#x20;   D --> E
```

```mermaid
sequenceDiagram
&#x20;   participant A as 用户
&#x20;   participant B as 服务器
&#x20;   A->>B: 发送请求
&#x20;   B-->>A: 返回响应
```

```mermaid
pie title 项目时间分配
&#x20;   "开发" : 45
&#x20;   "测试" : 25
&#x20;   "文档" : 15
&#x20;   "会议" : 15
```

## 视频嵌入

YouTube 视频： 

![](<assets/J_RlyTRkaaGXAiFgGHDM1W50O5rQXt6kaOYxDVzV6SY=.html; charset=utf-8>)

Bilibili 视频： 

![](<assets/Z6XJerle1L9T5rPPYeoMuS3H2J7iJbagtIvk3t7u-fU=.html; charset=utf-8>)

## 定义列表

术语 1 : 这是术语 1 的定义。

术语 2 : 这是术语 2 的定义。 : 可以有多个定义。

Markdown : 一种轻量级标记语言。

## 复杂嵌套测试

### 列表中的代码和公式

1. 第一项包含代码 `const x = 1;`
2. 第二项包含公式 $a^2 + b^2 = c^2$
3. 第三项包含 **粗体** 和 *斜体*
   * 嵌套项包含 ==高亮==
   * 另一个嵌套项

### 引用中的格式

> **重要提示**：这是一段 *格式化* 的引用。包含代码：`npm install`包含公式：$\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$

### 表格中的格式

| 功能 | 语法           | 示例     |
| -- | ------------ | ------ |
| 粗体 | `**text**`   | **粗体** |
| 斜体 | `*text*`     | *斜体*   |
| 代码 | `` `code` `` | `code` |
| 公式 | `$formula$`  | $x^2$  |

***

测试完成！如果所有内容都正确渲染，说明编辑器支持完整。

```

这份测试文件覆盖了：

**基础 Markdown：** 标题、粗体、斜体、删除线、行内代码、列表、引用、链接、图片、分割线

**GFM 扩展：** 任务列表、表格、删除线

**代码块：** 多种语言、行号、行高亮、复制按钮

**LaTeX：** 行内公式、块级公式、矩阵、求和、积分

**新增扩展：** 高亮 `==text==`、上标 `^text^`、下标 `~text~`、脚注 `[^1]`、自动链接、Wiki链接 `[[note]]`、缩写、目录 `[TOC]`、Callout、Mermaid 图表、视频嵌入、定义列表Markdown 语法全面测试
这是一份完整的 Markdown、LaTeX 和 GFM 扩展语法测试文档。
基础 Markdown
标题测试
一级标题
二级标题
三级标题
四级标题
五级标题
六级标题
文本格式
这是普通文本。
这是粗体文本
这是斜体文本
这是粗斜体文本
这是删除线文本
这是行内代码
列表
无序列表：
项目 1
项目 2
项目 3
有序列表：
第一项
第二项
   3. 嵌套第一项
   4. 嵌套第二项
第三项
任务列表 (GFM)
未完成任务
已完成任务
另一个未完成任务
引用
这是一段引用文本。可以有多行。这是嵌套引用。
链接和图片
这是一个链接
带标题的链接

分割线
GFM 表格
代码块
基础代码块
function hello() {
  console.log("Hello, World!");
  return 42;
}
带行号的代码块
interface User {
&#x20; id: number;
&#x20; name: string;
&#x20; email: string;
}

function getUser(id: number): User {
&#x20; return {
&#x20;   id,
&#x20;   name: "John",
&#x20;   email: "john@example.com"
&#x20; };
}
代码行高亮
def fibonacci(n):
&#x20;   if n <= 1:
&#x20;       return n
&#x20;   return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
多种语言
fn main() {
&#x20;   println!("Hello, Rust!");
}
package main

import "fmt"

func main() {
&#x20;   fmt.Println("Hello, Go!")
}
SELECT * FROM users WHERE age > 18 ORDER BY name;
echo "Hello, Shell!"
npm install
LaTeX 数学公式
行内公式
爱因斯坦质能方程： 
二次方程求根公式： 
欧拉公式： 
块级公式
 
 
$$ \begin{pmatrix} a & b \ c & d \end{pmatrix} \begin{pmatrix} x \ y \end{pmatrix}
\begin{pmatrix} ax + by \ cx + dy \end{pmatrix} $$
 
扩展语法
高亮文本
这是 ==高亮文本== 的示例。
你可以 ==高亮多个词语== 来强调重点。
上标和下标
水的化学式是 H2O。
爱因斯坦的质能方程 E=mc^2^ 很著名。
2^10^ = 1024
CO2 是二氧化碳。
脚注
这是一段带脚注的文本^1。
这里还有另一个脚注^note。
自动链接
访问 www.google.com 获取更多信息。
也可以访问 https://github.com 查看代码。
发送邮件到 test@example.com 联系我们。
Wiki 链接
查看 [[另一篇笔记]] 了解更多。
也可以链接到 [[项目/子笔记]] 子目录。
缩写
HTML 规范由 W3C 维护。
*[HTML]: Hyper Text Markup Language *[W3C]: World Wide Web Consortium
目录
[TOC]
Callout / 提示块
💡 这是一个提示 callout 块。可以包含多行内容。
⚠️ 这是一个警告块。请注意这个重要信息。
✅ 这是一个成功提示。
❌ 这是一个错误提示。
Mermaid 图表
graph TD
&#x20;   A[开始] --> B{判断条件}
&#x20;   B -->|是| C[执行操作1]
&#x20;   B -->|否| D[执行操作2]
&#x20;   C --> E[结束]
&#x20;   D --> E
sequenceDiagram
&#x20;   participant A as 用户
&#x20;   participant B as 服务器
&#x20;   A->>B: 发送请求
&#x20;   B-->>A: 返回响应
pie title 项目时间分配
&#x20;   "开发" : 45
&#x20;   "测试" : 25
&#x20;   "文档" : 15
&#x20;   "会议" : 15
视频嵌入
YouTube 视频： 
Bilibili 视频： 
定义列表
术语 1 : 这是术语 1 的定义。
术语 2 : 这是术语 2 的定义。 : 可以有多个定义。
Markdown : 一种轻量级标记语言。
复杂嵌套测试
列表中的代码和公式
第一项包含代码 const x = 1;
第二项包含公式  
第三项包含 粗体 和 斜体
引用中的格式
重要提示：这是一段 格式化 的引用。包含代码：npm install包含公式： 
表格中的格式
测试完成！如果所有内容都正确渲染，说明编辑器支持完整。

这份测试文件覆盖了：

**基础 Markdown：** 标题、粗体、斜体、删除线、行内代码、列表、引用、链接、图片、分割线

**GFM 扩展：** 任务列表、表格、删除线

**代码块：** 多种语言、行号、行高亮、复制按钮

**LaTeX：** 行内公式、块级公式、矩阵、求和、积分

**新增扩展：** 高亮 `==text==`、上标 `^text^`、下标 `~text~`、脚注 `[^1]`、自动链接、Wiki链接 `[[note]]`、缩写、目录 `[TOC]`、Callout、Mermaid 图表、视频嵌入、定义列表







Markdown 语法全面测试
这是一份完整的 Markdown、LaTeX 和 GFM 扩展语法测试文档。
基础 Markdown
标题测试
一级标题
二级标题
三级标题
四级标题
五级标题
六级标题
文本格式
这是普通文本。
这是粗体文本
这是斜体文本
这是粗斜体文本
这是删除线文本
这是行内代码
列表
无序列表：
项目 1
项目 2
项目 3
有序列表：
第一项
第二项
   3. 嵌套第一项
   4. 嵌套第二项
第三项
任务列表 (GFM)
未完成任务
已完成任务
另一个未完成任务
引用
这是一段引用文本。可以有多行。这是嵌套引用。
链接和图片
这是一个链接
带标题的链接

分割线
GFM 表格
代码块
基础代码块
function hello() {
  console.log("Hello, World!");
  return 42;
}
带行号的代码块
interface User {
&#x20; id: number;
&#x20; name: string;
&#x20; email: string;
}

function getUser(id: number): User {
&#x20; return {
&#x20;   id,
&#x20;   name: "John",
&#x20;   email: "john@example.com"
&#x20; };
}
代码行高亮
def fibonacci(n):
&#x20;   if n <= 1:
&#x20;       return n
&#x20;   return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
多种语言
fn main() {
&#x20;   println!("Hello, Rust!");
}
package main

import "fmt"

func main() {
&#x20;   fmt.Println("Hello, Go!")
}
SELECT * FROM users WHERE age > 18 ORDER BY name;
echo "Hello, Shell!"
npm install
LaTeX 数学公式
行内公式
爱因斯坦质能方程： 
二次方程求根公式： 
欧拉公式： 
块级公式
 
 
$$ \begin{pmatrix} a & b \ c & d \end{pmatrix} \begin{pmatrix} x \ y \end{pmatrix}
\begin{pmatrix} ax + by \ cx + dy \end{pmatrix} $$
 
扩展语法
高亮文本
这是 ==高亮文本== 的示例。
你可以 ==高亮多个词语== 来强调重点。
上标和下标
水的化学式是 H2O。
爱因斯坦的质能方程 E=mc^2^ 很著名。
2^10^ = 1024
CO2 是二氧化碳。
脚注
这是一段带脚注的文本^1。
这里还有另一个脚注^note。
自动链接
访问 www.google.com 获取更多信息。
也可以访问 https://github.com 查看代码。
发送邮件到 test@example.com 联系我们。
Wiki 链接
查看 [[另一篇笔记]] 了解更多。
也可以链接到 [[项目/子笔记]] 子目录。
缩写
HTML 规范由 W3C 维护。
*[HTML]: Hyper Text Markup Language *[W3C]: World Wide Web Consortium
目录
[TOC]
Callout / 提示块
💡 这是一个提示 callout 块。可以包含多行内容。
⚠️ 这是一个警告块。请注意这个重要信息。
✅ 这是一个成功提示。
❌ 这是一个错误提示。
Mermaid 图表
graph TD
&#x20;   A[开始] --> B{判断条件}
&#x20;   B -->|是| C[执行操作1]
&#x20;   B -->|否| D[执行操作2]
&#x20;   C --> E[结束]
&#x20;   D --> E
sequenceDiagram
&#x20;   participant A as 用户
&#x20;   participant B as 服务器
&#x20;   A->>B: 发送请求
&#x20;   B-->>A: 返回响应
pie title 项目时间分配
&#x20;   "开发" : 45
&#x20;   "测试" : 25
&#x20;   "文档" : 15
&#x20;   "会议" : 15
视频嵌入
YouTube 视频： 
Bilibili 视频： 
定义列表
术语 1 : 这是术语 1 的定义。
术语 2 : 这是术语 2 的定义。 : 可以有多个定义。
Markdown : 一种轻量级标记语言。
复杂嵌套测试
列表中的代码和公式
第一项包含代码 const x = 1;
第二项包含公式  
第三项包含 粗体 和 斜体
引用中的格式
重要提示：这是一段 格式化 的引用。包含代码：npm install包含公式： 
表格中的格式
测试完成！如果所有内容都正确渲染，说明编辑器支持完整。

这份测试文件覆盖了：

**基础 Markdown：** 标题、粗体、斜体、删除线、行内代码、列表、引用、链接、图片、分割线

**GFM 扩展：** 任务列表、表格、删除线

**代码块：** 多种语言、行号、行高亮、复制按钮

**LaTeX：** 行内公式、块级公式、矩阵、求和、积分

**新增扩展：** 高亮 `==text==`、上标 `^text^`、下标 `~text~`、脚注 `[^1]`、自动链接、Wiki链接 `[[note]]`、缩写、目录 `[TOC]`、Callout、Mermaid 图表、视频嵌入、定义列表







Markdown 语法全面测试
这是一份完整的 Markdown、LaTeX 和 GFM 扩展语法测试文档。
基础 Markdown
标题测试
一级标题
二级标题
三级标题
四级标题
五级标题
六级标题
文本格式
这是普通文本。
这是粗体文本
这是斜体文本
这是粗斜体文本
这是删除线文本
这是行内代码
列表
无序列表：
项目 1
项目 2
项目 3
有序列表：
第一项
第二项
   3. 嵌套第一项
   4. 嵌套第二项
第三项
任务列表 (GFM)
未完成任务
已完成任务
另一个未完成任务
引用
这是一段引用文本。可以有多行。这是嵌套引用。
链接和图片
这是一个链接
带标题的链接

分割线
GFM 表格
代码块
基础代码块
function hello() {
  console.log("Hello, World!");
  return 42;
}
带行号的代码块
interface User {
&#x20; id: number;
&#x20; name: string;
&#x20; email: string;
}

function getUser(id: number): User {
&#x20; return {
&#x20;   id,
&#x20;   name: "John",
&#x20;   email: "john@example.com"
&#x20; };
}
代码行高亮
def fibonacci(n):
&#x20;   if n <= 1:
&#x20;       return n
&#x20;   return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
多种语言
fn main() {
&#x20;   println!("Hello, Rust!");
}
package main

import "fmt"

func main() {
&#x20;   fmt.Println("Hello, Go!")
}
SELECT * FROM users WHERE age > 18 ORDER BY name;
echo "Hello, Shell!"
npm install
LaTeX 数学公式
行内公式
爱因斯坦质能方程： 
二次方程求根公式： 
欧拉公式： 
块级公式
 
 
$$ \begin{pmatrix} a & b \ c & d \end{pmatrix} \begin{pmatrix} x \ y \end{pmatrix}
\begin{pmatrix} ax + by \ cx + dy \end{pmatrix} $$
 
扩展语法
高亮文本
这是 ==高亮文本== 的示例。
你可以 ==高亮多个词语== 来强调重点。
上标和下标
水的化学式是 H2O。
爱因斯坦的质能方程 E=mc^2^ 很著名。
2^10^ = 1024
CO2 是二氧化碳。
脚注
这是一段带脚注的文本^1。
这里还有另一个脚注^note。
自动链接
访问 www.google.com 获取更多信息。
也可以访问 https://github.com 查看代码。
发送邮件到 test@example.com 联系我们。
Wiki 链接
查看 [[另一篇笔记]] 了解更多。
也可以链接到 [[项目/子笔记]] 子目录。
缩写
HTML 规范由 W3C 维护。
*[HTML]: Hyper Text Markup Language *[W3C]: World Wide Web Consortium
目录
[TOC]
Callout / 提示块
💡 这是一个提示 callout 块。可以包含多行内容。
⚠️ 这是一个警告块。请注意这个重要信息。
✅ 这是一个成功提示。
❌ 这是一个错误提示。
Mermaid 图表
graph TD
&#x20;   A[开始] --> B{判断条件}
&#x20;   B -->|是| C[执行操作1]
&#x20;   B -->|否| D[执行操作2]
&#x20;   C --> E[结束]
&#x20;   D --> E
sequenceDiagram
&#x20;   participant A as 用户
&#x20;   participant B as 服务器
&#x20;   A->>B: 发送请求
&#x20;   B-->>A: 返回响应
pie title 项目时间分配
&#x20;   "开发" : 45
&#x20;   "测试" : 25
&#x20;   "文档" : 15
&#x20;   "会议" : 15
视频嵌入
YouTube 视频： 
Bilibili 视频： 
定义列表
术语 1 : 这是术语 1 的定义。
术语 2 : 这是术语 2 的定义。 : 可以有多个定义。
Markdown : 一种轻量级标记语言。
复杂嵌套测试
列表中的代码和公式
第一项包含代码 const x = 1;
第二项包含公式  
第三项包含 粗体 和 斜体
引用中的格式
重要提示：这是一段 格式化 的引用。包含代码：npm install包含公式： 
表格中的格式
测试完成！如果所有内容都正确渲染，说明编辑器支持完整。

这份测试文件覆盖了：

**基础 Markdown：** 标题、粗体、斜体、删除线、行内代码、列表、引用、链接、图片、分割线

**GFM 扩展：** 任务列表、表格、删除线

**代码块：** 多种语言、行号、行高亮、复制按钮

**LaTeX：** 行内公式、块级公式、矩阵、求和、积分

**新增扩展：** 高亮 `==text==`、上标 `^text^`、下标 `~text~`、脚注 `[^1]`、自动链接、Wiki链接 `[[note]]`、缩写、目录 `[TOC]`、Callout、Mermaid 图表、视频嵌入、定义列表
```

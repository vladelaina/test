# 基础教程

本教程将带你从零开始构建一个完整的应用。

## 第一步：创建项目

```bash
mkdir my-project
cd my-project
npm init -y
```

## 第二步：安装依赖

```bash
npm install my-awesome-lib express
```

## 第三步：编写代码

创建 `index.js`：

```javascript
const express = require('express')
const { createApp } = require('my-awesome-lib')

const server = express()
const app = createApp({ name: 'Tutorial App' })

server.get('/', (req, res) => {
  res.json({ message: 'Hello World!' })
})

server.listen(3000, () => {
  console.log('Server running on port 3000')
  app.start()
})
```

## 第四步：运行

```bash
node index.js
```

访问 http://localhost:3000 查看结果！

## 总结

恭喜你完成了基础教程！接下来可以尝试：

- 添加更多路由
- 连接数据库
- 部署到服务器

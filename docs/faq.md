# 常见问题

## 安装问题

### Q: 安装时报错 EACCES 权限问题？

A: 尝试使用以下命令：

```bash
sudo npm install -g my-awesome-lib
# 或者修复 npm 权限
npm config set prefix ~/.npm-global
```

### Q: Node.js 版本要求？

A: 需要 Node.js 16.0 或更高版本。

```bash
node --version  # 检查版本
```

## 使用问题

### Q: 如何开启调试模式？

A: 设置环境变量或配置选项：

```javascript
createApp({ debug: true })
// 或
export DEBUG=true
```

### Q: 支持 TypeScript 吗？

A: 完全支持！已内置类型定义。

```typescript
import { createApp, AppOptions } from 'my-awesome-lib'

const options: AppOptions = {
  name: 'TypeScript App'
}
```

### Q: 如何处理错误？

A: 使用 try-catch 或事件监听：

```javascript
app.on('error', (err) => {
  console.error('Error:', err.message)
})
```

## 部署问题

### Q: 如何部署到生产环境？

A: 推荐使用 Docker 或 PM2：

```bash
# Docker
docker build -t myapp .
docker run -p 3000:3000 myapp

# PM2
pm2 start index.js --name myapp
```

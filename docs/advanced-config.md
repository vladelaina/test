# 高级配置

## 环境变量

支持通过环境变量配置应用：

```bash
export APP_DEBUG=true
export APP_PORT=3000
export APP_SECRET=your-secret-key
```

## 配置文件

创建 `config.json`：

```json
{
  "server": {
    "host": "0.0.0.0",
    "port": 3000
  },
  "database": {
    "url": "mongodb://localhost:27017",
    "name": "myapp"
  },
  "cache": {
    "enabled": true,
    "ttl": 3600
  }
}
```

## 多环境配置

```
config/
├── default.json
├── development.json
├── production.json
└── test.json
```

## 自定义日志

```javascript
import { createLogger } from 'my-awesome-lib'

const logger = createLogger({
  level: 'debug',
  format: 'json',
  output: './logs/app.log'
})
```

## 性能优化

1. 启用缓存
2. 使用连接池
3. 开启 gzip 压缩
4. 配置 CDN

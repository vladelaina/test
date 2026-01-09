# 快速开始

欢迎使用本文档！这里将帮助你快速上手。

## 安装

```bash
npm install my-awesome-lib
```

## 基本用法

```javascript
import { createApp } from 'my-awesome-lib'

const app = createApp({
  name: 'My App',
  version: '1.0.0'
})

app.start()
```

## 配置选项

| 选项 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| name | string | 'App' | 应用名称 |
| version | string | '1.0.0' | 版本号 |
| debug | boolean | false | 调试模式 |

## 下一步

- 查看 [API 文档](./api-reference.md)
- 了解 [高级配置](./advanced-config.md)

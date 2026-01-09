# API 参考

## createApp(options)

创建一个新的应用实例。

### 参数

- `options.name` - 应用名称
- `options.version` - 版本号
- `options.plugins` - 插件列表

### 返回值

返回一个 `App` 实例。

```javascript
const app = createApp({
  name: 'Demo',
  plugins: [logger, router]
})
```

## App 实例方法

### app.start()

启动应用。

```javascript
app.start()
// 输出: App started successfully!
```

### app.stop()

停止应用。

### app.use(plugin)

注册插件。

```javascript
app.use(myPlugin)
```

## 事件

| 事件名 | 触发时机 |
|--------|----------|
| ready | 应用就绪 |
| error | 发生错误 |
| destroy | 应用销毁 |

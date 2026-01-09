# 数据库集成

学习如何将应用连接到数据库。

## 支持的数据库

- MongoDB
- PostgreSQL
- MySQL
- SQLite
- Redis

## MongoDB 示例

### 安装驱动

```bash
npm install mongodb
```

### 连接数据库

```javascript
import { MongoClient } from 'mongodb'

const client = new MongoClient('mongodb://localhost:27017')

async function connect() {
  await client.connect()
  console.log('Connected to MongoDB')
  
  const db = client.db('myapp')
  return db
}
```

### CRUD 操作

```javascript
// 创建
await db.collection('users').insertOne({
  name: 'Alice',
  email: 'alice@example.com'
})

// 读取
const user = await db.collection('users').findOne({ name: 'Alice' })

// 更新
await db.collection('users').updateOne(
  { name: 'Alice' },
  { $set: { age: 25 } }
)

// 删除
await db.collection('users').deleteOne({ name: 'Alice' })
```

## PostgreSQL 示例

```javascript
import pg from 'pg'

const pool = new pg.Pool({
  host: 'localhost',
  database: 'myapp',
  user: 'postgres',
  password: 'password'
})

const result = await pool.query('SELECT * FROM users')
console.log(result.rows)
```

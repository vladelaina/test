
我们直接帮助用户使用GitHub pages部署然后自动发布
> 就是把代码放到 远程分支


- [ ] 要注意的是，绝对正式的时候不能让他每次都推送后编译，就是他是有一个额度限制的


### 1. Docusaurus (Meta/Facebook)

`https://github.com/facebook/docusaurus`

### 2. VitePress (Vue 团队)

`https://github.com/vuejs/vitepress`

### 3. Material for MkDocs (Python 生态)

`https://github.com/squidfunk/mkdocs-material`

### 4. Docsify (纯前端无构建)

`https://github.com/docsifyjs/docsify`

### 5. Starlight (Astro 生态)

`https://github.com/withastro/starlight`









----------




### 第一梯队：全能型标准方案 (Docs + Blog)

_这类最适合做正式的产品官网，同时具备文档系统和博客系统。_

1. **Docusaurus** (React)
    
    - **地址**: `https://github.com/facebook/docusaurus`
        
    - **协议**: MIT
        
    - **特点**: 功能最全，Meta 出品，国内大厂用的最多。
        
2. **VitePress** (Vue)
    
    - **地址**: `https://github.com/vuejs/vitepress`
        
    - **协议**: MIT
        
    - **特点**: 速度极快，Vue 官方现在的御用文档工具。
        
3. **Starlight** (Astro)
    
    - **地址**: `https://github.com/withastro/starlight`
        
    - **协议**: MIT
        
    - **特点**: 基于 Astro，性能目前是天花板级别，支持多框架组件。
        
4. **Rspress** (React/Rspack)
    
    - **地址**: `https://github.com/web-infra-dev/rspress`
        
    - **协议**: MIT
        
    - **特点**: 字节跳动（ByteDance）开源的，基于 Rust 打包工具 Rspack，构建速度比 Docusaurus 快很多。
        

### 第二梯队：Next.js 生态 (适合 React 深度用户)

_如果你本身就在用 Next.js 开发产品，用这些整合度最高。_

5. **Nextra**
    
    - **地址**: `https://github.com/shuding/nextra`
        
    - **协议**: MIT
        
    - **特点**: Vercel 工程师作品，不仅是文档，写博客也非常漂亮，设计感很强。
        
6. **Fumadocs** (原 Fumadocs)
    
    - **地址**: `https://github.com/fuma-nama/fumadocs`
        
    - **协议**: MIT
        
    - **特点**: 也是基于 Next.js，提供了非常强大的 UI 组件库，适合想要深度定制文档 UI 的人。
        
7. **Dokz**
    
    - **地址**: `https://github.com/remorses/dokz`
        
    - **协议**: MIT
        
    - **特点**: 比较轻量级的 Next.js 文档生成器。
        

### 第三梯队：极简/无构建/轻量级

_适合快速上线，不想折腾环境。_

8. **Docsify**
    
    - **地址**: `https://github.com/docsifyjs/docsify`
        
    - **协议**: MIT
        
    - **特点**: 运行时渲染，无须编译，一个 `index.html` 搞定。
        
9. **Docute**
    
    - **地址**: `https://github.com/egoist/docute`
        
    - **协议**: MIT
        
    - **特点**: 和 Docsify 类似，但写法上更像 Vue 组件，非常极简。
        

### 第四梯队：Python/Go/其他生态

_虽然语言不同，但生成的都是静态 HTML。_

10. **MkDocs Material** (Python)
    
    - **地址**: `https://github.com/squidfunk/mkdocs-material`
        
    - **协议**: MIT
        
    - **注意**: 核心 MkDocs 是 BSD (兼容)，但这个最火的主题 `mkdocs-material` 是 MIT。这是 Python 界做文档的事实标准。
        
11. **HonKit** (Node.js)
    
    - **地址**: `https://github.com/honkit/honkit`
        
    - **协议**: MIT
        
    - **背景**: 它是 **GitBook** 的开源复刻版。当 GitBook 转为闭源商业收费后，社区 fork 出来的 MIT 版本，保留了经典 GitBook 的书本样式。
        
12. **Docfx** (.NET)
    
    - **地址**: `https://github.com/dotnet/docfx`
        
    - **协议**: MIT
        
    - **特点**: 微软官方维护，虽然是 .NET写的，但可以生成任意静态网站，支持 Markdown。
        

### 第五梯队：老牌但依然能打

_这些虽然稍微旧一点，但依然是 MIT 且大量使用。_

13. **VuePress** (Vue 2/3)
    
    - **地址**: `https://github.com/vuejs/vuepress`
        
    - **协议**: MIT
        
    - **现状**: 虽然官方在推 VitePress，但 VuePress 生态插件依然最丰富。
        
14. **Hexo** (Node.js)
    
    - **地址**: `https://github.com/hexojs/hexo`
        
    - **协议**: MIT
        
    - **注意**: 它是纯博客引擎，但配合 `hexo-theme-fluid` 或其他文档主题，也能做成说明书样式。
        

---

特别提醒：

市面上还有一个很火的生成器叫 Hugo (Go语言)，它的速度极快，但它的协议是 Apache 2.0（虽然也兼容商业，但既然你严格要求 MIT，我就没有把它列在上面）。

我的建议：

如果为了稳妥且通过 MIT 协议规避所有风险，首选 Docusaurus 或 VitePress；如果你怀念以前的 GitBook 风格，选 HonKit。
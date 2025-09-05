# Winget 自动发布配置指南

本文档说明如何配置自动发布到 Winget 的功能。

## 🔧 配置要求

### 1. GitHub Secrets 设置

您需要在 GitHub 仓库中添加以下 Secret：

- `WINGET_TOKEN`: 用于提交到 Microsoft winget-pkgs 仓库的 Personal Access Token

### 2. 创建 WINGET_TOKEN

#### 步骤 1: 创建 GitHub Personal Access Token

1. 访问 [GitHub Personal Access Tokens](https://github.com/settings/tokens)
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置 Token 名称，例如：`Winget Releaser for Catime`
4. 选择过期时间（建议选择较长时间）
5. 选择以下权限：
   - `public_repo` (访问公共仓库)
   - `workflow` (更新 GitHub Actions 工作流)

#### 步骤 2: 添加 Secret 到仓库

1. 前往您的仓库 → Settings → Secrets and variables → Actions
2. 点击 "New repository secret"
3. Name: `WINGET_TOKEN`
4. Secret: 粘贴刚才创建的 Personal Access Token
5. 点击 "Add secret"

## 🚀 工作流程

当您推送一个新的 tag 时（例如 `git tag v1.2.0` 和 `git push origin v1.2.0`），GitHub Actions 将会：

1. 自动构建您的应用程序
2. 创建 GitHub Release
3. 自动计算文件的 SHA256 哈希值
4. 更新 Winget 包配置
5. 自动提交到 Microsoft winget-pkgs 仓库

## 📋 检查清单

- [ ] 已创建 `WINGET_TOKEN` 并添加到 GitHub Secrets
- [ ] Winget 模板文件已更新（使用 `${version}` 占位符）
- [ ] Release 工作流已包含 winget-releaser 步骤

## 🔍 验证配置

### 测试发布流程

1. 确保代码已提交并推送
2. 创建并推送一个测试 tag：
   ```bash
   git tag v1.1.3-test
   git push origin v1.1.3-test
   ```
3. 检查 GitHub Actions 是否成功运行
4. 验证是否创建了 GitHub Release
5. 检查是否自动提交到了 winget-pkgs 仓库

### 故障排除

如果遇到问题，检查：

1. **Token 权限**: 确保 `WINGET_TOKEN` 有正确的权限
2. **文件格式**: 确保 winget 模板文件格式正确
3. **版本格式**: 确保 tag 版本格式符合语义化版本规范 (例如: v1.2.3)
4. **构建产物**: 确保 exe 文件成功生成并上传到 release

## 📝 注意事项

- 首次使用可能需要手动批准提交到 winget-pkgs 仓库
- 建议先使用测试 tag 验证配置是否正确
- 确保每次发布的版本号都是唯一的
- winget-releaser 会自动处理 SHA256 计算和日期设置

## 🔗 相关链接

- [winget-releaser 项目](https://github.com/vedantmgoyal9/winget-releaser)
- [Microsoft winget-pkgs 仓库](https://github.com/microsoft/winget-pkgs)
- [Winget 包清单规范](https://docs.microsoft.com/en-us/windows/package-manager/package/manifest)

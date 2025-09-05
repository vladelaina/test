#!/bin/bash

# Winget 自动提交脚本
# 当新版本发布时，自动将包信息提交到 winget-pkgs 仓库

set -e

# 检查必需的环境变量
if [ -z "$TAG_VERSION" ] || [ -z "$DOWNLOAD_URL" ] || [ -z "$SHA256_HASH" ]; then
    echo "错误：缺少必需的环境变量"
    echo "需要：TAG_VERSION, DOWNLOAD_URL, SHA256_HASH"
    exit 1
fi

echo "开始 Winget 提交流程..."
echo "版本：$TAG_VERSION"
echo "下载链接：$DOWNLOAD_URL"
echo "SHA256：$SHA256_HASH"

# 检查 GITHUB_TOKEN 是否存在
if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ 错误：GITHUB_TOKEN 未设置"
    exit 1
else
    echo "✅ GITHUB_TOKEN 已设置 (长度: ${#GITHUB_TOKEN})"
fi

# 设置变量
PACKAGE_IDENTIFIER="VladElaina.Catime"
UPSTREAM_REPO="ywyjcloudvlad/winget-pkgs"
MANIFEST_PATH="manifests/v/VladElaina/Catime/$TAG_VERSION"

# 设置 GitHub CLI 身份验证
export GH_TOKEN=$GITHUB_TOKEN

# 测试上游仓库访问权限
echo "🔍 测试上游仓库访问权限..."
if gh repo view $UPSTREAM_REPO > /dev/null 2>&1; then
    echo "✅ 可以访问上游仓库：$UPSTREAM_REPO"
else
    echo "❌ 无法访问上游仓库：$UPSTREAM_REPO"
    echo "请检查仓库地址是否正确"
    exit 1
fi

# 获取当前用户名
GITHUB_USER=$(gh api user --jq '.login')
if [ -z "$GITHUB_USER" ]; then
    echo "❌ 无法获取当前用户信息，请检查 GITHUB_TOKEN 权限"
    exit 1
fi
echo "✅ 当前用户：$GITHUB_USER"

USER_FORK="$GITHUB_USER/winget-pkgs"

# 检查是否已经有fork
echo "🔍 检查是否已有 fork..."
if gh repo view $USER_FORK > /dev/null 2>&1; then
    echo "✅ 找到现有 fork：$USER_FORK"
else
    echo "🍴 创建 fork..."
    gh repo fork $UPSTREAM_REPO --clone=false
    echo "✅ Fork 创建成功：$USER_FORK"
fi

# 克隆或更新用户的 fork
if [ ! -d "winget-pkgs" ]; then
    echo "📥 克隆用户 fork..."
    
    # 等待fork初始化完成
    echo "⏳ 等待fork初始化..."
    sleep 10
    
    # 重试克隆逻辑
    RETRY_COUNT=0
    MAX_RETRIES=3
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
        echo "📥 尝试克隆 fork (第 $((RETRY_COUNT + 1)) 次)..."
        
        if gh repo clone $USER_FORK winget-pkgs; then
            echo "✅ 克隆成功"
            break
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                echo "⚠️  克隆失败，等待 30 秒后重试..."
                sleep 30
            else
                echo "❌ 克隆失败，尝试备用方法..."
                # 备用方法：使用git直接克隆
                if git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/$USER_FORK.git" winget-pkgs; then
                    echo "✅ 使用备用方法克隆成功"
                    break
                else
                    echo "❌ 所有克隆方法都失败了"
                    echo "💡 可能的原因："
                    echo "   1. GitHub服务暂时不可用 (503错误)"
                    echo "   2. fork刚创建，还未完全初始化"
                    echo "   3. 网络连接问题"
                    echo ""
                    echo "🔧 建议："
                    echo "   1. 等待几分钟后重新运行workflow"
                    echo "   2. 检查GitHub状态页面：https://www.githubstatus.com/"
                    exit 1
                fi
            fi
        fi
    done
else
    echo "🔄 更新用户 fork..."
    cd winget-pkgs
    git remote -v
    # 确保有正确的远程仓库设置
    git remote set-url origin "https://github.com/$USER_FORK.git"
    
    # 添加上游仓库
    if ! git remote | grep -q upstream; then
        git remote add upstream "https://github.com/$UPSTREAM_REPO.git"
    fi
    
    # 获取最新更改
    git fetch upstream
    
    # 检测默认分支
    UPSTREAM_DEFAULT_BRANCH=$(git remote show upstream | grep 'HEAD branch' | cut -d' ' -f5)
    if [ -z "$UPSTREAM_DEFAULT_BRANCH" ]; then
        if git show-ref --verify --quiet refs/remotes/upstream/main; then
            UPSTREAM_DEFAULT_BRANCH="main"
        else
            UPSTREAM_DEFAULT_BRANCH="master"
        fi
    fi
    
    echo "📋 上游默认分支：$UPSTREAM_DEFAULT_BRANCH"
    git checkout $UPSTREAM_DEFAULT_BRANCH
    git merge upstream/$UPSTREAM_DEFAULT_BRANCH
    git push origin HEAD
    cd ..
fi

cd winget-pkgs

# 配置 git 用户信息
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# 确保在正确的基础分支上
DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
if [ -z "$DEFAULT_BRANCH" ]; then
    # 备用检测方法
    if git show-ref --verify --quiet refs/remotes/origin/main; then
        DEFAULT_BRANCH="main"
    else
        DEFAULT_BRANCH="master"
    fi
fi

echo "📋 默认分支：$DEFAULT_BRANCH"
git checkout $DEFAULT_BRANCH

# 创建新的分支
BRANCH_NAME="catime-$TAG_VERSION"
echo "🌿 创建分支：$BRANCH_NAME"
git checkout -b $BRANCH_NAME

# 创建清单文件目录
mkdir -p $MANIFEST_PATH
echo "创建目录：$MANIFEST_PATH"

# 获取当前日期
RELEASE_DATE=$(date +%Y-%m-%d)

# 生成版本清单文件
echo "生成 $PACKAGE_IDENTIFIER.yaml..."
cat > "$MANIFEST_PATH/$PACKAGE_IDENTIFIER.yaml" << EOF
PackageIdentifier: $PACKAGE_IDENTIFIER
PackageVersion: $TAG_VERSION
DefaultLocale: en-US
ManifestType: version
ManifestVersion: 1.5.0
EOF

# 生成安装程序清单文件
echo "生成 $PACKAGE_IDENTIFIER.installer.yaml..."
cat > "$MANIFEST_PATH/$PACKAGE_IDENTIFIER.installer.yaml" << EOF
PackageIdentifier: $PACKAGE_IDENTIFIER
PackageVersion: $TAG_VERSION
MinimumOSVersion: 10.0.0.0
InstallerType: portable
InstallLocationRequired: false
InstallModes:
  - interactive
  - silent
UpgradeBehavior: install
ReleaseDate: $RELEASE_DATE
Installers:
  - Architecture: x64
    InstallerUrl: $DOWNLOAD_URL
    InstallerSha256: $SHA256_HASH
    Commands:
      - catime
ManifestType: installer
ManifestVersion: 1.5.0
EOF

# 生成英文本地化清单文件
echo "生成 $PACKAGE_IDENTIFIER.locale.en-US.yaml..."
cat > "$MANIFEST_PATH/$PACKAGE_IDENTIFIER.locale.en-US.yaml" << EOF
PackageIdentifier: $PACKAGE_IDENTIFIER
PackageVersion: $TAG_VERSION
PackageLocale: en-US
Publisher: VladElaina
PublisherUrl: https://github.com/vladelaina
PublisherSupportUrl: https://github.com/vladelaina/Catime/issues
Author: VladElaina
PackageName: Catime
PackageUrl: https://github.com/vladelaina/Catime
License: Apache-2.0
LicenseUrl: https://github.com/vladelaina/Catime/blob/main/LICENSE
Copyright: Copyright (c) 2023 VladElaina
ShortDescription: A simple Windows countdown tool with Pomodoro clock functionality
Description: A simple Windows countdown tool with Pomodoro clock functionality, featuring a transparent interface and a variety of customization options.
Moniker: catime
Tags:
  - countdown
  - timer
  - pomodoro
  - minimalist
  - portable
ReleaseNotes: Release $TAG_VERSION
ReleaseNotesUrl: https://github.com/vladelaina/Catime/releases/tag/v$TAG_VERSION
ManifestType: defaultLocale
ManifestVersion: 1.5.0
EOF

# 生成中文本地化清单文件
echo "生成 $PACKAGE_IDENTIFIER.locale.zh-CN.yaml..."
cat > "$MANIFEST_PATH/$PACKAGE_IDENTIFIER.locale.zh-CN.yaml" << EOF
PackageIdentifier: $PACKAGE_IDENTIFIER
PackageVersion: $TAG_VERSION
PackageLocale: zh-CN
Publisher: VladElaina
PublisherUrl: https://github.com/vladelaina
PublisherSupportUrl: https://github.com/vladelaina/Catime/issues
Author: VladElaina
PackageName: Catime
PackageUrl: https://github.com/vladelaina/Catime
License: Apache-2.0
LicenseUrl: https://github.com/vladelaina/Catime/blob/main/LICENSE
Copyright: Copyright (c) 2023 VladElaina
ShortDescription: 一款简洁的 Windows 倒计时工具，支持番茄时钟功能
Description: 一款简洁的 Windows 倒计时工具，支持番茄时钟功能，具有透明界面和丰富的自定义选项。
Tags:
  - 倒计时
  - 计时器
  - 番茄时钟
  - 简约
  - 便携
ReleaseNotes: 版本 $TAG_VERSION
ReleaseNotesUrl: https://github.com/vladelaina/Catime/releases/tag/v$TAG_VERSION
ManifestType: locale
ManifestVersion: 1.5.0
EOF

# 添加文件到 git
git add $MANIFEST_PATH/

# 提交更改
git commit -m "Add Catime version $TAG_VERSION"

# 推送到用户的 fork
echo "📤 推送到用户 fork..."
git push origin $BRANCH_NAME

# 使用 GitHub CLI 创建 Pull Request
echo "🔄 创建 Pull Request..."
PR_TITLE="Add Catime version $TAG_VERSION"
PR_BODY="自动提交 Catime $TAG_VERSION 版本到 winget

**包信息：**
- 包名：$PACKAGE_IDENTIFIER
- 版本：$TAG_VERSION
- 发布日期：$RELEASE_DATE
- 下载链接：$DOWNLOAD_URL
- SHA256：$SHA256_HASH

**变更内容：**
- 添加新版本清单文件
- 更新安装程序信息
- 包含英文和中文本地化

此 PR 由 GitHub Actions 自动生成。"

# 从用户 fork 向上游仓库创建 Pull Request
gh pr create \
  --title "$PR_TITLE" \
  --body "$PR_BODY" \
  --base "$DEFAULT_BRANCH" \
  --head "$GITHUB_USER:$BRANCH_NAME" \
  --repo "$UPSTREAM_REPO"

if [ $? -eq 0 ]; then
    echo "✅ Pull Request 创建成功！"
    # 获取PR信息
    PR_URL=$(gh pr list --repo "$UPSTREAM_REPO" --head "$GITHUB_USER:$BRANCH_NAME" --json url --jq '.[0].url')
    echo "🔗 PR 链接：$PR_URL"
else
    echo "❌ Pull Request 创建失败"
    echo "💡 可以手动创建 PR："
    echo "   源分支：$GITHUB_USER:$BRANCH_NAME"
    echo "   目标仓库：$UPSTREAM_REPO"
    echo "   目标分支：$DEFAULT_BRANCH"
fi

echo ""
echo "🎉 Winget 提交流程完成！"
echo "📦 版本：$TAG_VERSION"
echo "📁 清单路径：$MANIFEST_PATH"
echo "🍴 Fork：$USER_FORK"
echo "🌿 分支：$GITHUB_USER:$BRANCH_NAME"
echo "🎯 目标：$UPSTREAM_REPO"

cd ..

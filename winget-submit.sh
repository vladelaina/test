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

# 设置变量
PACKAGE_IDENTIFIER="VladElaina.Catime"
WINGET_REPO_URL="https://github.com/ywyjcloudvlad/winget-pkgs.git"
# 使用包含token的URL进行身份验证
WINGET_REPO_URL_WITH_TOKEN="https://x-access-token:${GITHUB_TOKEN}@github.com/ywyjcloudvlad/winget-pkgs.git"
MANIFEST_PATH="manifests/v/VladElaina/Catime/$TAG_VERSION"
TEMPLATE_PATH=".github/workflows/winget template"

# 克隆或更新 winget-pkgs 仓库
if [ ! -d "winget-pkgs" ]; then
    echo "克隆 winget-pkgs 仓库..."
    git clone $WINGET_REPO_URL_WITH_TOKEN winget-pkgs
else
    echo "更新 winget-pkgs 仓库..."
    cd winget-pkgs
    # 配置远程仓库URL以包含身份验证token
    git remote set-url origin $WINGET_REPO_URL_WITH_TOKEN
    git pull
    cd ..
fi

cd winget-pkgs

# 配置 git 用户信息
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

# 配置远程仓库URL以包含身份验证token
git remote set-url origin $WINGET_REPO_URL_WITH_TOKEN

# 创建新的分支
BRANCH_NAME="catime-$TAG_VERSION"
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

# 推送到远程仓库
echo "推送到远程仓库..."
git push origin $BRANCH_NAME

# 使用 GitHub CLI 自动创建 Pull Request
echo "创建 Pull Request..."
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

# 设置 GitHub CLI 身份验证
export GH_TOKEN=$GITHUB_TOKEN

# 创建 Pull Request
gh pr create \
  --title "$PR_TITLE" \
  --body "$PR_BODY" \
  --base master \
  --head $BRANCH_NAME \
  --repo ywyjcloudvlad/winget-pkgs

if [ $? -eq 0 ]; then
    echo "✅ Pull Request 创建成功！"
    PR_URL=$(gh pr view $BRANCH_NAME --repo ywyjcloudvlad/winget-pkgs --json url --jq '.url')
    echo "🔗 PR 链接：$PR_URL"
else
    echo "❌ Pull Request 创建失败，可能需要手动创建"
    echo "分支：$BRANCH_NAME"
    echo "目标：master"
fi

echo ""
echo "🎉 Winget 提交流程完成！"
echo "📦 版本：$TAG_VERSION"
echo "📁 清单路径：$MANIFEST_PATH"
echo "🌿 分支：$BRANCH_NAME"

cd ..

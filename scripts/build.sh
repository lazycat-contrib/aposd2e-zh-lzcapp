#!/usr/bin/env bash
set -euo pipefail

# 构建在 CI 内完成：克隆上游源码（打包仓库不保留上游代码），构建静态站点，产出内容目录。
UPSTREAM="https://github.com/yingang/aposd2e-zh.git"
SRC=".upstream"

rm -rf "$SRC"
git clone --depth 1 "$UPSTREAM" "$SRC"

cd "$SRC"

# 适配懒猫子域名路由：VuePress base 从 /aposd2e-zh/ 改为 /
sed -i 's|base: "/aposd2e-zh/"|base: "/"|' docs/.vuepress/config.ts

npm install
npm run build

# 复制构建产物到 content 目录（供 contentdir 打包）
cd ..
rm -rf content
mkdir -p content
cp -R "$SRC/docs/.vuepress/dist/." content/
rm -rf "$SRC"

echo "build done: content files = $(find content -type f | wc -l)"

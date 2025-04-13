#!/usr/bin/env bash

. ./setup-nodejs-env.sh
install_nodejs

# ✅ 设置 npm 代理（必须放在 install_nodejs 后面，因为 nodejs 安装可能替换 PATH）
npm config set proxy http://127.0.0.1:7890
npm config set https-proxy http://127.0.0.1:7890
npm config set registry https://registry.npmjs.org/

# 生成版本号
package_version=$(head -1 debian/changelog | sed s/.*\(\\\(.*\\\)\).*/\\1/)
last_commit=$( (git log -1 || echo dev) | head -1 | sed s/commit\ //)
echo "export const BUILD_VERSION = \"github-$package_version-$last_commit\";" > src/operator/webui/src/environments/version.ts

# 构建前端
(cd src/operator/webui/ && npm install && ./node_modules/.bin/ng build)
ok=$?

uninstall_nodejs
exit $ok

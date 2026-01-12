#!/bin/bash

REMOTE_USER="alvis"
REMOTE_HOST="alvis.org.cn"
REMOTE_DIR="/project/docker/blog/html"
REMOTE_PASS="chenjie+00"

set -e

# 生成 Hexo 静态文件
echo "🚀 生成 Hexo 静态文件..."
npm run build

# 临时上传目录，文件目录属于root
TMP_DIR="/tmp/deploy_hexo"
sshpass -p "${REMOTE_PASS}" ssh ${REMOTE_USER}@${REMOTE_HOST} "rm -rf ${TMP_DIR} && mkdir -p ${TMP_DIR}"

# 上传到临时目录
echo "📦 上传到服务器临时目录..."
sshpass -p "${REMOTE_PASS}" rsync -av --progress public/ ${REMOTE_USER}@${REMOTE_HOST}:${TMP_DIR}/

# 使用 sudo 移动到最终目录
echo "🔧 移动到目标目录（需要 sudo）..."
sshpass -p "${REMOTE_PASS}" ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo rm -rf ${REMOTE_DIR}/* && sudo mv ${TMP_DIR}/* ${REMOTE_DIR}/ && sudo rmdir ${TMP_DIR}"

echo "✅ 部署完成"

#!/bin/bash
# SearXNG 本地研究环境 - 启动脚本
# 仅监听 127.0.0.1:8888，只启用 Bing 引擎
set -e

BASE_DIR="/Volumes/HD/Code/python/SearXNG"
SRC_DIR="$BASE_DIR/searxng-src"
VENV_PY="$BASE_DIR/searxng-venv/bin/python"
SETTINGS="$BASE_DIR/etc/searxng"
LOG="/tmp/searxng-run.log"

# 检查是否已在运行
if lsof -iTCP:8888 -sTCP:LISTEN -n -P >/dev/null 2>&1; then
    echo "SearXNG 已在运行 (端口 8888)"
    exit 0
fi

cd "$SRC_DIR"
export SEARXNG_SETTINGS_PATH="$SETTINGS"
nohup "$VENV_PY" -m searx.webapp > "$LOG" 2>&1 &
disown
echo "SearXNG 已启动，PID: $!"
echo "访问地址: http://127.0.0.1:8888/"
echo "日志文件: $LOG"

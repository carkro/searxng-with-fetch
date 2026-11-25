#!/bin/bash
# SearXNG 本地研究环境 - 停止脚本
PID=$(lsof -tiTCP:8888 -sTCP:LISTEN -n -P 2>/dev/null)
if [ -n "$PID" ]; then
    kill "$PID"
    echo "SearXNG 已停止 (PID: $PID)"
else
    echo "SearXNG 未在运行"
fi

#!/bin/bash
# QQ 自动重启脚本 - 解决 X 连接数过多问题

# 查找并终止 QQ 进程（排除本脚本）
pkill -x qq 2>/dev/null || pkill -x linuxqq 2>/dev/null

# 等待进程完全退出
sleep 2

# 重新启动 QQ
nohup /usr/bin/qq > /dev/null 2>&1 &

echo "[$(date)] QQ 已重启" >> /tmp/qq-restart.log

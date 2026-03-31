#!/bin/bash
# 根据关键词智能杀进程：单个直接杀，多个交互选择
# 用法: smart-kill <关键词>

if [ -z "$1" ]; then
    echo "用法: smart-kill <关键词>"
    exit 1
fi

KEYWORD="$1"

# 找所有匹配进程（排除自身）
mapfile -t ALL_PIDS < <(pgrep -f "$KEYWORD" | grep -v "^$$\$")

if [ ${#ALL_PIDS[@]} -eq 0 ]; then
    echo "没有找到匹配 \"$KEYWORD\" 的进程"
    exit 1
fi

# 筛选父进程：其 PPID 不在匹配列表中的，即顶层匹配进程
declare -A PARENT_MAP  # PID -> 命令行
declare -a PARENT_PIDS

for pid in "${ALL_PIDS[@]}"; do
    ppid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    [ -z "$ppid" ] && continue
    is_parent=true
    for other in "${ALL_PIDS[@]}"; do
        if [ "$ppid" = "$other" ]; then
            is_parent=false
            break
        fi
    done
    if $is_parent; then
        cmd=$(ps -o args= -p "$pid" 2>/dev/null)
        [ -n "$cmd" ] && PARENT_MAP[$pid]="$cmd" && PARENT_PIDS+=("$pid")
    fi
done

if [ ${#PARENT_PIDS[@]} -eq 0 ]; then
    echo "没有找到匹配 \"$KEYWORD\" 的父进程"
    exit 1
fi

# 颜色
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

kill_process() {
    local pid=$1
    local cmd=${PARENT_MAP[$pid]}
    local timeout=5

    kill -15 "$pid" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}无法杀掉${RESET} PID=$pid（权限不足？）"
        return 1
    fi

    # 等待进程退出
    echo -e "${YELLOW}已发送 SIGTERM，等待进程退出...${RESET} PID=${RED}$pid${RESET}"
    for ((i = 0; i < timeout; i++)); do
        if ! kill -0 "$pid" 2>/dev/null; then
            echo -e "${GREEN}已杀掉${RESET} PID=${RED}$pid${RESET} ${CYAN}$cmd${RESET}"
            return 0
        fi
        sleep 1
    done

    # 超时，升级到 SIGKILL
    echo -e "${YELLOW}SIGTERM 超时，尝试 kill -9 ...${RESET}"
    kill -9 "$pid" 2>/dev/null
    sleep 0.5
    if ! kill -0 "$pid" 2>/dev/null; then
        echo -e "${GREEN}已强制杀掉${RESET} PID=${RED}$pid${RESET} ${CYAN}$cmd${RESET}"
    else
        echo -e "${RED}无法杀掉${RESET} PID=$pid"
    fi
}

# 单个直接杀
if [ ${#PARENT_PIDS[@]} -eq 1 ]; then
    kill_process "${PARENT_PIDS[0]}"
    exit 0
fi

# 多个，交互选择
echo -e "找到 ${YELLOW}${#PARENT_PIDS[@]}${RESET} 个匹配 \"$KEYWORD\" 的父进程：\n"
for i in "${!PARENT_PIDS[@]}"; do
    pid=${PARENT_PIDS[$i]}
    cmd=${PARENT_MAP[$pid]}
    echo -e "  [$((i+1))] PID=${RED}$pid${RESET}  ${CYAN}$cmd${RESET}"
done
echo -e "  [a] 全部杀掉"
echo ""

read -rp "输入序号、PID 或 a 全部杀掉: " input

if [ "$input" = "a" ] || [ "$input" = "A" ]; then
    for pid in "${PARENT_PIDS[@]}"; do
        kill_process "$pid"
    done
    exit 0
fi

if [[ "$input" =~ ^[0-9]+$ ]]; then
    if [ "$input" -ge 1 ] && [ "$input" -le ${#PARENT_PIDS[@]} ]; then
        kill_process "${PARENT_PIDS[$((input-1))]}"
    elif [ -n "${PARENT_MAP[$input]}" ]; then
        kill_process "$input"
    else
        echo "无效输入"
        exit 1
    fi
else
    echo "无效输入"
    exit 1
fi

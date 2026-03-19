#!/bin/bash
# 快捷键: Super+E (通过 GNOME 自定义快捷键绑定)
# 依赖: wmctrl (窗口列表/切换), xdotool (获取活动窗口/最小化)
# 安装: sudo apt install wmctrl xdotool
# 使用窗口类名（稳定可靠）
WINDOW_CLASS="microsoft-edge"
# 查找窗口（-x 表示按类名匹配）
WINDOW_ID=$(wmctrl -lx | grep -i "$WINDOW_CLASS" | head -n 1 | awk '{print $1}')
if [ -n "$WINDOW_ID" ]; then
    # 获取当前活动窗口ID
    ACTIVE_ID=$(xdotool getactivewindow 2>/dev/null)
    # 将wmctrl的十六进制ID转换为十进制，与xdotool比较
    WINDOW_DEC=$(printf "%d" "$WINDOW_ID" 2>/dev/null)
    if [ "$ACTIVE_ID" = "$WINDOW_DEC" ]; then
        xdotool windowminimize "$ACTIVE_ID"
    else
        wmctrl -i -a "$WINDOW_ID"
    fi
else
    microsoft-edge-stable &
fi

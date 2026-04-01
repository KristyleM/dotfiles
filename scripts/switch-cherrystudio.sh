#!/bin/bash
WINDOW_CLASS="CherryStudio"
WINDOW_ID=$(wmctrl -lx | grep "$WINDOW_CLASS" | head -n 1 | awk '{print $1}')

if [ -z "$WINDOW_ID" ]; then
    /home/qilong/Applications/Cherry-Studio-*.AppImage --no-sandbox &
    echo "🚀 已启动 CherryStudio"
    exit 0
fi

# 检查窗口是否已激活
ACTIVE_WINDOW=$(xdotool getactivewindow)
if [ "$WINDOW_ID" = "$(printf '0x%08x' $ACTIVE_WINDOW)" ]; then
    xdotool windowminimize "$ACTIVE_WINDOW"
    echo "⬇️ 已最小化 CherryStudio"
else
    wmctrl -i -a "$WINDOW_ID"
    echo "✅ 已切换到 CherryStudio"
fi

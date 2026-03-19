#!/bin/bash
# 使用窗口类名（稳定可靠）
WINDOW_CLASS="CherryStudio"
# 查找窗口（-x 表示按类名匹配）
WINDOW_ID=$(wmctrl -lx | grep "$WINDOW_CLASS" | head -n 1 | awk '{print $1}')
if [ -n "$WINDOW_ID" ]; then
    wmctrl -i -a "$WINDOW_ID"   # 切换到窗口
    echo "✅ 已切换到正在运行的 CherryStudio"
else
    # 启动 AppImage
    /home/qilong/Applications/CherryStudio.AppImage &
    echo "🚀 已启动 CherryStudio"
fi

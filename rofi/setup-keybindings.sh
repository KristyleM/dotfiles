#!/usr/bin/env bash
# rofi GNOME 快捷键设置脚本
# 需要在释放冲突键后运行，然后 Alt+F2 输入 r 重启 GNOME Shell

set -euo pipefail

PREFIX="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

# 释放 GNOME 默认占用的键
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift>XF86Keyboard']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "[]"

# Alt+Space = 启动应用
dconf write "$PREFIX/custom1/name" "'Rofi Launcher'"
dconf write "$PREFIX/custom1/command" "'rofi -show drun -show-icons'"
dconf write "$PREFIX/custom1/binding" "'<Alt>space'"

# Super+Tab = 切换窗口
dconf write "$PREFIX/custom2/name" "'Rofi Window Switcher'"
dconf write "$PREFIX/custom2/command" "'rofi -show window -show-icons'"
dconf write "$PREFIX/custom2/binding" "'<Super>Tab'"

# Super+Space = 混合模式
dconf write "$PREFIX/custom3/name" "'Rofi Combi'"
dconf write "$PREFIX/custom3/command" "'rofi -show combi -combi-modes drun,window,run -show-icons'"
dconf write "$PREFIX/custom3/binding" "'<Super>space'"

# 注册快捷键列表（保留已有的 custom0）
EXISTING=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['$PREFIX/custom0/', '$PREFIX/custom1/', '$PREFIX/custom2/', '$PREFIX/custom3/']"

echo "Done! 请按 Alt+F2 输入 r 重启 GNOME Shell 使快捷键生效。"

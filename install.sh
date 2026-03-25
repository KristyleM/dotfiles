#!/usr/bin/env bash
#
# dotfiles 安装脚本
# 通过符号链接将配置文件部署到系统对应位置
# 用法: ./install.sh [模块名...]
#   无参数则安装全部模块
#   示例: ./install.sh zsh ranger

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERR]${NC}  $*"; }

# 创建符号链接，已有文件先备份
link_file() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
            ok "已链接: $dst"
            return
        fi
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/"
        warn "已备份: $dst -> $BACKUP_DIR/"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "链接: $src -> $dst"
}

# ===================== 各模块安装函数 =====================

install_zsh() {
    info "安装 zsh 配置..."
    link_file "$DOTFILES/zsh/.zshrc"           "$HOME/.zshrc"
    link_file "$DOTFILES/zsh/.zshenv"          "$HOME/.zshenv"
    link_file "$DOTFILES/zsh/.profile"         "$HOME/.profile"
    link_file "$DOTFILES/zsh/.bashrc"          "$HOME/.bashrc"
    link_file "$DOTFILES/zsh/.pam_environment" "$HOME/.pam_environment"
    link_file "$DOTFILES/zsh/.xinputrc"        "$HOME/.xinputrc"
    link_file "$DOTFILES/zsh/.p10k.zsh"        "$HOME/.p10k.zsh"
}

install_fzf() {
    info "安装 fzf 配置..."
    link_file "$DOTFILES/fzf/.fzf.zsh"  "$HOME/.fzf.zsh"
    link_file "$DOTFILES/fzf/.fzf.bash" "$HOME/.fzf.bash"
}

install_git() {
    info "安装 git 配置..."
    link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
}

install_ranger() {
    info "安装 ranger 配置..."
    link_file "$DOTFILES/ranger/rc.conf"     "$HOME/.config/ranger/rc.conf"
    link_file "$DOTFILES/ranger/commands.py"  "$HOME/.config/ranger/commands.py"
    link_file "$DOTFILES/ranger/rifle.conf"   "$HOME/.config/ranger/rifle.conf"
    link_file "$DOTFILES/ranger/scope.sh"     "$HOME/.config/ranger/scope.sh"
}

install_zellij() {
    info "安装 zellij 配置..."
    link_file "$DOTFILES/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
}

install_fcitx5() {
    info "安装 fcitx5 配置..."
    link_file "$DOTFILES/fcitx5/config"              "$HOME/.config/fcitx5/config"
    link_file "$DOTFILES/fcitx5/profile"             "$HOME/.config/fcitx5/profile"
    link_file "$DOTFILES/fcitx5/conf/pinyin.conf"    "$HOME/.config/fcitx5/conf/pinyin.conf"
    link_file "$DOTFILES/fcitx5/conf/chttrans.conf"  "$HOME/.config/fcitx5/conf/chttrans.conf"
    link_file "$DOTFILES/fcitx5/conf/keyboard.conf"  "$HOME/.config/fcitx5/conf/keyboard.conf"
    link_file "$DOTFILES/fcitx5/conf/punctuation.conf" "$HOME/.config/fcitx5/conf/punctuation.conf"
}

install_rime() {
    info "安装 rime 配置..."
    local rime_dir="$HOME/.local/share/fcitx5/rime"
    link_file "$DOTFILES/rime/default.custom.yaml"              "$rime_dir/default.custom.yaml"
    link_file "$DOTFILES/rime/wanxiang_pro.custom.yaml"         "$rime_dir/wanxiang_pro.custom.yaml"
    link_file "$DOTFILES/rime/double_pinyin_flypy.custom.yaml"  "$rime_dir/double_pinyin_flypy.custom.yaml"
    link_file "$DOTFILES/rime/rime_ice.dict.yaml"               "$rime_dir/rime_ice.dict.yaml"
}

install_go() {
    info "安装 go 配置..."
    link_file "$DOTFILES/go/env" "$HOME/.config/go/env"
}

install_keyd() {
    info "安装 keyd 配置 (需要 sudo)..."
    if [ -f /etc/keyd/default.conf ]; then
        sudo cp /etc/keyd/default.conf "$BACKUP_DIR/keyd_default.conf" 2>/dev/null || true
    fi
    sudo mkdir -p /etc/keyd
    sudo cp "$DOTFILES/keyd/default.conf" /etc/keyd/default.conf
    ok "已复制: keyd/default.conf -> /etc/keyd/default.conf"
    warn "运行 'sudo systemctl restart keyd' 使配置生效"
}

install_scripts() {
    info "安装自定义脚本..."
    mkdir -p "$HOME/Scripts"
    link_file "$DOTFILES/scripts/smart-kill.sh"           "$HOME/Scripts/smart-kill.sh"
    link_file "$DOTFILES/scripts/switch-edge.sh"          "$HOME/Scripts/switch-edge.sh"
    link_file "$DOTFILES/scripts/switch-cherrystudio.sh"  "$HOME/Scripts/switch-cherrystudio.sh"
    link_file "$DOTFILES/scripts/restart-qq.sh"           "$HOME/Scripts/restart-qq.sh"
    link_file "$DOTFILES/scripts/rime-ice-update.sh"      "$HOME/Scripts/rime-ice-update.sh"
    link_file "$DOTFILES/scripts/ssh2spiders.sh"          "$HOME/Scripts/ssh2spiders.sh"
}

install_autostart() {
    info "安装自启动项..."
    link_file "$DOTFILES/autostart/cherry-studio.desktop" "$HOME/.config/autostart/cherry-studio.desktop"
    link_file "$DOTFILES/autostart/fcitx5.desktop"        "$HOME/.config/autostart/fcitx5.desktop"
}

install_rofi() {
    info "安装 rofi 配置..."
    link_file "$DOTFILES/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
    info "设置 rofi 快捷键..."
    bash "$DOTFILES/rofi/setup-keybindings.sh"
}

install_mimeapps() {
    info "安装默认应用配置..."
    link_file "$DOTFILES/mimeapps.list" "$HOME/.config/mimeapps.list"
}

install_nvim() {
    info "安装 nvim 配置..."
    local nvim_dst="$HOME/.config/nvim"
    # 如果目标是独立 git 仓库，先备份整个目录
    if [ -d "$nvim_dst/.git" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$nvim_dst" "$BACKUP_DIR/nvim"
        warn "已备份 nvim 目录 (含 .git): $BACKUP_DIR/nvim"
    fi
    link_file "$DOTFILES/nvim" "$nvim_dst"
}

install_ghostty() {
    info "安装 ghostty 配置..."
    link_file "$DOTFILES/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
}

install_p10k() {
    info "安装 powerlevel10k 主题..."
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ -d "$p10k_dir" ]; then
        ok "powerlevel10k 已存在: $p10k_dir"
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        ok "powerlevel10k 已克隆到: $p10k_dir"
    fi
}

# ===================== 主逻辑 =====================

ALL_MODULES=(zsh fzf git ranger rofi zellij fcitx5 rime go keyd scripts autostart mimeapps nvim ghostty p10k)

if [ $# -eq 0 ]; then
    info "安装全部模块..."
    modules=("${ALL_MODULES[@]}")
else
    modules=("$@")
fi

for mod in "${modules[@]}"; do
    if declare -f "install_$mod" > /dev/null; then
        install_"$mod"
    else
        err "未知模块: $mod"
        echo "可用模块: ${ALL_MODULES[*]}"
        exit 1
    fi
done

echo ""
info "安装完成!"
if [ -d "$BACKUP_DIR" ]; then
    warn "原文件已备份到: $BACKUP_DIR"
fi

# Dotfiles

个人开发环境配置文件，适用于 Ubuntu 24.04 + GNOME 桌面。

## 快速开始

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh          # 安装全部模块
./install.sh zsh git  # 只安装指定模块
```

安装脚本会将配置文件通过 **符号链接** 部署到系统对应位置。已有的同名文件会自动备份到 `~/.dotfiles_backup/<时间戳>/`。

## 模块说明

### zsh — Shell 环境

**文件:** `.zshrc` `.zshenv` `.profile` `.bashrc` `.pam_environment` `.xinputrc`

| 文件 | 部署位置 | 说明 |
|------|---------|------|
| `.zshrc` | `~/.zshrc` | 主配置：oh-my-zsh + ys 主题 + pyenv/go/fzf 集成 |
| `.zshenv` | `~/.zshenv` | cargo 环境变量 |
| `.profile` | `~/.profile` | fcitx5 输入法环境变量、cargo |
| `.bashrc` | `~/.bashrc` | bash 基础配置 |
| `.pam_environment` | `~/.pam_environment` | 混合语言环境：界面英文，数字/日期中文格式 |
| `.xinputrc` | `~/.xinputrc` | 指定输入法框架为 fcitx5 |

**oh-my-zsh 插件（需手动安装）：**

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

**自定义函数：**
- `ra` — 启动 ranger 文件管理器，退出后自动 cd 到最后浏览的目录

---

### fzf — 模糊搜索

**文件:** `.fzf.zsh` `.fzf.bash`

| 文件 | 部署位置 | 说明 |
|------|---------|------|
| `.fzf.zsh` | `~/.fzf.zsh` | zsh 集成，优先使用 `~/.fzf/bin` 中的版本 |
| `.fzf.bash` | `~/.fzf.bash` | bash 集成 |

**依赖：** fzf（推荐从源码安装到 `~/.fzf/`）

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

---

### git — Git 配置

**文件:** `.gitconfig` → `~/.gitconfig`

当前配置将所有 GitHub HTTPS URL 重写为 SSH：

```
[url "git@github.com:"]
    insteadOf = https://github.com/
```

> 需要先配置 SSH 密钥：`ssh-keygen -t ed25519`

---

### ranger — 终端文件管理器

**文件:** `rc.conf` `commands.py` `rifle.conf` `scope.sh` → `~/.config/ranger/`

主要特性：
- 列分隔线 + 相对行号（方便 Vim 式跳转）
- Git 仓库文件状态显示
- w3m 图片预览 + highlight 语法高亮
- molokai 高亮配色

| 快捷键 | 功能 |
|--------|------|
| `Ctrl-f` | fzf 模糊搜索文件 |
| `Ctrl-g` | fzf 模糊搜索目录并 cd |
| `cR` | 批量重命名 |
| `X` | 解压文件 |
| `Z` | 压缩文件 |
| `gD` / `gP` | 快速跳转到 ~/Downloads / ~/Projects |
| `zh` | 切换显示隐藏文件 |

**依赖：**

```bash
sudo apt install ranger highlight atool w3m w3m-img bat
```

> 环境变量 `RANGER_LOAD_DEFAULT_RC=FALSE` 可以避免加载双份默认配置。

---

### rofi — 应用启动器 / 窗口切换

**文件:** `config.rasi` `setup-keybindings.sh` → `~/.config/rofi/`

基于 Nord 配色的居中浮动主题，模糊搜索，支持多种模式。

| 快捷键 | 功能 |
|--------|------|
| `Alt+Space` | 启动应用 |
| `Super+Tab` | 切换窗口 |
| `Super+Space` | 混合模式（应用 + 窗口 + 命令） |
| `Tab` | 在 rofi 内切换模式 |
| `Ctrl+J/K` | 上下选择 |
| `Esc` | 关闭 |

**安装：**

```bash
sudo apt install rofi
```

**快捷键设置：**

`setup-keybindings.sh` 会释放 GNOME 默认占用的 `Super+Space` / `Super+Tab` / `Alt+Space`，并注册 rofi 快捷键。设置后需要按 `Alt+F2` 输入 `r` 重启 GNOME Shell 使快捷键生效。

> 释放的 GNOME 快捷键不影响日常使用：输入法用 `Ctrl+Space`，窗口切换用 `Alt+Tab`。

---

### zellij — 终端复用器

**文件:** `config.kdl` → `~/.config/zellij/config.kdl`

完全自定义键位（`clear-defaults=true`），tmux 风格前缀键：

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+b` | tmux 模式（然后按方向键/分割键等） |
| `Alt+h/j/k/l` | 在面板间移动焦点 |
| `Ctrl+g` | 锁定/解锁 |
| `Ctrl+q` | 退出 |

**安装：**

```bash
cargo install zellij
# 或下载预编译二进制
```

---

### fcitx5 — 输入法框架

**文件:** `config` `profile` `conf/*.conf` → `~/.config/fcitx5/`

| 文件 | 说明 |
|------|------|
| `config` | 触发键 Ctrl+Space，候选词 5 个 |
| `profile` | 默认使用 Rime 输入法 |
| `conf/pinyin.conf` | 自然码双拼，模糊音，`-`/`=` 翻页 |
| `conf/punctuation.conf` | 字母/数字后自动半角标点 |
| `conf/chttrans.conf` | Ctrl+Shift+F 切换繁简 |

**安装：**

```bash
sudo apt install fcitx5 fcitx5-rime fcitx5-chinese-addons
```

---

### rime — Rime 输入法方案

**文件:** `*.yaml` → `~/.local/share/fcitx5/rime/`

| 文件 | 说明 |
|------|------|
| `default.custom.yaml` | 使用小鹤双拼方案，CapsLock 清除，Shift 上屏，方括号翻页 |
| `double_pinyin_flypy.custom.yaml` | 挂载 rime-ice 词库，默认简体 |
| `rime_ice.dict.yaml` | 主词典配置：通用字集 + 腾讯词库 + 英文补全 |

**词库依赖（rime-ice）：**

```bash
# 使用附带的更新脚本
bash ~/Scripts/rime-ice-update.sh
```

---

### go — Go 语言环境

**文件:** `env` → `~/.config/go/env`

```
GOPRIVATE=github.com/mbytetech
```

设置私有模块域名，`go get` 不走公共代理。

---

### keyd — 键盘重映射

**文件:** `default.conf` → `/etc/keyd/default.conf`（需要 sudo）

```
capslock = timeout(C-space, 500, capslock)
```

CapsLock 短按 = Ctrl+Space（切换输入法），长按 500ms = 真正的 CapsLock。

**安装及生效：**

```bash
# 安装 keyd
sudo apt install keyd  # 或从源码编译
# 安装配置后重启服务
sudo systemctl restart keyd
```

---

### scripts — 自定义脚本

| 脚本 | 部署位置 | 说明 |
|------|---------|------|
| `rime-ice-update.sh` | `~/Scripts/` | 从 GitHub 拉取 rime-ice 词库并部署 |
| `switch-cherrystudio.sh` | `~/Scripts/` | 用 wmctrl 聚焦/启动 Cherry Studio |

---

### autostart — 自启动项

**文件:** `*.desktop` → `~/.config/autostart/`

- `fcitx5.desktop` — 开机启动 fcitx5 输入法
- `cherry-studio.desktop` — 开机启动 Cherry Studio

---

### mimeapps — 默认应用

**文件:** `mimeapps.list` → `~/.config/mimeapps.list`

- 默认浏览器：Google Chrome
- `.desktop` 文件用 VS Code 打开

---

## 新机器部署清单

```bash
# 1. 基础工具
sudo apt install zsh git curl

# 2. oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3. oh-my-zsh 插件
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 4. fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# 5. 开发工具
sudo apt install ranger highlight atool w3m w3m-img bat rofi
sudo apt install fcitx5 fcitx5-rime fcitx5-chinese-addons

# 6. 部署配置
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles && ./install.sh

# 7. rime 词库
bash ~/Scripts/rime-ice-update.sh
```

## 目录结构

```
dotfiles/
├── install.sh              # 安装脚本
├── .gitignore
├── README.md
├── zsh/                    # Shell 配置
├── fzf/                    # fzf 集成
├── git/                    # Git 配置
├── ranger/                 # ranger 文件管理器
├── rofi/                   # rofi 启动器 / 窗口切换
├── zellij/                 # zellij 终端复用器
├── fcitx5/                 # fcitx5 输入法框架
│   └── conf/
├── rime/                   # Rime 输入法方案
├── go/                     # Go 语言环境
├── keyd/                   # 键盘重映射 (系统级)
├── scripts/                # 自定义脚本
├── autostart/              # 自启动项
└── mimeapps.list           # 默认应用
```

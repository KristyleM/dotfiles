#!/bin/bash

RIME_DIR="$HOME/.local/share/fcitx5/rime"
REPO_DIR="$HOME/.local/share/rime-ice"

# 首次 clone 或后续 pull
if [ -d "$REPO_DIR" ]; then
    echo "更新 rime-ice 仓库..."
    git -C "$REPO_DIR" pull --ff-only
else
    echo "克隆 rime-ice 仓库..."
    git clone --depth 1 https://github.com/iDvel/rime-ice "$REPO_DIR"
fi

# 复制词典文件
echo "复制词典文件..."
cp -r "$REPO_DIR/cn_dicts" "$RIME_DIR/"
cp -r "$REPO_DIR/en_dicts" "$RIME_DIR/"
cp "$REPO_DIR/rime_ice.dict.yaml" "$RIME_DIR/"

# 重新部署
echo "重新部署 Rime..."
fcitx5-remote -r

echo "更新完成！"

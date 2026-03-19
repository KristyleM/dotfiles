# Setup fzf
# ---------
if [[ ! "$PATH" == */home/qilong/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/qilong/.fzf/bin"
fi

eval "$(fzf --bash)"

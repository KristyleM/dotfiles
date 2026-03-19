# Setup fzf
# ---------
if [[ ! "$PATH" == */home/qilong/.fzf/bin* ]]; then
  PATH="/home/qilong/.fzf/bin${PATH:+:${PATH}}"
fi

source <(fzf --zsh)

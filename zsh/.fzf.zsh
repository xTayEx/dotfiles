# Setup fzf
# ---------
if [[ ! "$PATH" == */home/xtyaex/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/xtayex/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/xtayex/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/xtayex/.fzf/shell/key-bindings.zsh"

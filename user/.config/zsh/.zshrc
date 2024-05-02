unsetopt FLOW_CONTROL
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt COMPLETE_IN_WORD
setopt HIST_IGNORE_ALL_DUPS

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$XDG_CACHE_HOME/zsh/history"

autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

eval "$(starship init zsh)"
. ~/.config/shell/aliasrc 2>/dev/null
. /usr/share/zsh/plugins/catppuccin*.zsh 2>/dev/null
. /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh 2>/dev/null
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history
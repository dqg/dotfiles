unsetopt FLOW_CONTROL
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt COMPLETE_IN_WORD
setopt HIST_IGNORE_DUPS

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$XDG_CACHE_HOME/zsh/history"

clear() {
    printf "\e[3J\e[H"
    zle reset-prompt
}
autoload -U edit-command-line
autoload -U compinit

zle -N clear
zle -N edit-command-line
compinit

_comp_options+=(globdots)
zstyle ":completion:*" menu select
zmodload zsh/complist

eval "$(starship init zsh)"
. ~/.config/shell/aliasrc
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
. /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh

bindkey "^E" edit-command-line
bindkey -M vicmd "^E" edit-command-line
bindkey "^L" clear
bindkey -M vicmd "^L" clear
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history

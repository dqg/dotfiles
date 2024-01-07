zle-keymap-select() {
	case $KEYMAP in
		vicmd) printf "\033[1 q"; mode="❮";;
		*) printf "\033[5 q"; mode="❯";;
	esac
	zle reset-prompt
}
zle -N zle-keymap-select

zle-line-init() {
	zle -K viins
	mode="❯"
	printf "\033[5 q"
	zle reset-prompt
}
zle -N zle-line-init

zgst() {
	g1=$(git status -sb 2>/dev/null) || return 1
	g1=$(echo "$g1" | sed "s/ \[\(.*\)\]$/\n\1/" | tail +2)
	printf "  $(git branch --show-current)%%F{yellow}"
	[ -z "$g1" ] && { printf " ✔"; return 1; }
	set -- + » ? ! "✘ " ⇣ ⇡
	for x in "[ADM] " "R " "??" " M" " D"; do
		g2=$(echo "$g1" | grep -c "^$x ")
		[ "$g2" = "0" ] || printf " $1$g2"
		shift
	done; unset x
	for x in "behind" "ahead"; do
		g2=$(echo "$g1" | grep -o "$x [0-9]*")
		[ -n "$g2" ] && printf " $1${g2#* }"
		shift
	done; unset x
}
PS1="%B%F{blue}%~%F{cyan}\$(zgst) %(?.%F{green}.%F{red})\$mode%b%f "

unsetopt FLOW_CONTROL
setopt PROMPT_SUBST
setopt AUTO_CD
setopt NO_NOMATCH
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

autoload -U compinit && compinit
_comp_options+=(globdots)
zstyle ":completion:*" menu select
zmodload zsh/complist
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history

autoload -U edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line
bindkey -M vicmd "^e" edit-command-line

zsh_clear() { printf "\033[3J\033[H"; zle reset-prompt; }
zle -N zsh_clear
bindkey "^L" zsh_clear
bindkey -M vicmd "^L" zsh_clear

bindkey -v
bindkey "^?" backward-delete-char
bindkey -M vicmd "^?" backward-delete-char

zle_highlight=(region:fg=#cdd6f4,bg=#d20f39)
source $XDG_CONFIG_HOME/catppuccin/catppuccin_mocha-zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $XDG_CONFIG_HOME/shell/aliasrc
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

cat $XDG_CACHE_HOME/wal/sequences


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%~"$'\n'"> %"

# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/history
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/fun/.zshrc'
fpath+=$HOME/.config/zsh/pure
autoload -Uz compinit promptinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

promptinit
prompt pure
_comp_options+=(globdots)
# End of lines added by compinstall


source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

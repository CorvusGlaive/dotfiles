export ZDOTDIR="$HOME/.config/zsh"

export EDITOR="nano"

export LESS_TERMCAP_mb=$(tput bold; tput setaf 5)
export LESS_TERMCAP_md=$(tput bold; tput setaf 5)
export LESS_TERMCAP_so=$(tput bold; tput rev; tput setaf 2;)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 1)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_me=$(tput sgr0)



alias cfg='/usr/bin/git --git-dir=$HOME/.git/ --work-tree=$HOME'
alias ls='ls --color=auto'

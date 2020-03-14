#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export NNN_PLUG='o:fzopen;p:mocplay;d:diffs;m:nmount;n:notes;v:imgviu;i:imgthumb;'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 5)
export LESS_TERMCAP_md=$(tput bold; tput setaf 5)
export LESS_TERMCAP_so=$(tput bold; tput rev; tput setaf 2;)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 1)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_me=$(tput sgr0)


alias cfg='/usr/bin/git --git-dir=$HOME/.git/ --work-tree=$HOME'


#exec fish

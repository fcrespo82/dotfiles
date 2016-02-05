#!/usr/bin/env bash

export DOTFILES_VERSION=1.0

if [ -d $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Add $HOME/bin to $PATH
if [[ $PATH != *$HOME/bin* ]]; then
    export PATH=$PATH:$HOME/bin
fi

# Add $DOTFILES_ROOT/bin to $PATH
if [[ $PATH != *$DOTFILES_ROOT/bin* ]]; then
    export PATH=$PATH:$DOTFILES_ROOT/bin
fi

LS_CUSTOM_FLAGS="-Fh"

if [[ $(uname) = *[Ll]inux* ]]; then
    source $DOTFILES_ROOT/linux.sh
elif [[ $(uname) = *[Dd]arwin* ]]; then
    source $DOTFILES_ROOT/mac.sh
fi

# ---- BEGIN PYTHON ----
# Only executes if virtualenv is installed
if [ -e "$(which virtualenv 2> /dev/null)" ]; then
    export VIRTUALENV_ROOT=$HOME/.virtualenv

    function mkvirtualenv() {
        if [[ $1 ]]; then
            virtualenv $VIRTUALENV_ROOT/$1;
        else
            echo "usage: mkvirtualenv <name>";
        fi
    }

    function mkvirtualenv3() {
        if [[ $1 ]]; then
            virtualenv -p python3 $VIRTUALENV_ROOT/$1;
        else
            echo "usage: mkvirtualenv3 <name>";
        fi
    }

fi
# ----- END PYTHON -----

# ---- START BASH CALCULATOR ----
? () { echo "scale=2
define mod(x) {
   if (x < 0) return -x else return x
}
$*" | bc -l; }
# ----- END BASH CALCULATOR -----

# --- START BASH COMPLETE ---
complete -a alias

for f in $DOTFILES_ROOT/bash_completion/*-completion.bash; do
   source $f
done

# ---- END BASH COMPLETE ----

# ---- BEGIN ALIASES ----
alias ssh-webfaction='ssh -p 3456 fcrespo82@ssh.crespo.net.br'
alias ssh-amazon='ssh -p 23 ubuntu@amazon.crespo.in'
alias realpath='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(path)"'
alias realdirname='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.dirname(os.path.realpath(path))"'
alias ls='command ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}'
alias l='ls'
alias lsa='ls -A'
alias ll='ls -l' # all files, in long format
alias lla='ll -A' # all files inc dotfiles, in long format
alias lld='ll | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->" --color=NEVER'
alias grep='grep --color'
alias sudo='sudo ' # Allow sudo other aliases
alias watch='watch ' # Allow watch other aliases
alias untar='tar -vxf'
alias untar-bz2='tar -vxjf'
alias untar-gzip='tar -vxzf'
alias tar-bz2='tar -vcjf'
alias tar-gzip='tar -vczf'

# You must install Pygments first - "sudo pip install Pygments"
if [ -e "$(which pygmentize 2> /dev/null)" ]; then
    alias c='pygmentize -O style=monokai -f console256 -g'
fi

# Git
# You must install Git first
if [ -x "$(which git 2> /dev/null)" ]; then
    alias gs='git status'
    alias ga='git add -i' # Interactive
    alias gu='git add -u :/' # Update Tracked files
    alias gaa='git add .'
    alias gc='git commit -m' # requires you to type a commit message
    alias gp='git push'
    alias gd="git diff"
    alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'
fi

alias update-dotfiles='source ~/.bash_profile'

alias pgrep='pgrep -f'
alias pkill='pkill -f'
# ----- END ALIASES -----

# ---- BEGIN BINDINGS ----
if [[ $- =~ .*i.* ]]; then
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'
    bind '"\e[1;5C":forward-word'
    bind '"\e[1;5D":backward-word'
fi
# ----- END BINDINGS -----

# ---- BEGIN VARIABLES ----
_EDITOR="nano"

export EDITOR="$_EDITOR"
export GIT_EDITOR="$_EDITOR"
export CVSEDITOR="$_EDITOR"
export VISUAL="$_EDITOR"
# ----- END VARIABLES -----

# ---- BEGIN COLORS ----
### Prompt Colors
# Modified version of @gf3’s Sexy Bash Prompt
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

export BLACK=$(tput setaf 0)
export MAGENTA=$(tput setaf 9)
export ORANGE=$(tput setaf 172)
export GREEN=$(tput setaf 10)
export PURPLE=$(tput setaf 141)
export WHITE=$(tput setaf 15)
export RED=$(tput setaf 9)
export BLUE=$(tput setaf 4)
export YELLOW=$(tput setaf 11)
export BOLD=$(tput bold)
export RESET=$(tput sgr0)

## Functions
function print_colors() {
    for i in {0..256}; do echo $(tput setaf $i) COLOR $i; done;
}
# ----- END COLORS -----

# ---- BEGIN PROMPT ----
function _update_ps1() {
    export PYTHONIOENCODING='utf8'
    export PS1="$($DOTFILES_ROOT/bin/powerline-shell.py $? 2> /dev/null)"
}
# Only show the current directory's name in the tab
# echo -ne "\033]0; ${PWD##*/}\007"
export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# ----- END PROMPT -----

# ----- BEGIN HISTORY SYNC IN ALL TERMINAL -----
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace:ignoredups:erasedups   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# ------ END HISTORY SYNC IN ALL TERMINAL ------

# ----- BEGIN HH HISTORY SEARCH -----
if [ -e "$(which hh 2> /dev/null)" ]; then
    export HH_CONFIG=hicolor         # get more colors
    # if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi
fi
# ------ END HH HISTORY SEARCH ------

#!/usr/bin/env bash

# ---- BEGIN BASICS ----
export DOTFILES_VERSION=1.1

# Add $HOME/bin to $PATH
if [[ $PATH != *$HOME/bin* ]]; then
    export PATH=$PATH:$HOME/bin
fi

# Add $DOTFILES_ROOT/bin to $PATH
if [[ $PATH != *$DOTFILES_ROOT/bin* ]]; then
    export PATH=$PATH:$DOTFILES_ROOT/bin
fi

# ---- BEGIN HISTORY SYNC IN ALL TERMINAL ----
shopt -s histappend              # append new history items to .bash_history
# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignorespace:ignoredups:erasedups   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# ---- END HISTORY SYNC IN ALL TERMINAL ----

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# ---- END BASICS ----

# ---- BEGIN VARIABLES ----
if [ -e $DOTFILES_ROOT/variables.sh ]; then
    source $DOTFILES_ROOT/variables.sh
fi
# ---- END VARIABLES ----

# ---- BEGIN CHOOSE OS ----
if [[ $(uname) = *[Ll]inux* ]]; then
    source $DOTFILES_ROOT/linux.sh
elif [[ $(uname) = *[Dd]arwin* ]]; then
    source $DOTFILES_ROOT/mac.sh
fi
# ---- END CHOOSE OS ----

# ---- BEGIN PYTHON ----
export PYTHONIOENCODING='utf8'
    
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
# ---- END PYTHON ----


# ---- START BASH COMPLETION ----
complete -a alias

if [ -d $DOTFILES_ROOT/bash_completion.d ]; then
    for f in $DOTFILES_ROOT/bash_completion.d/*; do
    source $f
    done
fi
# ---- END BASH COMPLETION ----

# ---- BEGIN ALIASES ----
if [ -d $DOTFILES_ROOT/bash_aliases.d ]; then
    for f in $DOTFILES_ROOT/bash_aliases.d/*; do
    source $f
    done
fi
# ---- END ALIASES ----

# ---- BEGIN FUNCTIONS ----
if [ -d $DOTFILES_ROOT/bash_functions.d ]; then
    for f in $DOTFILES_ROOT/bash_functions.d/*; do
        source $f
    done
fi
# ---- END FUNCTIONS ----


# ---- BEGIN BINDINGS ----
if [[ $- =~ .*i.* ]]; then
    bind '"\e[A":history-search-backward'
    bind '"\e[B":history-search-forward'
    bind '"\e[1;5C":forward-word'
    bind '"\e[1;5D":backward-word'
fi
# ---- END BINDINGS ----

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
export GREEN="\[\033[32m\]"
export PURPLE=$(tput setaf 141)
export WHITE=$(tput setaf 15)
export RED="\[\033[31m\]"
export BLUE=$(tput setaf 4)
export YELLOW=$(tput setaf 11)
export BOLD=$(tput bold)
export RESET="\[\033[0m\]"


## Functions
function print_colors() {
    for i in {0..256}; do echo $(tput setaf $i) COLOR $i; done;
}
# ---- END COLORS ----

# ---- BEGIN PROMPT ----
source bash_prompt.sh
# ---- END PROMPT ----



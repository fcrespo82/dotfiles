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

    _activate()
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(command ls $VIRTUALENV_ROOT 2>/dev/null)"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    }

    function activate() {
        source $VIRTUALENV_ROOT/$1/bin/activate
    }

    function virtualenv-create() {
        if [[ $1 ]]; then
            virtualenv $VIRTUALENV_ROOT/$1;
        else
            echo "usage: virtualenv-create <name>";
        fi
    }

    complete -F _activate activate
fi

#python bash calculator
function my_calc() {
    python <<< "print $*"
}
alias ?=my_calc

# ----- END PYTHON -----

# --- START BASH COMPLETE ---
complete -a alias
# ---- END BASH COMPLETE ----

# ---- BEGIN ALIASES ----
alias ssh-webfaction='ssh -p 3456 fcrespo82@ssh.crespo.net.br'
alias realpath='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(path)"'
alias realdirname='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.dirname(os.path.realpath(path))"'
alias ls="command ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}"
alias l="ls"
alias lsa="ls -A"
alias ll="ls -l" # all files, in long format
alias lla="ll -A" # all files inc dotfiles, in long format
alias lld='ll | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->" --color=NEVER'
alias grep='grep --color'
alias sudo='sudo ' # Allow sudo other aliases
alias watch='watch ' # Allow watch other aliases

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
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

bind '"\e[1;5C":forward-word'
bind '"\e[1;5D":backward-word'
# ----- END BINDINGS -----

# ---- BEGIN VARIABLES ----
_EDITOR="subl"

export EDITOR="$_EDITOR -w"
export GIT_EDITOR="$_EDITOR -w"
export CVSEDITOR="$_EDITOR -w"
export VISUAL="$_EDITOR -w"
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
    export PS1="$($DOTFILES_ROOT/bin/powerline-shell.py $? 2> /dev/null)"
}
# Only show the current directory's name in the tab
# echo -ne "\033]0; ${PWD##*/}\007"
export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# ----- END PROMPT -----

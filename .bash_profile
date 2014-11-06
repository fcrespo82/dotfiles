export DOTFILES_PATH=$HOME/developer/dotfiles-dev
#export DOTFILES_VERBOSE=0

# Add $DOTFILES_PATH/bin to $PATH
if [[ $PATH != *$DOTFILES_PATH/bin* ]]; then
    export PATH=$DOTFILES_PATH/bin:$PATH
fi

LS_CUSTOM_FLAGS="-Fh"

_is_linux=$([[ $(uname) = *[Ll]inux* ]])
_is_mac=$([[ $(uname) = *[Dd]arwin* ]])

if $_is_linux; then
    source $DOTFILES_PATH/linux.sh
elif $_is_mac; then
    source $DOTFILES_PATH/mac.sh
fi

# ---- BEGIN PYTHON ----
# Only executes if virtualenv is installed
if [ -e "$(which virtualenv)" ]; then
    export VIRTUALENV_ROOT=$HOME/.virtualenv

    _activate() 
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(command ls $VIRTUALENV_ROOT)"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    }

    function activate() {
        source $VIRTUALENV_ROOT/$1/bin/activate
    }

    function virtualenv-create() {
        virtualenv $VIRTUALENV_ROOT/$1
    }

    complete -F _activate activate
fi
# ----- END PYTHON -----

# ---- BEGIN ALIASES ----

alias ssh-webfaction='ssh -p 3456 fcrespo82@ssh.crespo.net.br'
alias realpath='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(path)"'
alias realdirname='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(os.path.dirname(path))"'
alias ls="command ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}"
alias l="ls"
alias lsa="ls -A ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}"
alias ll="ls -l ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}" # all files, in long format
alias lla="ll -A ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}" # all files inc dotfiles, in long format
alias lld='ll ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS} | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->" --color=NEVER'
alias grep='grep --color'
alias sudo='sudo ' # Allow sudo other aliases

# You must install Pygments first - "sudo pip install Pygments"
if [ -e "$(which pygmentize)" ]; then
    alias c='pygmentize -O style=monokai -f console256 -g'
else
    echo "${RED}ERROR: ${RESET}Pygments is not installed, aliases not installed"
fi

# Git
# You must install Git first
if [ -x "$(which git)" ]; then
    alias gs='git status'
    alias ga='git add -i' # Interactive
    alias gu='git add -u :/' # Update Tracked files
    alias gaa='git add .'
    alias gc='git commit -m' # requires you to type a commit message
    alias gp='git push'
    alias gd="git diff"
    alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'
else
    echo "${RED}ERROR: ${RESET}Git is not installed, aliases not installed"
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
    export PS1="$($DOTFILES_PATH/bin/powerline-shell.py $? 2> /dev/null)"
}
# Only show the current directory's name in the tab
# echo -ne "\033]0; ${PWD##*/}\007"
export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# ----- END PROMPT -----

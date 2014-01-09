function test_os() {
    if [[ $(uname -o) == *"inux"* ]]; then
        is_linux=true
        is_mac=false
    else;
        is_mac=true
        is_linux=false
    fi
}
test_os

### Aliases
# Open specified files in Sublime Text
# "s ." will open the current directory in Sublime
if [[ is_linux ]]; then
    alias s='subl -a '
elif [[ is_mac ]]; then
    alias s='open -a "Sublime\ Text"'
fi

# Color LS
if [[ is_linux ]]; then
    colorflag="--color"
elif [[ is_mac ]]; then
    colorflag="-G"
fi
myflags="-Fh"
alias ls="command ls ${colorflag} ${myflags}"
alias lsa="ls -a ${colorflag} ${myflags}"
alias l="ls -lF ${colorflag} ${myflags}" # all files, in long format
alias la="ls -laF ${colorflag} ${myflags}" # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} ${myflags} | grep "^d"' # only directories
alias grep='grep --color'

# Quicker navigation
alias ..="cd .."

# Shortcuts to my Code folder in my home directory
alias scripts="cd ~/git/scripts"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Colored up cat!
# You must install Pygments first - "sudo easy_install Pygments"
alias c='pygmentize -O style=monokai -f console256 -g'

# Git 
# You must install Git first - ""
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'

if [[ is_linux ]]; then
    alias restart_unity='setsid unity'
    alias restart_lightdm='sudo service lightdm restart'
    alias o='gnome-open'
elif [[ is_mac ]]; then
    alias grep='grep' #only space filler, replace with something usefull
fi

alias update_bash='source ~/.bash_profile'
alias pgrep='pgrep -fl'

### Prompt Colors 
# Modified version of @gf3’s Sexy Bash Prompt 
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        BLACK=$(tput setaf 0)
        MAGENTA=$(tput setaf 9)
        ORANGE=$(tput setaf 172)
        GREEN=$(tput setaf 10)
        PURPLE=$(tput setaf 141)
        WHITE=$(tput setaf 15)
        RED=$(tput setaf 9)
        BLUE=$(tput setaf 4)
        YELLOW=$(tput setaf 11)
    else
        BLACK=$(tput setaf 190)
        MAGENTA=$(tput setaf 5)
        ORANGE=$(tput setaf 4)
        GREEN=$(tput setaf 2)
        PURPLE=$(tput setaf 1)
        WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
else
    BLACK="\033[01;30m"
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

export BLACK
export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export RED
export BLUE
export BOLD
export RESET

## Functions

function print_colors() {
    for i in {0..256}; do echo $(tput setaf $i) COLOR $i; done;
}

# Git branch details
function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "$BOLD$RED"
}
function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$(parse_git_dirty)\1$RESET/"
}

# Change this symbol to something sweet. 
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="\$ "
#⚡
export PS1="\[$YELLOW\]\u \[$WHITE\]in \[$BOLD\]\[$BLUE\]\w\[$RESET\]\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$GREEN\]\$(parse_git_branch)\[$WHITE\]\n$symbol\[$RESET\]"
export PS2="\[$ORANGE\]➜ \[$RESET\]"
#→➜

### Misc

# Only show the current directory's name in the tab 
export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'

# init z! (https://github.com/rupa/z)
. ~/z.sh

# Local Python installation with virtualenv
PATH=~/.local/python/bin:$PATH
export PATH

# Instalacao das Funcoes ZZ (www.funcoeszz.net)
export ZZOFF=""  # desligue funcoes indesejadas
export ZZPATH="/home/fernando/git/funcoeszz/funcoeszz"  # script
export ZZDIR="/home/fernando/git/funcoeszz/zz"  # script
source "$ZZPATH"

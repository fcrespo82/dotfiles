function set_os() {
    if [[ $(uname -a) == *"inux"* ]]; then
        is_linux=true
        is_mac=false
    elif [[ $(uname -a) == *"arwin"* ]]; then
        is_mac=true
        is_linux=false
    fi
}
set_os

### Aliases
# Open specified files in Sublime Text
# "s ." will open the current directory in Sublime
if $is_linux; then
    alias s='subl -a '
elif $is_mac; then
    alias s='open -a "Sublime Text"'
fi

# Color LS
if $is_linux; then
    colorflag="--color"
elif $is_mac; then
    colorflag="-G"
fi
myflags="-Fh"
alias ls="command ls ${colorflag} ${myflags}"
alias lsa="ls -a ${colorflag} ${myflags}"
alias ll="ls -l ${colorflag} ${myflags}" # all files, in long format
alias lla="ll -a ${colorflag} ${myflags}" # all files inc dotfiles, in long format
alias lld='ll ${colorflag} ${myflags} | grep "/$"' # only directories
alias lls='lla | cut -c -11,50- | grep "\->"'
alias grep='grep --color'

# Quicker navigation
alias ..="cd .."

# Shortcuts to my Code folder in my home directory
alias scripts="cd ~/developer/scripts"

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
alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'

if $is_linux; then
    alias restart_unity='setsid unity'
    alias restart_lightdm='sudo service lightdm restart'
    alias o='gnome-open'
    export LS_COLORS="di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=01;00:sg=01;00;41:tw=01;00;46:ow=01;00;42:"
else
    export LSCOLORS="ExGxFxDxCxDxDxxxxbxgxc";
fi

alias dotfiles_update='source ~/.bash_profile'
alias pgrep='pgrep -f'

### Prompt Colors 
# Modified version of @gf3’s Sexy Bash Prompt 
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

BLACK=$(tput setaf 0)
MAGENTA=$(tput setaf 9)
ORANGE=$(tput setaf 172)
GREEN=$(tput setaf 10)
PURPLE=$(tput setaf 141)
WHITE=$(tput setaf 15)
RED=$(tput setaf 9)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 11)
BOLD=$(tput bold)
RESET=$(tput sgr0)

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

function enable_git() {
    export PS1=$PS1_GIT
}

function disable_git() {
    export PS1=$PS1_NO_GIT
}
# Git branch details
function parse_git_dirty() {
    [[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "$BOLD$RED"
}
function parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$(parse_git_dirty)\1$RESET/"
}

SSH=""
if [ "$SSH_CONNECTION" ]; then
    SSH="@\h"
fi

# Change this symbol to something sweet. 
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="\$ "
#⚡→➜

PS1_GIT="\[$YELLOW\]\u$SSH \[$WHITE\]in \[$BOLD\]\[$BLUE\]\w\[$RESET\]\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"[\")\[$GREEN\]\$(parse_git_branch)\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"]\")\n$symbol\[$RESET\]"
PS1_NO_GIT="\[$YELLOW\]\u$SSH \[$WHITE\]in \[$BOLD\]\[$BLUE\]\w\[$RESET\]\[$WHITE\]\n$symbol\[$RESET\]"

export PS1=$PS1_NO_GIT
export PS2="\[$ORANGE\]➜ \[$RESET\]"

### Misc

# Only show the current directory's name in the tab 
export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'

# init z! (https://github.com/rupa/z)
. ~/z.sh

# Local Python installation with virtualenv
# Disabled because the OS X libraries stayed out of the path
#PATH=~/.local/python/bin:$PATH
#export PATH

source ~/.dotfiles_config

# Instalacao das Funcoes ZZ (www.funcoeszz.net)
export ZZOFF=""  # desligue funcoes indesejadas
export ZZPATH="$DOTFILES_PATH/funcoeszz/funcoeszz"  # script
export ZZDIR="$DOTFILES_PATH/funcoeszz/zz"  # script
source "$ZZPATH"

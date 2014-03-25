if [[ $(uname -a) =~ [Ll]inux ]]; then
    _is_linux=true
    _is_mac=false
elif [[ $(uname -a) =~ [Dd]arwin ]]; then
    _is_mac=true
    _is_linux=false
else
    echo "Cannot determine what SO you are running"
fi

. ~/.dotfiles_config

DOTFILES_MY_FLAGS="-Fh"

if $_is_linux; then
    . ~/.bash_profile_linux
elif $_is_mac; then
    . ~/.bash_profile_mac
fi

# ---- BEGIN PYTHON ----
# Virtualenvwrapper stuff
if [ -x /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/virtualenvs
    export PROJECT_HOME=$HOME/developer
    . /usr/local/bin/virtualenvwrapper.sh
fi

# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# ----- END PYTHON -----

# ---- BEGIN ALIASES ----

alias realpath='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(path)"'
alias realdirname='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(os.path.dirname(path))"'
alias ls="command ls ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}"
alias lsa="ls -a ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}"
alias ll="ls -l ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}" # all files, in long format
alias lla="ll -a ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}" # all files inc dotfiles, in long format
alias lld='ll ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS} | grep "/$"' # only directories
alias lls='lla | cut -c -11,50- | grep "\->"'
alias grep='grep --color'

alias scripts="cd ~/developer/scripts"
alias sudo='sudo ' # Allow sudo other aliases

# You must install Pygments first - "sudo pip install Pygments"
if [ -x "`which pygmentize`" ]; then
    alias c='pygmentize -O style=monokai -f console256 -g'
else
    echo "${RED}ERROR: ${RESET}Pygments is not installed, aliases will not work"
fi

# Git 
# You must install Git first
if [ -x "`which git`" ]; then
    alias gs='git status'
    alias ga='git add .'
    alias gc='git commit -m' # requires you to type a commit message
    alias gp='git push'
    alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'
else
    echo "${RED}ERROR: ${RESET}Git is not installed, aliases will not work"
fi

alias dotfiles_update='. ~/.bash_profile'

alias pgrep='pgrep -f'
# ----- END ALIASES -----

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

# ---- BEGIN GIT ----
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
PS1_GIT="\[$YELLOW\]\u$SSH \[$WHITE\]in \[$BOLD\]\[$BLUE\]\w\[$RESET\]\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"[\")\[$GREEN\]\$(parse_git_branch)\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"]\")\n$symbol\[$RESET\]"

# ----- END GIT -----

# ---- BEGIN PROMPT ----
# Add host to PS1 if connection by ssh
SSH=""
if [ "$SSH_CONNECTION" ]; then
    SSH="@\h"
fi

# Change this symbol to something sweet. 
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="\$ "
#⚡→➜

PS1_NO_GIT="\[$YELLOW\]\u$SSH \[$WHITE\]in \[$BOLD\]\[$BLUE\]\w\[$RESET\]\[$WHITE\]\n$symbol\[$RESET\]"

export PS1=$PS1_NO_GIT
export PS2="\[$ORANGE\]➜ \[$RESET\]"

# Only show the current directory's name in the tab 
export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'
# ----- END PROMPT -----

# init z! (https://github.com/rupa/z)
# A cd history
if [ -x ~/z.sh ]; then
    . ~/z.sh
fi
if [ -f ~/.dotfiles_config ]; then
    source ~/.dotfiles_config
fi

DOTFILES_MY_FLAGS="-Fh"

if $_is_linux; then
    source ~/.bash_profile_linux
elif $_is_mac; then
    source ~/.bash_profile_mac
fi

# ---- BEGIN PYTHON ----

# pyenv
if [ -x "${HOME}/.pyenv/bin/pyenv" ]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    if [ -d "${PYENV_ROOT}" ]; then
        export PATH="${PYENV_ROOT}/bin:${PATH}"
        eval "$(pyenv init -)"
    fi
fi
# ----- END PYTHON -----

# ----- BEGIN RUBY -----
if [ -x "${HOME}/.rbenv/bin/rbenv" ]; then
    export RBENV_ROOT="${HOME}/.rbenv"
    if [ -d "${RBENV_ROOT}" ]; then
        export PATH="${RBENV_ROOT}/bin:${PATH}"
        eval "$(rbenv init -)"
    fi
fi
# ------ END RUBY ------

# ---- BEGIN ALIASES ----

alias realpath='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(path)"'
alias realdirname='python -c "import os,sys; path=(sys.argv[1] if len(sys.argv)>1 else \".\"); print os.path.realpath(os.path.dirname(path))"'
alias ls="command ls ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}"
alias lsa="ls -A ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}"
alias ll="ls -l ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}" # all files, in long format
alias lla="ll -A ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS}" # all files inc dotfiles, in long format
alias lld='ll ${DOTFILES_COLOR_FLAG} ${DOTFILES_MY_FLAGS} | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->" --color=NEVER'
alias grep='grep --color'
alias sudo='sudo ' # Allow sudo other aliases

# You must install Pygments first - "sudo pip install Pygments"
if [ -x "`which pygmentize`" ]; then
    alias c='pygmentize -O style=monokai -f console256 -g'
else
    echo "${RED}ERROR: ${RESET}Pygments is not installed, aliases not installed"
fi

# Git
# You must install Git first
if [ -x "`which git`" ]; then
    alias gs='git status'
    alias ga='git add -i'
    alias gc='git commit -m' # requires you to type a commit message
    alias gp='git push'
    alias gd="git diff"
    alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'
else
    echo "${RED}ERROR: ${RESET}Git is not installed, aliases not installed"
fi

alias dotfiles_update='echo ''Deprecated. Use update_dotfiles.''; source ~/.bash_profile'
alias update_dotfiles='source ~/.bash_profile'

alias pgrep='pgrep -f'
alias pkill='pkill -f'

# ----- END ALIASES -----

# ---- BEGIN BINDINGS ----

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# ----- END BINDINGS -----

# ---- BEGIN VARIABLES ----

_EDITOR="atom"

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
# Only show the current directory's name in the tab
function _update_ps1() {
    export PS1="$(~/powerline-shell.py $? 2> /dev/null)"
}

export PROMPT_COMMAND='_update_ps1; echo -ne "\033]0; ${PWD##*/}\007"; $PROMPT_COMMAND'
# ----- END PROMPT -----

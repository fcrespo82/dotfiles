if [[ $(uname -a) =~ [Ll]inux ]]; then
    _is_linux=true
    _is_mac=false
elif [[ $(uname -a) =~ [Dd]arwin ]]; then
    _is_mac=true
    _is_linux=false
else
    echo "Cannot determine what SO you are running"
fi

function linux_specific() {
    alias s='subl -a '
    alias restart_unity_1='setsid unity'
    alias restart_lightdm_2='sudo service lightdm restart'
    alias o='gnome-open'
    color_flag="--color"
    export LS_COLORS="di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=01;00:sg=01;00;41:tw=01;00;46:ow=01;00;42:"

    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
}

function mac_specific() {
    alias s='open -a "Sublime Text"'
    color_flag="-G"
    export LSCOLORS="ExGxFxDxCxDxDxxxxbxgxc"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
}

function common() {

    alias realpath='python -c "import os,sys; print os.path.realpath(sys.argv[1])"'
    alias realdirname='python -c "import os,sys; print os.path.realpath(os.path.dirname(sys.argv[1])"'

    # Load external configuration
    source ~/.dotfiles_config

    my_flags="-Fh"

    if $_is_linux; then
        linux_specific
    elif $_is_mac; then
        mac_specific
    fi

    alias ls="command ls ${color_flag} ${my_flags}"
    alias lsa="ls -a ${color_flag} ${my_flags}"
    alias ll="ls -l ${color_flag} ${my_flags}" # all files, in long format
    alias lla="ll -a ${color_flag} ${my_flags}" # all files inc dotfiles, in long format
    alias lld='ll ${color_flag} ${my_flags} | grep "/$"' # only directories
    alias lls='lla | cut -c -11,50- | grep "\->"'
    alias grep='grep --color'

    alias scripts="cd ~/developer/scripts"
    alias sudo='sudo '
    # You must install Pygments first - "sudo pip install Pygments"
    alias c='pygmentize -O style=monokai -f console256 -g'

    # Git 
    # You must install Git first
    alias gs='git status'
    alias ga='git add .'
    alias gc='git commit -m' # requires you to type a commit message
    alias gp='git push'
    alias grmall='gs | grep deleted | cut -c 15- | xargs -i* git rm "*"'

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

    # Add host to PS1 if connection by ssh
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

    # Only show the current directory's name in the tab 
    export PROMPT_COMMAND='echo -ne "\033]0; ${PWD##*/}\007"'

    # init z! (https://github.com/rupa/z)
    . ~/z.sh

    # Instalacao das Funcoes ZZ (www.funcoeszz.net)
    #export ZZOFF=""  # desligue funcoes indesejadas
    #export ZZPATH="$DOTFILES_PATH/funcoeszz/funcoeszz"  # script
    #export ZZDIR="$DOTFILES_PATH/funcoeszz/zz"  # script
    #source "$ZZPATH"
}

common
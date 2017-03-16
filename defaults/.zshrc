# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.zplug/init.zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load


. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash


alias sudo='sudo ' # Allow sudo other aliases
alias watch='watch ' # Allow watch other aliases

alias grep='grep --color'

LS_COLOR_FLAG="-G"
LS_CUSTOM_FLAGS="-Fh"

alias ls='ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}'
alias l='ls'
alias lsa='ls -A'
alias ll='ls -l' # all files, in long format
alias lla='ll -A' # all files inc dotfiles, in long format
alias lld='ll | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->"'
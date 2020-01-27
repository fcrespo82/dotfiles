source $HOME/.dotfiles_dir
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

source $DOTFILES_DIR/functions
source $DOTFILES_DIR/utils

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="mortalscumbag"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  asdf
  docker
  encode64
  node
  npm
  sudo
  urltools
  jsontools
  vscode
  extract
  colorize
  catimg
  fast-syntax-highlighting
  osx
  swiftpm
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

setopt histignorealldups

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

alias sudo='sudo ' # Allow sudo other aliases
alias watch='watch ' # Allow watch other aliases

alias grep='grep --color'

case $(uname -s) in
    Linux)
        LS_COLOR_FLAG="--color"
        LS_CUSTOM_FLAGS="-Fh"
        ;;
    Darwin)
        LS_COLOR_FLAG="-G"
        LS_CUSTOM_FLAGS="-FhN"
        ;;
esac

# export LS_COLORS="di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=01;00:sg=01;00;41:tw=01;00;46:ow=01;00;42:"

alias ls='ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}'
alias l='ls'
alias lsa='ls -A'
alias ll='ls -l' # all files, in long format
alias lla='ll -A' # all files inc dotfiles, in long format
alias lld='ll | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->"'
alias today='cal -h | egrep -C 4 "\b$(date +%-d)\b" --color'

alias untar='tar -vxf' # Extract files
alias untar-bz2='tar -vxjf' # Extract bz2 files
alias untar-gzip='tar -vxzf' # Extract gzip files
alias tar-bz2='tar -vcjf' # Create bz2 files
alias tar-gzip='tar -vczf' # Create gzip files

alias pkill='pkill -f'

if [ -f $HOME/.asdf/asdf.sh ]; then
    source $HOME/.asdf/asdf.sh
    source $HOME/.asdf/completions/asdf.bash
fi

export EDITOR="code -w"

# Replace macos coreutils with gnu versions
case $(uname -s) in
    Darwin)
        if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
            export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
            # Override default flag for macOS since we have gnu coreutils in PATH
            LS_COLOR_FLAG="--color"
            alias ls='ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}'
        fi
        if [ -d /usr/local/opt/gnu-sed/libexec/gnubin ]; then
            export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
        fi
        ;;
esac

if [ -d /usr/local/opt/e2fsprogs ]; then
    export PATH="/usr/local/opt/e2fsprogs/bin:$PATH"
    export PATH="/usr/local/opt/e2fsprogs/sbin:$PATH"
fi

# Put local bin in path
if [ -d /usr/local/bin ]; then
    export PATH="/usr/local/bin:$PATH"
fi
if [ -d /usr/local/sbin ]; then
    export PATH="/usr/local/sbin:$PATH"
fi

source $DOTFILES_DIR/env

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

jdk 11

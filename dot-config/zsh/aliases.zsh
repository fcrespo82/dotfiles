[[ ! -z ${DEBUG+x} ]] && echo "Setting custom aliases"

alias grep="grep --color"
if type exa > /dev/null; then 
  # exa is installed
  alias ls="exa --icons -g"
else
  alias ls="ls -g"
fi
alias la="ls -a"
alias ll="ls -lg"
alias lla="ls -alg"
alias ls1="ls -1"
if type bat > /dev/null; then 
  # bat is installed
  alias cat="bat --style=auto"
fi
if type nvim > /dev/null; then 
  # nvim is installed
  alias vim="nvim"
fi

alias yt-dlp-mp4="yt-dlp -S res,ext:mp4:m4a --recode mp4"

alias debug="exec env DEBUG=1 zsh"

# Windows aliases
if [[ ! -z ${IS_WSL+x} ]]; then
  alias restartexplorer="taskkill.exe /f /im explorer.exe; explorer.exe &"
  alias explorer="explorer.exe"
  alias winget="winget.exe"
  alias wsl="wsl.exe"
  alias taskkill="taskkill.exe"
  alias nslookup="nslookup.exe"
fi

# yay fzf aliases
# alias yays="yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S"
yays() {
  if [[ -z $1 ]]; then
    yay -Slq | fzf --multi --preview-window up:70% --preview 'yay -Si {1}' | xargs -ro yay -S
  else
    yay -Slq | fzf --multi --preview-window up:70% --preview 'yay -Si {1}' -q $1 | xargs -ro yay -S
  fi
}
alias yayrm="yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns"

alias rm="echo 'Use trash' or, if you really want rm use rrm"
alias trash="trash -v"
alias rrm="command rm"
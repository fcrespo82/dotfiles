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
alias restartexplorer="taskkill.exe /f /im explorer.exe; explorer.exe &"
alias debug="exec env DEBUG=1 zsh"

# Windows aliases
alias explorer="explorer.exe"
alias winget="winget.exe"
alias wsl="wsl.exe"
alias taskkill="taskkill.exe"
alias nslookup="nslookup.exe"
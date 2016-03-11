alias sudo='sudo ' # Allow sudo other aliases
alias watch='watch ' # Allow watch other aliases

alias grep='grep --color'

alias ls='ls ${LS_COLOR_FLAG} ${LS_CUSTOM_FLAGS}'
alias l='ls'
alias lsa='ls -A'
alias ll='ls -l' # all files, in long format
alias lla='ll -A' # all files inc dotfiles, in long format
alias lld='ll | grep "/$"' # only directories
alias lls='echo "Symbolic Links:"; lla | cut -d":"  -f 2 | cut -c 4- | grep "\->" --color=NEVER'

alias untar='tar -vxf' # Extract files
alias untar-bz2='tar -vxjf' # Extract bz2 files
alias untar-gzip='tar -vxzf' # Extract gzip files
alias tar-bz2='tar -vcjf' # Create bz2 files
alias tar-gzip='tar -vczf' # Create gzip files


alias pkill='pkill -f'


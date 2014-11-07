if [[ $PATH != *$DOTFILES_ROOT/bin/linux* ]]; then
    export PATH=$PATH:$DOTFILES_ROOT/bin/linux
fi

LS_COLOR_FLAG="--color"

export LS_COLORS="di=01;34:ln=01;36:so=01;35:pi=01;33:ex=01;32:bd=01;33:cd=01;33:su=01;00:sg=01;00;41:tw=01;00;46:ow=01;00;42:"

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias restart_unity_1='setsid unity'
alias restart_lightdm_2='sudo service lightdm restart'
alias o='gnome-open'

alias ssh-nas='ssh -p 3456 root@nas.crespo.in'
alias ssh-mac='ssh -p 6080 fernando@nas.crespo.in'

# ---- BEGIN FUNCTIONS ----
function count() {
    TEMP=`getopt -o ah -- "$@"`
    eval set -- "$TEMP"
    while true; do
        case "$1" in
            -a) ls -A1 | wc -l | sed "s/ //g"; shift; break ;;
            -h) echo -e "Usage:\n\tcount   \tCount files in a folder (except hidden)\n\tcount -a\tCount files in a folder including hidden"; shift; break ;;
            --) ls -1 | wc -l | sed "s/ //g"; shift; break ;; # Got to the end without findind any flag
            *) echo "Internal error!" ; exit 1 ;;
        esac
    done
}

# ----- END FUNCTIONS -----
if [ -x "`which xclip`" ]; then
    alias pbcopy='xclip -i -selection clipboard'
    alias pbpaste='xclip -o -selection clipboard'
else
    echo "${RED}ERROR:${RESET} xclip bindinds to mac equivalents are not going to work"
fi

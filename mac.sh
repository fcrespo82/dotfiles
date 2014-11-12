export HOMEBREW_GITHUB_API_TOKEN=db4aed845b07b95a197a1df34eafc851c448dc40

if [[ $PATH != *$DOTFILES_ROOT/bin/mac* ]]; then
    export PATH=$PATH:$DOTFILES_ROOT/bin/mac
fi

LS_COLOR_FLAG="-G"

export LSCOLORS="ExGxFxDxCxDxDxxxxbxgxc"

if [ -e "$(which brew)" ]; then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
else
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi

alias ssh-nas='ssh -p 22 root@diskstation.local'
alias ssh-alesp='ssh -p 1234 fernando@localhost'

# Quick way to rebuild the Launch Services database and get rid
# of duplicates in the Open With submenu.
alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'

# ---- BEGIN FUNCTIONS ----
function count() {
    # gnugetopt installed by homebrew
    if [[ -x $(which gnugetopt) ]]; then
        TEMP=$(gnugetopt -o ah -- "$@")
    else
        TEMP=$(getopt ah $*)
    fi

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

# cd to the path of the front Finder window
function cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}
# ----- END FUNCTIONS -----

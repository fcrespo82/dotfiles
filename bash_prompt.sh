export HOST_COLOR="\[\033[32m\]"
export USER_COLOR="\[\033[34m\]"
export ROOT_USER_COLOR="\[\033[31m\]"
export PATH_COLOR="\[\033[1;34m\]"
export GIT_COLOR="\[\033[32m\]"
export STATS_COLOR="\[\033[m\]"
export RESET="\[\033[0m\]"

function _user {
    COLOR=$USER_COLOR
    if [ "$EUID" -eq 0 ]; then
        COLOR=$ROOT_USER_COLOR
    fi
    echo "(${COLOR}\u${RESET}`_remote`)"
}

function _is_root {
    COLOR=$RESET
    if [ "$EUID" -eq 0 ]; then
        COLOR=$ROOT_USER_COLOR
    fi
    echo "${COLOR}\\\$${RESET}"
}

function _remote {
    if [ "$SSH_CLIENT" != "" ]; then
        # ??
        echo -e " \U1f510 `echo $SSH_CLIENT | cut -d" " -f 1`"
    fi
}

# get current branch in git repo
function _parse_git_branch {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`_parse_git_dirty`
		echo "-(${GIT_COLOR}${BRANCH}${RESET}${STATS_COLOR}${STAT})"
	else
		echo ""
	fi
}

# get current status of git repo
function _parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
        #bits="\uA71B${bits}" ?
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
        #bits="\u2421${bits}" ?
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo -e " ${bits}"
	else
		echo ""
	fi
}

function nonzero_return {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "$RETVAL"
}

function path {
    pwd_length=10
    pwd_symbol="..."
    newPWD="${PWD/$HOME/~}"
    if [ $(echo -n $newPWD | wc -c | tr -d " ") -gt $pwd_length ]; then
        newPWD=$(echo -n $newPWD | awk -F '/' '{
        print $1 "/" $2 "/${pwd_symbol}/" $(NF-1) "/" $(NF)}')
    fi
    echo -e "${newPWD}"
}

function _update_ps1() {
    # -(${HOST_COLOR}\h${RESET})
    #export PS1="\n`echo -e \"\u250c\"``_user`-(${PATH_COLOR}$(basename $(pwd))${RESET})`_parse_git_branch`\n`echo -e \"\u2514\"``_is_root` "
    export PS1="\n`_user`" # User
    export PS1=$PS1"-(${PATH_COLOR}\W${RESET})" # Path
    export PS1=$PS1"`_parse_git_branch`" # Git status
    export PS1=$PS1"\n`_is_root` " # User/Root prompt
}
export PROMPT_COMMAND='_update_ps1'
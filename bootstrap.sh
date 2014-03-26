#!/usr/bin/env bash

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
    #echo "linux_specific"
    FILES=('.bashrc' '.bash_profile' '.bash_profile_linux' '.gitconfig' 'z.sh' '.hushlogin' '.vimrc')
}

function mac_specific() {
    #echo "mac_specific"
    FILES=('.bashrc' '.bash_profile' '.bash_profile_mac' '.gitconfig' 'z.sh' '.hushlogin' '.vimrc')
}

BLACK=$(tput setaf 0)
MAGENTA=$(tput setaf 9)
ORANGE=$(tput setaf 172)
GREEN=$(tput setaf 10)
PURPLE=$(tput setaf 141)
WHITE=$(tput setaf 15)
RED=$(tput setaf 9)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 11)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Set all variables that will be used
FULL_SCRIPT_DIR=$(python -c 'import os,sys; print os.path.realpath(os.path.dirname(sys.argv[1]))' $BASH_SOURCE)

if $_is_linux; then
    linux_specific
elif $_is_mac; then
    mac_specific
fi

function debug() {
    echo -e "FULL_SCRIPT_DIR    $FULL_SCRIPT_DIR"
    echo -e "IS_LINUX           $_is_linux"
    echo -e "IS_MAC             $_is_mac"
    echo -e "Files that will be linked:\n`for FILE in ${FILES[@]}; do echo -e "  $HOME/$FILE -> $FULL_SCRIPT_DIR/$FILE"; done`"
    echo -e "Source files       $FULL_SCRIPT_DIR"
    echo -e "Home dir           $HOME"
}

function usage() {
    echo "
usage ${GREEN} `basename $0` ${RESET}-iurth"
    echo -e "
Options:
-i     Install dotfiles
-u     Update dotfiles
-r     Removes dotfiles restoring your backups (if they exist)
-t     Test/Debug the info passed to make sure is correct
-h     This help
"
}

function install() {
    if [ ! "$1" == "update" ]; then
        # Verify if is installed and exit if it is
        for FILE in ${FILES[@]}; do
            if [ -h ~/"${FILE}" ]; then
                echo "${RED}Symlinks (${FILE}) ALREADY installed, aborting.${RESET}
If you want to update your installation run with -u flag"
                exit 1
            fi
        done

        # Back up files
        cd
        for FILE in ${FILES[@]}; do
            if [ -f ~/"${FILE}" ]; then
                echo ${GREEN}"Backing up $FILE"
                BACKUP_NAME="${FILE}_backup"
                mv "${FILE}" "${BACKUP_NAME}"
            fi
        done
    fi

    echo "${YELLOW}Creating symlinks${RESET}"
    for FILE in ${FILES[@]}; do
        echo "$HOME/$FILE ${BLUE}->${RESET} $FULL_SCRIPT_DIR/$FILE"
        ln -fs "$FULL_SCRIPT_DIR/$FILE" "$HOME/$FILE"
    done

    if [ -f "$HOME"/.dotfiles_config ]; then
        echo "${YELLOW}Installing .dotfiles_config"
        FILE="DOTFILES_PATH=\"$FULL_SCRIPT_DIR\"\n
\n
# Enable git information on command line by default\n
# to disable set it to 0\n
# GIT_PS1_ENABLED_BY_DEFAULT=0\n"
        echo -e $FILE > "$HOME"/.dotfiles_config
    fi

    echo "${GREEN}Installation finished.${RESET}
run ${BLUE}'source ~/.bash_profile'${RESET} or open another terminal to see the changes
if you are updating an existing installation you can run ${BLUE}'dotfiles_update'${RESET}"
}

function remove() {
    cd
    for FILE in ${FILES[@]}; do
        if [ -h ~/"${FILE}" ]; then
            echo "${RED}Removing symlink to $FILE${RESET}"
            rm -f ~/"${FILE}"
        fi
        for FILE in ${FILES[@]}; do
            if [ -h ~/"${FILE}"_backup ]; then
                echo "${GREEN}Restoring backup of $FILE"
                mv "${FILE}"_backup "${FILE}"
            fi
        done
        PS3="Do you want to delete your config file? "
        options=("Yes" "No")
        select opt in "${options[@]}"
        do
            case $opt in
                ("Yes") rm -f "${HOME}"/.dotfiles_config; break ;;
                ("No") echo "${GREEN}Your config is under ${HOME}/.dotfiles_config${RESET}"; break ;;
                (*) echo invalid option ;;
            esac
        done
    done
    echo "${GREEN}Removal completed.${RESET}
Open another terminal to see the changes"
}

function ask_remove() {
    cd
    for FILE in ${FILES[@]}; do
        if [ -f ~/"${FILE}"_backup ]; then
            echo "${RED}COULD NOT${RESET} find your backups"
            BACKUP_NOT_FOUND=true
            break
        fi
    done
    if $BACKUP_NOT_FOUND; then
        PS3="Restore anyway? "
        options=("Yes" "No")
        select opt in "${options[@]}"
        do
            case $opt in
                ("Yes") remove; exit 1 ;;
                ("No") echo "${GREEN}Not touching anything${RESET}"; exit 1 ;;
                (*) echo invalid option;;
            esac
        done
    else
        remove
    fi
}

getopts hrtiu OPT "$@"

if [ $? != 0 ] || [ $# == 0 ]; then usage; exit 2; fi

eval set -- "$OPT"

for opt
do
    case "$opt"
    in
        (-i|i) install; exit 0 ;;
        (-u|u) install "update"; exit 0 ;;
        (-r|r) ask_remove; exit 0 ;;
        (-t|t) debug; exit 0 ;;
        (-h|h) usage; exit 0 ;;
        (--) shift; break ;;
    esac
done
#!/usr/bin/env bash

if [[ $(uname -a) == *"inux"* ]]; then
    _is_linux=true
    _is_mac=false
else #if [[ $(uname -a) == *"arwin"* ]]; then
    _is_mac=true
    _is_linux=false
fi

function linux_specific() {
    echo "linux_specific"
}

function mac_specific() {
    echo "mac_specific"
}

function common() {
    # Set all variables that will be used
    FULL_SCRIPT_DIR=$(python -c 'import os,sys; print os.path.realpath(os.path.dirname(sys.argv[1]))' $BASH_SOURCE)

    FILES=('.bashrc' '.bash_profile' '.gitconfig' 'z.sh' '.hushlogin' '.vimrc')

    if $_is_linux; then
        linux_specific
    elif $_is_mac; then
        mac_specific
    fi
}

common

# Set used colors in bash
GREEN=$(tput setaf 10)
RED=$(tput setaf 9)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 11)
BOLD=$(tput bold)
RESET=$(tput sgr0)

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
usage ${GREEN} `basename $0` ${RESET}-irth"
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
        for FILE in ${FILES[@]}; do
            if [ -h "$FILE" ]; then
                echo "${RED}Symlinks ALREADY installed, aborting.${RESET}
If you want to update your installation run with -u flag"
                exit 1
            fi
        done

        cd
        for FILE in ${FILES[@]}; do
            if [ -f "$FILE" ]; then
                echo ${GREEN}"Backing up $FILE"
                BACKUP_NAME="$FILE"_backup
                mv "$FILE" "$BACKUP_NAME"
            fi
        done
    fi

    echo "${YELLOW}Creating symlinks${RESET}"
    for FILE in ${FILES[@]}; do
        echo "$HOME/$FILE ${BLUE}->${RESET} $FULL_SCRIPT_DIR/$FILE"
        ln -fs "$FULL_SCRIPT_DIR/$FILE" "$HOME/$FILE"
    done

    echo "${YELLOW}Installing .dotfiles_config"
    echo "DOTFILES_PATH=\"$FULL_SCRIPT_DIR\"" > "$HOME"/.dotfiles_config

    echo "${GREEN}Installation finished.${RESET}
run ${BLUE}'source ~/.bash_profile'${RESET} or open another terminal to see the changes
if you are updating an existing installation you can run ${BLUE}'dotfiles_update'${RESET}"
}

function remove() {
    cd
    for FILE in ${FILES[@]}; do
        if [ -h "$FILE" ]; then
            echo "${RED}Removing symlink to $FILE${RESET}"
            rm -f "$FILE"
        fi
        for FILE in ${FILES[@]}; do
            if [ -h "$FILE"_backup ]; then
                echo "${GREEN}Restoring backup of $FILE"
                mv "$FILE"_backup "$FILE"
            fi
        done
        rm -f ~/.dotfiles_config
    done
    echo "${GREEN}Removal completed.${RESET}
Open another terminal to see the changes"
}

function remove() {
    cd
        for FILE in ${FILES[@]}; do
            if [ -f "$FILE"_backup ]; then
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
        (-r|r) remove; exit 0 ;;
        (-t|t) debug; exit 0 ;;
        (-h|h) usage; exit 0 ;;
        (--) shift; break ;;
    esac
done
#!/usr/bin/env bash

# Set all variables that will be used
SCRIPT_DIR=`dirname $BASH_SOURCE`
if [ $SCRIPT_DIR == "." ]; then
    GET_DIR_TOOL="get_dirname"
else
    GET_DIR_TOOL="get_realpath"
fi
REALPATH_DIR=$SCRIPT_DIR/lib/realpath/realpath-lib
source $REALPATH_DIR 
FILES=('.bashrc' '.bash_profile' '.gitconfig' 'z.sh' '.hushlogin')
FULL_SCRIPT_PATH=`$GET_DIR_TOOL $SCRIPT_DIR`

function set_os() {
    if [[ $(uname -a) == *"inux"* ]]; then
        IS_LINUX=true
        IS_MAC=false
    else #if [[ $(uname -a) == *"arwin"* ]]; then
        IS_MAC=true
        IS_LINUX=false
    fi
}
set_os

function debug() {
    echo -e "SCRIPT_DIR         $SCRIPT_DIR"
    echo -e "REALPATH_DIR       $REALPATH_DIR"
    echo -e "IS_LINUX           $IS_LINUX"
    echo -e "IS_MAC             $IS_MAC"
    echo -e "Files that will be linked:\n`for FILE in ${FILES[@]}; do echo -e "  $HOME/$FILE -> $FULL_SCRIPT_PATH/$FILE"; done`"
    echo -e "Source files       $FULL_SCRIPT_PATH"
    echo -e "Home dir           $HOME"
}

# Set used colors in bash
GREEN=$(tput setaf 10)
RED=$(tput setaf 9)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 11)
BOLD=$(tput bold)
RESET=$(tput sgr0)

function usage() {
    echo "
usage ${GREEN} `basename $0` ${RESET}-irth"
    echo -e "
Options:
-i     Install dotfiles
-r     Removes dotfiles restoring your backups (if they exist)
-t     Test/Debug the info passed to make sure is correct
-h     This help
"
}

function install() {
    for FILE in ${FILES[@]}; do
        if [ -h $FILE ]; then
            echo "${RED}Symlinks ALREADY installed, aborting"
            exit 1
        fi
    done

    cd
    for FILE in ${FILES[@]}; do
        if [ -f $FILE ]; then
            echo ${GREEN}"Backing up $FILE"
            BACKUP_NAME="$FILE"_backup
            mv "$FILE" "$BACKUP_NAME"
        fi
    done

    echo ${YELLOW}"Creating symlinks${RESET}"
    for FILE in ${FILES[@]}; do
        echo "$HOME/$FILE -> "$FULL_SCRIPT_PATH/$FILE""
    done

    for FILE in ${FILES[@]}; do
        ln -s "$FULL_SCRIPT_PATH/$FILE" $FILE
    done

    echo "DOTFILES_PATH=\"$FULL_SCRIPT_PATH\"" > .dotfiles_config

    echo "${GREEN}Installation finished.${RESET}
run 'source ~/.bash_profile' or open another terminal to see the changes"
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

function rollback() {
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

getopts hrti TEMP "$@"

if [ $? != 0 ] || [ $# == 0 ]; then usage; exit 2; fi

eval set -- "$TEMP"

for opt
do
    case "$opt"
    in
        (-i|i)
            if [ -d $2 ]; then
                install
                shift; shift
            fi
            ;;
        (-h|h) usage; exit 1 ;;
        (-r|r) rollback; exit 1 ;;
        (-t|t) debug; exit 1 ;;
        (--) echo "shift"; shift; break ;;
    esac
done
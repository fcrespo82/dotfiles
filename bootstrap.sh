#! /usr/bin/env bash

SCRIPT_DIR=`dirname $BASH_SOURCE`
REALPATH_DIR=$SCRIPT_DIR/lib/realpath/realpath-lib
source $REALPATH_DIR

FILES=('.bashrc' '.bash_profile' '.gitconfig' 'z.sh')



function set_os() {
    if [[ $(uname -a) == *"inux"* ]]; then
        IS_LINUX=true
        IS_MAC=false
    elif [[ $(uname -a) == *"arwin"* ]]; then
        IS_MAC=true
        IS_LINUX=false
    fi
}
set_os

function debug() {
    echo -e "SCRIPT_DIR      $SCRIPT_DIR"
    echo -e "REALPATH_DIR    $REALPATH_DIR"
    echo -e "IS_LINUX        $IS_LINUX"
    echo -e "IS_MAC          $IS_MAC"
    echo -e "Files that will be linked:\n`for FILE in ${FILES[@]}; do echo -e "  $FILE"; done`"
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
usage ${GREEN} `basename $0` ${RESET}-d [folder_with_dofiles]"
    echo -e "
Options:
-d\tInstall dotfiles in this dir (acctually creates symlinks)
-r\tRemoves the symlinks restoring your backups (if they exist)
-z\tDebug the info passed to make sure is correct use with -d [folder]
\tEx.: ${GREEN} `basename $0` ${RESET}-zd [folder_with_dofiles]
-h\tThis help
"

}

function install() {
    if [ -h .bash_profile ] && [ -h .bashrc ] && [ -h .gitconfig ]; then
        echo "${RED}Symlinks ALREADY installed, aborting"
        exit 1
    fi
    cd
    if [ -f .bash_profile ]; then
        echo ${GREEN}"Backing up your .bash_profile"
        mv .bash_profile .bash_profile_backup
    fi
    if [ -f .bashrc ]; then
        echo ${GREEN}"Backing up your .bashrc"
        mv .bashrc .bashrc_backup
    fi
    if [ -f .gitconfig ]; then
        echo ${GREEN}"Backing up your .gitconfig"
        mv .gitconfig .gitconfig_backup
    fi
    if [ -f z.sh ]; then
        echo ${GREEN}"Backing up your z.sh"
        mv z.sh z.sh_backup
    fi

    echo ${YELLOW}"Creating symlinks${RESET}
`pwd`/.bash_profile -> $1/.bash_profile
`pwd`/.bashrc -> $1/.bashrc
`pwd`/.gitconfig -> $1/.gitconfig
`pwd`/z.sh -> $1/z.sh"
    ln -s "$1/.bash_profile" .bash_profile
    ln -s "$1/.bashrc" .bashrc
    ln -s "$1/.gitconfig" .gitconfig
    ln -s "$1/z.sh" z.sh

    echo "${GREEN}Installation finished.${RESET}
run 'source .bash_profile' or open another terminal to see the changes"
}

function remove() {
    if [ -h .bash_profile ] && [ -h .bashrc ] && [ -h .gitconfig ] && [ -h z.sh ]; then
        echo "${RED}Removing symlinks${RESET}"
        rm -f .bash_profile .bashrc .gitconfig z.sh
        if [ -f .bash_profile_backup ] && [ -f .bashrc_backup ] && [ -f .gitconfig_backup ] && [ -f z.sh ]; then
            echo "${GREEN}Restoring your backups"
            mv .bash_profile_backup .bash_profile
            mv .bashrc_backup .bashrc
            mv .gitconfig_backup .gitconfig
            mv z.sh_backup z.sh
        else
            echo "Your backups where ${RED}NOT${RESET} restored"
        fi
    else
        echo "The files in home ${RED}ARE NOT${RESET} symlinks, aborting"
    fi
    echo "${GREEN}Removal completed.${RESET}
run 'exec bash' or open another terminal to see the changes"
}

function rollback() {
    cd
    if [ ! -f .bash_profile_backup ] && [ ! -f .bashrc_backup ] && [ ! -f .gitconfig_backup ] && [ ! -f z.sh ]; then
        echo "${RED}COULD NOT${RESET} find your backups"
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

#if $IS_LINUX; then
#    TEMP=`getopt -o hrzd: --long help,remove,dir: -- "$@"`
#elif $IS_MAC; then
    getopts hrzd: TEMP "$@"
#fi

if [ $? != 0 ] || [ $# == 0 ]; then usage; exit 2; fi

eval set -- "$TEMP"

for i
do
    case "$i"
    in
        (-d|d)
            if [ -d $2 ]; then
                path=`get_dirname $OPTARG`
                install $path
                shift; shift
            fi
            ;;
        (-h|h) usage; exit 1 ;;
        (-r|r) rollback; exit 1 ;;
        (-z|z) debug; exit 1 ;;
        (--) echo "shift"; shift; break ;;
    esac
done
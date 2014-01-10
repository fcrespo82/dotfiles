#! /usr/bin/env bash

function set_os() {
    if [[ $(uname -a) == *"inux"* ]]; then
        is_linux=true
        is_mac=false
    elif [[ $(uname -a) == *"arwin"* ]]; then
        is_mac=true
        is_linux=false
    fi
}
set_os

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
-h\tThis help
"

}

function install() {
    if [ -h .bash_profile ] && [ -h .bashrc ]; then
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

    echo ${YELLOW}"Creating symlinks${RESET}
`pwd`/.bash_profile -> $1/.bash_profile
`pwd`/.bashrc -> $1/.bashrc"
    ln -s "$1/.bash_profile" .bash_profile
    ln -s "$1/.bashrc" .bashrc

    echo "${GREEN}Installation finished.${RESET}
run 'source .bash_profile' or open another terminal to see the changes"
}

function remove() {
    if [ -h .bash_profile ] && [ -h .bashrc ]; then
        echo "${RED}Removing symlinks .bash_profile and .bashrc${RESET}"
        rm -f .bash_profile .bashrc
        if [ -f .bash_profile_backup ] && [ -f .bashrc_backup ]; then
            echo "${GREEN}Restoring your backups"
            mv .bash_profile_backup .bash_profile
            mv .bashrc_backup .bashrc
        else
            echo "Your backups where ${RED}NOT${RESET} restored"
        fi
    else
        echo "The files .bash_profile and .bashrc ${RED}ARE NOT${RESET} symlinks, aborting"
    fi
    echo "${GREEN}Removal completed.${RESET}
run 'exec bash' or open another terminal to see the changes"
}

function rollback() {
    cd
    if [ ! -f .bash_profile_backup ] && [  ! -f .bashrc_backup ]; then
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

if $is_mac; then
    function realpath() {
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" | sed -e "s/\/\/$//" -e "s/\/$//"
    }
fi

if $is_linux; then
    TEMP=`getopt -o hrd: --long help,remove,dir: -- "$@"`
elif $is_mac; then
    getopts hrd: TEMP "$@"
fi

if [ $? != 0 ] || [ $# == 0 ]; then usage; exit 2; fi

eval set -- "$TEMP"

for i
do
    case "$i"
    in
        (-d|d)
            if [ -d $2 ]; then
                if $is_mac; then
                    path=`realpath $OPTARG`
                else
                    path=`realpath $2`
                fi
                install $path
                shift; shift
            fi
            ;;
        (-h|h) usage; exit 1 ;;
        (-r|r) rollback; exit 1 ;;
        (--) echo "shift"; shift; break ;;
    esac
done
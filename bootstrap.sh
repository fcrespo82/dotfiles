#! /usr/bin/env bash

GREEN=$(tput setaf 10)
RED=$(tput setaf 9)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 11)
BOLD=$(tput bold)
RESET=$(tput sgr0)

function usage() {
    echo "
usage ${GREEN} `basename $0` ${RESET}-d|--dir [folder_with_dofiles]"
    echo -e "
Options:
-d|--dir\tInstall dotfiles in this dir (acctually creates symlinks)
-r|--remove\tRemoves the symlinks restoring your backups (if they exist)
-h|--help\tThis help
"

}

function install() {
    if [ -h .bash_profile ] && [ -h .bashrc ]; then
        echo "${RED}Symlinks ALREADY installed, exiting"
        exit 1
    fi
    cd
    if [ -f .bash_profile ]; then
        #echo "mv .bash_profile .bash_profile_backup"
        echo ${GREEN}"Backing up your .bash_profile"
        mv .bash_profile .bash_profile_backup
    fi
    if [ -f .bashrc ]; then
        #echo "mv .bashrc .bashrc_backup"
        echo ${GREEN}"Backing up your .bashrc"
        mv .bashrc .bashrc_backup
    fi

    #echo "$1.bash_profile" .bash_profile
    #echo "$1.bashrc" .bashrc
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
                "Yes")
                    remove
                    exit 1
                    ;;
                "No")
                    echo "${GREEN}Not touching anything${RESET}"
                    exit 1
                    ;;
                *) echo invalid option;;
            esac
        done
    else
        remove
    fi
}

TEMP=`getopt -o hrd: --long help,remove,dir: -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -d|--dir)
            if [ -d $2 ]; then
                path=`realpath $2`
                install $path
                shift 2
            fi
            ;;
        -h|--help) usage; exit 1 ;;
        -r|--remove) rollback; exit 1 ;;
        --) shift; break ;;
        *) usage; exit 1 ;;
    esac
done
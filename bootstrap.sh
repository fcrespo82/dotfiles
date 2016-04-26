#!/usr/bin/env bash

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PURPLE="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
BOLD="\033[1m"
RESET="\033[0m"

function install {
    export DOTFILES_ROOT=$(pwd)

    echo -e "${BOLD}${YELLOW}[CALLING]${RESET} Common dotfiles install script"
    if [[ -e $DOTFILES_ROOT/os/common/install ]]; then
        bash $DOTFILES_ROOT/os/common/install
    fi

    if [[ $(uname -a) = *[Ss]ynology* ]]; then
        local DOTFILES_OS="nas"
    elif [[ $(uname -a) = *[Ll]inux* ]]; then
        local DOTFILES_OS="linux"
    elif [[ $(uname -a) = *[Dd]arwin* ]]; then
        local DOTFILES_OS="mac"
    fi

    echo -e "${BOLD}${YELLOW}[CALLING]${RESET} $DOTFILES_OS dotfiles install script"
    if [[ -e $DOTFILES_ROOT/os/$DOTFILES_OS/install ]]; then
        bash $DOTFILES_ROOT/os/$DOTFILES_OS/install
    fi
}

#install

function remove {
    export DOTFILES_ROOT=$(pwd)

    echo -e "${BOLD}${YELLOW}[CALLING]${RESET} Common dotfiles remove script"
    if [[ -e $DOTFILES_ROOT/os/common/remove ]]; then
        bash $DOTFILES_ROOT/os/common/remove
    fi

    if [[ $(uname -a) = *[Ss]ynology* ]]; then
        local DOTFILES_OS="nas"
    elif [[ $(uname -a) = *[Ll]inux* ]]; then
        local DOTFILES_OS="linux"
    elif [[ $(uname -a) = *[Dd]arwin* ]]; then
        local DOTFILES_OS="mac"
    fi

    echo -e "${BOLD}${YELLOW}[CALLING]${RESET} $DOTFILES_OS dotfiles remove script"
    if [[ -e $DOTFILES_ROOT/os/$DOTFILES_OS/remove ]]; then
        bash $DOTFILES_ROOT/os/$DOTFILES_OS/remove
    fi
}

function usage {
    echo "usage:
    bootstrap.sh [install|remove|-h|--help]"
}

function help {
    echo "
options:
    install         Install dotfiles
    remove          Remove dotfiles
    -h|--help       Show this help"
}

key="$1"
case $key in
    install)
    install
    shift # past argument
    ;;
    remove)
    remove
    shift # past argument
    ;;
    -h|--help)
    usage
    help
    ;;
    *)
    usage # unknown option
    ;;
esac
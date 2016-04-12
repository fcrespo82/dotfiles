#!/usr/bin/env bash

DOTFILES_ROOT=$(pwd)

# if [ "$UID" -ne 0 ]; then
#     echo "You must be root to run this script"
#     exit 1
# fi

if [[ -e $HOME/.bash_profile ]]; then
    if [[ $(grep -c "$DOTFILES_ROOT/bash_profile" $HOME/.bash_profile) -eq 0 ]]; then
        echo "if [ -e $DOTFILES_ROOT/bash_profile ]; then
    export DOTFILES_ROOT=$DOTFILES_ROOT
    source $DOTFILES_ROOT/bash_profile
fi" >> $HOME/.bash_profile
    fi
else
    echo "if [ -e $DOTFILES_ROOT/bash_profile ]; then
    export DOTFILES_ROOT=$DOTFILES_ROOT
    source $DOTFILES_ROOT/bash_profile
fi" >> $HOME/.bash_profile;
fi

if [[ -e $HOME/.bashrc ]]; then
    if [[ $(grep -c "$HOME/.bash_profile" $HOME/.bashrc) -eq 0 ]]; then
        echo "if [ -e $HOME/.bash_profile ]; then
    source $HOME/.bash_profile
fi" >> $HOME/.bashrc
    fi
else
    echo "if [ -e $HOME/.bash_profile ]; then
    source $HOME/.bash_profile
fi" >> $HOME/.bashrc;
fi

if [[ ! -e $HOME/.gitconfig ]]; then
    echo "Linking $HOME/.gitconfig -> $DOTFILES_ROOT/home/.gitconfig"
    ln -fs $DOTFILES_ROOT/home/.gitconfig $HOME/.gitconfig
fi

if [[ ! -e $HOME/.hushlogin ]]; then
    echo "Linking $HOME/.hushlogin -> $DOTFILES_ROOT/home/.hushlogin"
    ln -fs $DOTFILES_ROOT/home/.hushlogin $HOME/.hushlogin
fi

if [[ ! -e $HOME/.ssh/config ]]; then
    echo "Linking $HOME/.ssh/config -> $DOTFILES_ROOT/home/.ssh/config"
    ln -fs $DOTFILES_ROOT/home/.ssh/config $HOME/.ssh/config
fi

if [[ $(uname -a) = *[Ll]inux* ]]; then
    if [[ ! -e $HOME/.xstartup ]]; then
        echo "Linking $HOME/.xstartup -> $DOTFILES_ROOT/home/.xstartup"
        ln -fs $DOTFILES_ROOT/home/.xstartup $HOME/.xstartup
    fi
fi


#!/usr/bin/env bash

DOTFILES_ROOT=$(pwd)

if [[ -e $HOME/.bash_profile ]]; then
    if [[ $(grep -c "$DOTFILES_ROOT/bash_profile.sh" $HOME/.bash_profile) -eq 0 ]]; then
        echo "if [ -e $DOTFILES_ROOT/bash_profile.sh ]; then
    export DOTFILES_ROOT=$DOTFILES_ROOT
    source $DOTFILES_ROOT/bash_profile.sh
fi" >> $HOME/.bash_profile
    fi
else
    echo "if [ -e $DOTFILES_ROOT/bash_profile.sh ]; then
    export DOTFILES_ROOT=$DOTFILES_ROOT
    source $DOTFILES_ROOT/bash_profile.sh
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
    ln -s $DOTFILES_ROOT/.gitconfig $HOME/.gitconfig
fi

if [[ ! -e $HOME/.hushlogin ]]; then
    ln -s $DOTFILES_ROOT/.hushlogin $HOME/.hushlogin
fi

# if [[ ! -e $HOME/.vimrc ]]; then
#     ln -s $DOTFILES_ROOT/.vimrc $HOME/.vimrc
# fi

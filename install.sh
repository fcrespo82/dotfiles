#!/usr/bin/bash

DOTFILES_ROOT=$(pwd)

if [[ -e $HOME/.bash_profile ]] && [[ $(grep -c "$DOTFILES_ROOT/bash_profile" $HOME/.bash_profile) -eq 0 ]]; then
    echo "if [ -e $DOTFILES_ROOT/bash_profile ]; then
    export DOTFILES_ROOT=$DOTFILES_ROOT
    source $DOTFILES_ROOT/bash_profile
fi" >> $HOME/.bash_profile
fi

if [[ -e $HOME/.bashrc ]] && [[ $(grep -c "$DOTFILES_ROOT/bashrc" $HOME/.bashrc) -eq 0 ]]; then
    echo "if [ -e $DOTFILES_ROOT/bashrc ]; then
    source $DOTFILES_ROOT/bashrc
fi" >> $HOME/.bashrc
fi

if [[ ! -e $HOME/.gitconfig ]]; then
    ln -s $DOTFILES_ROOT/.gitconfig $HOME/.gitconfig
fi

if [[ ! -e $HOME/.hushlogin ]]; then
    ln -s $DOTFILES_ROOT/.hushlogin $HOME/.hushlogin
fi

if [[ ! -e $HOME/.vimrc ]]; then
    ln -s $DOTFILES_ROOT/.vimrc $HOME/.vimrc
fi

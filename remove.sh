#!/usr/bin/env bash

DOTFILES_ROOT=$(pwd)

# if [[ -e $HOME/.bash_profile ]]; then
#     if [[ $(grep -c "$DOTFILES_ROOT/bash_profile.sh" $HOME/.bash_profile) -eq 0 ]]; then
#         echo "if [ -e $DOTFILES_ROOT/bash_profile.sh ]; then
#     export DOTFILES_ROOT=$DOTFILES_ROOT
#     source $DOTFILES_ROOT/bash_profile.sh
# fi" >> $HOME/.bash_profile
#     fi
# else
#     echo "if [ -e $DOTFILES_ROOT/bash_profile.sh ]; then
#     export DOTFILES_ROOT=$DOTFILES_ROOT
#     source $DOTFILES_ROOT/bash_profile.sh
# fi" >> $HOME/.bash_profile;
# fi

# if [[ -e $HOME/.bashrc ]]; then
#     if [[ $(grep -c "$HOME/.bash_profile" $HOME/.bashrc) -eq 0 ]]; then
#         echo "if [ -e $HOME/.bash_profile ]; then
#     source $HOME/.bash_profile
# fi" >> $HOME/.bashrc
#     fi
# else
#     echo "if [ -e $HOME/.bash_profile ]; then
#     source $HOME/.bash_profile
# fi" >> $HOME/.bashrc;
# fi


echo "Removing $HOME/.gitconfig"
rm -f $HOME/.gitconfig

echo "Removing $HOME/.hushlogin"
rm -f $HOME/.hushlogin

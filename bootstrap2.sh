#!/usr/bin/env zsh 

if [ "$(which zsh)" = "" ]; then 
	echo "Please install zsh first"
	exit 1
fi

autoload -Uz compinit && compinit
autoload -Uz colors && colors


if [ -z "${DOTFILES_DIR}" ]; then 
    export DOTFILES_DIR=/tmp/.dotfiles
fi

linkedfiles=(
    .gitconfig
    .vim
    .vimrc
    .zshrc
)

backup() {
    date=`date '+%Y_%m_%d-%H_%M_%S'`
    backup=$DOTFILES_DIR/backup/$date
    echo "Backing up to $backup"
    echo mkdir -p $backup
    for file in ${linkedfiles[@]}; do
        echo mv "$HOME/$file" $backup
    done
}

check() {
    echo "This files would be overriden. I'll make a backup first."
    for file in ${linkedfiles[@]}; do
        if [ -e "$HOME/$file" ]; then
            echo $bg[red]\*$file$reset_color
        else
            echo $fg[green]$file$reset_color
        fi
    done
}

install() {
    for file in ${linkedfiles[@]}; do
        echo "ln -s \"$file\" \"$HOME/$file\""
    done
}

main() {
    check
    read "REPLY?Make a backup of your files and install to $DOTFILES_DIR? (y/n) ";
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup
        install
    fi;
}
main
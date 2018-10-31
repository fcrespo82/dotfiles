#!/usr/bin/env zsh

if [ "$(which zsh)" = "" ]; then 
	echo "Please install zsh first"
	exit 1
fi

autoload -Uz compinit && compinit
autoload -Uz colors && colors

if [ -z "${DOTFILES_DIR}" ]; then 
    export DOTFILES_DIR=$HOME/.dotfiles
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
    for file in ${linkedfiles[@]}; do
        if [ -e "$HOME/$file" ]; then
            mkdir -p $backup
            rsync -Ea "$HOME/$file" $backup/
            rm -rf $HOME/$file
        fi
    done
}

check() {
    echo "This files marked with $bg[red]*$reset_color would be overriden. I'll make a backup first."
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
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    done
    export DOTFILES_DIR=$DOTFILES_DIR > $HOME/.dotfiles_dir
	echo "Sourcing..."
	source $DOTFILES_DIR/.zshrc
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

#!/usr/bin/env bash
. ./utils

ensure_zsh

/usr/bin/zsh <<'EOF'
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
    echo export DOTFILES_DIR=$DOTFILES_DIR > $HOME/.dotfiles_dir
	echo "Sourcing..."
	source $DOTFILES_DIR/.zshrc
    case $(uname -s) in
        Darwin)
            install_daemon
            ;;
    esac
}

install_daemon() {
    echo "You will need sudo password to install Launch Daemons"
    set -x
    sed 's@\[DOTFILES\]@'"$DOTFILES_DIR"'@' $DOTFILES_DIR/macOS/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist > /tmp/br.com.crespo.dotfiles.beacon.plist
    sudo chown root:staff /tmp/br.com.crespo.dotfiles.beacon.plist
    sudo chmod 664 /tmp/br.com.crespo.dotfiles.beacon.plist
    sudo mv /tmp/br.com.crespo.dotfiles.beacon.plist /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
    set +x
}

main() {
    check
    if [[ "$1" == "y" ]]; then
        backup
        install
    else
        read "REPLY?Make a backup of your files and install to $DOTFILES_DIR? (y/n) ";
        echo "";
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            backup
            install
        fi;
    fi;
}
main $1
EOF
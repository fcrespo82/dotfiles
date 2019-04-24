#!/usr/bin/env bash
. ./utils

ensure_zsh

$(which zsh) << EOF
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

install_dotfiles() {
    source $DOTFILES_DIR/apps
    for file in ${linkedfiles[@]}; do
        ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
    done
    echo export DOTFILES_DIR=$DOTFILES_DIR > $HOME/.dotfiles_dir
	echo "Sourcing..."
	source $DOTFILES_DIR/.zshrc
    case $(uname -s) in
        Darwin)
            install_daemon
            install_fonts_osx
            ;;
        Linux)
            install_fonts_linux
            ;;
    esac
}

install_fonts_linux() {
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    curl -fLo "Fura Code Retina Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete.ttf

    curl -fLo i_all.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_all.sh
    curl -fLo i_dev.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_dev.sh
    curl -fLo i_fa.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_fa.sh
    curl -fLo i_fae.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_fae.sh
    curl -fLo i_iec.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_iec.sh
    curl -fLo i_linux.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_linux.sh
    curl -fLo i_material.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_material.sh
    curl -fLo i_oct.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_oct.sh
    curl -fLo i_ple.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_ple.sh
    curl -fLo i_pom.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_pom.sh
    curl -fLo i_seti.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_seti.sh
	
    cat << EOF2
Usage:

source ~/.local/share/fonts/i_{all,dev,fa,fae,iec,linux,material,oct,ple,pom,seti}.sh

Use $i_<icon_name> where you want it.
EOF2
}

install_fonts_osx() {
    cd ~/Library/Fonts 
    curl -fLo "Fura Code Retina Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete.ttf

    curl -fLo i_all.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_all.sh
    curl -fLo i_dev.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_dev.sh
    curl -fLo i_fa.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_fa.sh
    curl -fLo i_fae.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_fae.sh
    curl -fLo i_iec.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_iec.sh
    curl -fLo i_linux.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_linux.sh
    curl -fLo i_material.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_material.sh
    curl -fLo i_oct.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_oct.sh
    curl -fLo i_ple.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_ple.sh
    curl -fLo i_pom.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_pom.sh
    curl -fLo i_seti.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_seti.sh
    
    cat << EOF2
Usage:

source ~/Library/Fonts/i_{all,dev,fa,fae,iec,linux,material,oct,ple,pom,seti}.sh

Use $i_<icon_name> where you want it.
EOF2
}

install_daemon() {
    echo "You will need sudo password to install Launch Daemons"
    set -x
    launchctl stop br.com.crespo.dotfiles.beacon
    launchctl unload -w /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
    sed 's@\[DOTFILES\]@'"$DOTFILES_DIR"'@' $DOTFILES_DIR/macOS/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist > /tmp/br.com.crespo.dotfiles.beacon.plist
    sudo chown root:wheel /tmp/br.com.crespo.dotfiles.beacon.plist
    sudo mv /tmp/br.com.crespo.dotfiles.beacon.plist /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
    launchctl load -w /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
    launchctl start br.com.crespo.dotfiles.beacon
    set +x
}

main() {
    check
    if [ "$DOTFILES_UNATTENDED" = "YES" ]; then
        backup
        install_dotfiles
    else
        echo "Make a backup of your files and install to $DOTFILES_DIR? (y/n)"
        read REPLY
        echo "";
        if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
            backup
            install_dotfiles
        fi;
    fi;
}
main
EOF
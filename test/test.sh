#!/usr/bin/env zsh

main() {
    if [[ "$1" == "y" ]]; then
        echo "Installing anyway"
	else
		read "REPLY?Make a backup of your files and install to $DOTFILES_DIR? (y/n) ";
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo backup
			echo install
		fi;
    fi
}

main $1
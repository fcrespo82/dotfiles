#!/usr/bin/env zsh 

if [ "$(which zsh)" = "" ]; then 
	echo "Please install zsh first"
	exit 1
fi

autoload -Uz compinit && compinit
autoload -Uz colors && colors

dest=tmp

function realpath() { python -c "import os,sys; print(os.path.realpath(sys.argv[1]))" "$1"; }

function install() {
	rsync -avh --no-perms src/ $dest
	location=$(realpath $dest)
	sed -i "1s;^;export DOTFILES=\"$location\"\n;" $dest/.zshrc
	echo "Sourcing"
	source $dest/.zshrc
}

if [ "$1" = "--force" -o "$1" = "-f" ]; then
	install;
else
	list=$(find src | xargs -n1 -J% echo % | sed s/src/$dest/g | tail -n+2)
	echo "This will override the files marked with "$bg[red] \* $reset_color", the other files don't exist in your system and are safe to install."
	for i in ${list[@]}; do
		echo $bg
		if [ -e "$i" ]; then
			echo $bg[red] \* $i $reset_color
		else
			echo $fg[green] $i $reset_color
		fi
	done
	read "REPLY?This will overwrite existing files in your destination($dest) directory. Are you sure? (y/n) ";
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		install;
	fi;
fi;
unset install;
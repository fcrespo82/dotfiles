linkedfiles='.gitconfig .vim .vimrc .zshrc'

start() {
	check
	if [ ${DOTFILES_UNATTENDED+x} ]; then # Check if var is not set as said in http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
		backup
		install_dotfiles
	else
		printf "Make a backup of your files and install to $DOTFILES_DIR? (y/n)\n"
		read -r REPLY
		printf "\n"
		if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
			backup
			install_dotfiles
		fi
	fi
}

check() {
	printf "${BLUE}This files marked with ${RED}*${BLUE} would be overriden. I'll make a backup first.${NORMAL}\n"
	for file in $linkedfiles; do
		if [ -e "$HOME"/"$file" ]; then
			printf "${RED}*$file${NORMAL}\n"
		else
			printf "${GREEN}$file${NORMAL}\n"
		fi
	done
}

backup() {
	date=$(date '+%Y_%m_%d-%H_%M_%S')
	backup="$DOTFILES_DIR"/backup/"$date"
	for file in $linkedfiles; do
		if [ -e "$HOME"/"$file" ]; then
			mkdir -p "$backup"
			printf "${YELLOW}Backing up $HOME/$file to $backup/$file${NORMAL}\n"
			cp -rL "$HOME/$file" "$backup"/
			rm -rf "${HOME:?}/$file"
		fi
	done
}

install_dotfiles() {
	. "$DOTFILES_DIR/extras"
	for file in $linkedfiles; do
		printf "${YELLOW}Linking $DOTFILES_DIR/$file to $HOME/$file${NORMAL}\n"
		ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
	done
	echo export DOTFILES_DIR=$DOTFILES_DIR >$HOME/.dotfiles_dir
	case $(uname -s) in
	Darwin)
		install_daemon
		;;
	esac
	install_fonts
}

install_daemon() {
	printf "${BLUE}Installing Daemon${NORMAL}\n"
	printf "${YELLOW}You will need sudo password to install Launch Daemons${NORMAL}\n"
	set -x
	launchctl stop br.com.crespo.dotfiles.beacon
	launchctl unload -w /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
	sed 's@\[DOTFILES\]@'"$DOTFILES_DIR"'@' $DOTFILES_DIR/macOS/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist >/tmp/br.com.crespo.dotfiles.beacon.plist
	sudo chown root:wheel /tmp/br.com.crespo.dotfiles.beacon.plist
	sudo mv /tmp/br.com.crespo.dotfiles.beacon.plist /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
	launchctl load -w /Library/LaunchDaemons/br.com.crespo.dotfiles.beacon.plist
	launchctl start br.com.crespo.dotfiles.beacon
	set +x
}

install_fonts() {
	printf "${BLUE}Installing Nerd-Fonts${NORMAL}\n"
	case $(uname -s) in
	Darwin)
		fonts_path="$HOME"/Library/Fonts
		;;
	Linux)
		fonts_path="$HOME"/.local/share/fonts
		;;
	esac
	
	mkdir -p $fonts_path
	cd $fonts_path
	printf "${YELLOW}Fura Code Retina Nerd Font Complete${NORMAL}\n"
	curl -sSL -o "Fura Code Retina Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fura%20Code%20Retina%20Nerd%20Font%20Complete.ttf

	printf "${BLUE}Installing Nerd-Font Shell Helpers${NORMAL}\n"
	curl -sSL -o i_all.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_all.sh
	curl -sSL -o i_dev.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_dev.sh
	curl -sSL -o i_fa.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_fa.sh
	curl -sSL -o i_fae.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_fae.sh
	curl -sSL -o i_iec.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_iec.sh
	curl -sSL -o i_linux.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_linux.sh
	curl -sSL -o i_material.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_material.sh
	curl -sSL -o i_oct.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_oct.sh
	curl -sSL -o i_ple.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_ple.sh
	curl -sSL -o i_pom.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_pom.sh
	curl -sSL -o i_seti.sh https://github.com/ryanoasis/nerd-fonts/raw/master/bin/scripts/lib/i_seti.sh

	cat <<EOF
Usage:

. $fonts_path/i_{all,dev,fa,fae,iec,linux,material,oct,ple,pom,seti}.sh

Use $i_<icon_name> where you want it.
EOF
}

main() {
	# Use colors, but only if connected to a terminal, and that terminal
	# supports them.
	if command -v which tput >/dev/null 2>&1; then
		ncolors=$(tput colors)
	fi
	if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
		RED="$(tput setaf 1)"
		GREEN="$(tput setaf 2)"
		YELLOW="$(tput setaf 3)"
		BLUE="$(tput setaf 4)"
		BOLD="$(tput bold)"
		NORMAL="$(tput sgr0)"
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		NORMAL=""
	fi

	# Only enable exit-on-error after the non-critical colorization stuff,
	# which may fail on systems lacking tput or terminfo
	set -e

	if ! command -v zsh >/dev/null 2>&1; then
		printf "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!\n"
		exit
	fi

	if [ -z "$DOTFILES_DIR" ]; then
		DOTFILES_DIR=~/.dotfiles
	fi

	if [ -d "$DOTFILES_DIR" ]; then
		printf "${YELLOW}You already have Dotfiles installed.${NORMAL}\n"
		printf "You'll need to remove $DOTFILES_DIR if you want to re-install.\n"
		exit
	fi

	# Prevent the cloned repository from having insecure permissions. Failing to do
	# so causes compinit() calls to fail with "command not found: compdef" errors
	# for users with insecure umasks (e.g., "002", allowing group writability). Note
	# that this will be ignored under Cygwin by default, as Windows ACLs take
	# precedence over umasks except for filesystems mounted with option "noacl".
	umask g-w,o-w

	printf "${BLUE}Cloning Dotfiles...${NORMAL}\n"
	command -v git >/dev/null 2>&1 || {
		echo "Error: git is not installed"
		exit 1
	}
	# The Windows (MSYS) Git is not compatible with normal use on cygwin
	if [ "$OSTYPE" = cygwin ]; then
		if git --version | grep msysgit >/dev/null; then
			echo "Error: Windows/MSYS Git is not supported on Cygwin"
			echo "Error: Make sure the Cygwin git package is installed and is first on the path"
			exit 1
		fi
	fi
	env git clone -b new-installer --single-branch --depth=1 https://github.com/fcrespo82/dotfiles.git "$DOTFILES_DIR" || {
		printf "Error: git clone of Dotfiles repo failed\n"
		exit 1
	}

	start

	printf "${GREEN}"
	printf '%s' "$GREEN"
	printf '%s\n' '    ____        __  _____ __         '
	printf '%s\n' '   / __ \____  / /_/ __(_) /__  _____'
	printf '%s\n' '  / / / / __ \/ __/ /_/ / / _ \/ ___/'
	printf '%s\n' ' / /_/ / /_/ / /_/ __/ / /  __(__  ) '
	printf '%s\n' '/_____/\____/\__/_/ /_/_/\___/____/  ....is now installed!'
	echo ''

	printf "${NORMAL}"
	env zsh -l
}

main

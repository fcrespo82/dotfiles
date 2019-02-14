source $DOTFILES_DIR/utils

ensure_mbeacon() {
	if [ -z $(command -v mbeacon) ]; then
		echo "Installing mbeacon"
		case $(uname -s) in
			Darwin)
				ensure_homebrew
				brew tap watr/formulae && brew install mbeacon
				;;
		esac
	fi
}

start_beacon() {
	case $(uname -s) in
		Darwin)
			ensure_mbeacon
			uuid=$(system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }')
			mbeacon -uuid $uuid
			;;
	esac
}

start_beacon